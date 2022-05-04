import 'package:demoapp/main.dart';
import 'package:demoapp/tabs1.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserListTab2 extends StatefulWidget {
  final SharedPreferences pref;
  const UserListTab2({Key? key, required this.pref}) : super(key: key);

  @override
  State<UserListTab2> createState() => _UserListTab2State();
}

class _UserListTab2State extends State<UserListTab2> {
  int offset = 0; 
  Future<List<UserModel>> getData() async {
    final valls = widget.pref.getStringList('key');
    users = valls?.map((e) => UserModel.fromJson(e)).toList() ?? [];
    selecUsers = [...users];
    return users;
  }

  List<UserModel> selecUsers = [];

  Future onTap(UserModel user) async {
    bool isAv = selecUsers.map((e) => e.id).contains(user.id);
    if (isAv) {
      selecUsers.removeWhere((e) => e.id == user.id);
    } else {
      selecUsers.add(user);
    }
    Utils(context).showLoading();
    final List<String> vals = selecUsers.map((e) => e.toJson()).toList();
    await widget.pref.setStringList('key', vals);
    users = [...selecUsers];
    Navigator.pop(context);
  }

  final ScrollController _scrollController = ScrollController();
  List<UserModel> users = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<UserModel>>(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          bool isLoading = snapshot.connectionState != ConnectionState.done;
          if (isLoading && users.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Column(
              children: [
                Expanded(
                    child: UserListBuilder(
                  users: () => users,
                  selecUsers: () => selecUsers,
                  scrollController: _scrollController,
                  onTap: onTap,
                )),
                if (isLoading)
                  const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Center(child: CircularProgressIndicator()))
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Utils(context).showLoading();
          await widget.pref.setStringList('key', []);
          // selecUsers = [];
          // users = [...selecUsers];
          Navigator.pop(context);
          setState(() {});
        },
        label: const Text('Deselect All'),
      ),
    );
  }
}
