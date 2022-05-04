import 'dart:convert';

import 'package:demoapp/tab2.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:demoapp/tabs1.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Test',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'Flutter Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2);
    super.initState();
  }

  Future<SharedPreferences> getDbInst() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs;
  }

  List<UserModel> datas = [];
  // await prefs.setInt('counter', 10);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: TabBar(controller: _tabController, tabs: const [
          Tab(child: Text('Tab 1')),
          Tab(child: Text('Tab 2')),
        ]),
      ),
      body: FutureBuilder<SharedPreferences>(
          future: getDbInst(),
          builder: (context, snapshot) {
            bool isLoading = snapshot.connectionState != ConnectionState.done;
            return isLoading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(controller: _tabController, children: [
                    UserListTab1(
                        pref: snapshot.data!,
                        userData: () => datas,
                        userDataUpdate: (ch) => datas = ch),
                    UserListTab2(pref: snapshot.data!)
                  ]);
          }),
    );
  }
}

class UserListTile extends StatelessWidget {
  final UserModel user;
  final bool? isSelected;
  final Function(bool?)? onChanged;
  const UserListTile(
      {Key? key, required this.user, this.isSelected, this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(user.imgURL)),
      title: Text(user.name),
      trailing: onChanged == null
          ? null
          : Checkbox(value: isSelected, onChanged: onChanged),
    );
  }
}

class UserModel {
  String name;
  String id;
  String imgURL;
  UserModel({
    required this.name,
    required this.id,
    required this.imgURL,
  });

  Map<String, dynamic> toMap() {
    return {
      'login': name,
      'id': id,
      'avatar_url': imgURL,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['login'] ?? '',
      id: map['id'].toString(),
      imgURL: map['avatar_url'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}

class Utils {
  BuildContext context;
  Utils(this.context);

  void showLoading() {
    showDialog(
        context: context,
        builder: (ctx) => Dialog(
              child: SizedBox(
                width: 200,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Center(child: CircularProgressIndicator())
                    ]),
              ),
            ));
  }
}
