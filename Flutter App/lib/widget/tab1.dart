import 'package:demoapp/Bloc/remote_data_cubit.dart';
import 'package:demoapp/app.dart';
import 'package:demoapp/data/model/model.dart';
import 'package:demoapp/Bloc/model_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const listKey = Key('ListViewKey');
const userProfileListTab1Key = Key('UserProfileListTab1');

class UserProfileListTab1 extends StatefulWidget {
  const UserProfileListTab1({Key? key}) : super(key: key);

  @override
  State<UserProfileListTab1> createState() => _UserProfileListTab1State();
}

class _UserProfileListTab1State extends State<UserProfileListTab1> {
  bool isinitiated = false;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() async {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        if (isLoaded) {
          isLoaded = false;
          _key.currentState?.setState(() {});
          await getData();
          isLoaded = true;
          _key.currentState?.setState(() {});
        }
      }
    });
  }

  bool isLoaded = true;
  Future getData() async {
    // await Future.delayed(const Duration(seconds: 2));
    final output = await context
        .read<RemoteUserDataRepoCubit>()
        .fetchUser(10, isinitiated);
    if (!output.isSuccess) {
      SchedulerBinding.instance?.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(output.report)));
      });
    }
    isinitiated = true;
  }

  Future onTap(UserProfile user) async {
    Utils(context).showLoading();
    Navigator.pop(context);
  }

  final GlobalKey _key = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      key: userProfileListTab1Key,
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        bool isLoading = snapshot.connectionState != ConnectionState.done;
        return isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                      child: UserListBuilder(
                          scrollController: _scrollController,
                          isSelectedUser: false)),
                  LoadingCircle(key: _key, isLoading: () => !isLoaded)
                ],
              );
      },
    );
  }
}

class LoadingCircle extends StatefulWidget {
  final bool Function() isLoading;
  const LoadingCircle({Key? key, required this.isLoading}) : super(key: key);

  @override
  State<LoadingCircle> createState() => _LoadingCircleState();
}

class _LoadingCircleState extends State<LoadingCircle> {
  @override
  Widget build(BuildContext context) {
    return !widget.isLoading()
        ? const SizedBox()
        : const Padding(
            padding: EdgeInsets.all(15.0),
            child: Center(child: CircularProgressIndicator()));
  }
}

class UserListBuilder extends StatelessWidget {
  final ScrollController scrollController;
  final bool isSelectedUser;
  const UserListBuilder(
      {Key? key, required this.scrollController, required this.isSelectedUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<List<UserProfile>> getData() async {
      return isSelectedUser
          ? await context.watch<UserDataRepoCubit>().selectedUsers
          : context.watch<RemoteUserDataRepoCubit>().fetchedUsers;
    }

    return FutureBuilder<List<UserProfile>>(
        future: getData(),
        builder: (context, snapshot) {
          List<UserProfile> users = snapshot.data ?? [];
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return users.isEmpty
              ? const SizedBox.shrink()
              : ListView.separated(
                  key: listKey,
                  separatorBuilder: (c, i) => const Divider(),
                  controller: scrollController,
                  shrinkWrap: true,
                  restorationId: '${users.length}',
                  itemCount: users.length,
                  itemBuilder: (BuildContext context, i) {
                    return UserProfileListTile(
                      key: Key(users[i].id),
                      user: users[i],
                      // isSelected: selecUsersIds.contains(users[i].id),
                      onChanged: (v) async {
                        await context.read<UserDataRepoCubit>().onTap(users[i]);
                      },
                    );
                  },
                );
        });
  }
}
