import 'package:demoapp/BlocMethod/model.dart';
import 'package:demoapp/BlocMethod/model_cubit.dart';
import 'package:demoapp/BlocMethod/model_state.dart';
import 'package:demoapp/BlocMethod/tab1.dart';
import 'package:demoapp/BlocMethod/tab2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserProfileCubit(),
      child: MaterialApp(
          title: 'Flutter Test',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: const MyHomePage(title: 'Title')),
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

  Future getData() async {
    await context.read<UserProfileCubit>().init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          bottom: TabBar(controller: _tabController, tabs: const [
            Tab(key: Key('Tab 0'), child: Text('Tab 1')),
            Tab(key: Key('Tab 1'), child: Text('Tab 2')),
          ]),
        ),
        body: FutureBuilder(
            key: const Key('Inialize'),
            future: getData(),
            builder: (context, snapshot) {
              bool isLoading = snapshot.connectionState != ConnectionState.done;
              return isLoading
                  ? const Scaffold(
                      body: Center(child: CircularProgressIndicator()))
                  : BlocBuilder<UserProfileCubit, UserProfileState>(
                      builder: (_, __) {
                      return TabBarView(
                          key: const Key('TAB'),
                          controller: _tabController,
                          children: const [
                            UserProfileListTab1(),
                            UserProfileListTab2(),
                          ]);
                    });
            }));
  }
}

class UserProfileListTile extends StatelessWidget {
  final UserProfile user;
  final bool? isSelected;
  final Function(bool?)? onChanged;
  const UserProfileListTile(
      {Key? key, required this.user, this.isSelected, this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(user.imgURL)),
      title: Text(user.name),
      trailing: onChanged == null
          ? null
          : Checkbox(
              key: Key('Checkbox${user.id}'),
              value: isSelected,
              onChanged: onChanged),
    );
  }
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
