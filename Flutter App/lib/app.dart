import 'package:demoapp/Bloc/remote_data_cubit.dart';
import 'package:demoapp/data/model/model.dart';
import 'package:demoapp/Bloc/model_cubit.dart';
import 'package:demoapp/Bloc/model_state.dart';
import 'package:demoapp/widget/tab1.dart';
import 'package:demoapp/widget/tab2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection.dart' as di;

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
    // 
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
                  : BlocBuilder<UserDataRepoCubit, UserProfileState>(
                      builder: (_, __) {
                      return TabBarView(
                          key: const Key('TAB'),
                          controller: _tabController,
                          children: [
                            BlocProvider(
                                create: (_) => di.sl<RemoteUserDataRepoCubit>(),
                                child: const UserProfileListTab1()),
                            const UserProfileListTab2(),
                          ]);
                    });
            }));
  }
}

class UserProfileListTile extends StatelessWidget {
  final UserProfile user;
  final Function(bool?)? onChanged;
  const UserProfileListTile({Key? key, required this.user, this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<bool> getData() async {
      bool isSelected = await context
          .select((UserDataRepoCubit e) => e.isSelecUsersId(user.id));
      return isSelected;
    }

    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(user.imgURL)),
      title: Text(user.name),
      trailing: onChanged == null
          ? const SizedBox()
          : FutureBuilder<bool>(
              future: getData(),
              builder: (context, snapshot) {
                return Checkbox(
                    key: Key('Checkbox${user.id}'),
                    value: snapshot.data ?? false,
                    onChanged: onChanged);
              }),
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
