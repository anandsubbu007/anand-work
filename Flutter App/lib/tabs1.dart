import 'dart:convert';

import 'package:demoapp/main.dart';
import 'package:demoapp/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserListTab1 extends StatefulWidget {
  final SharedPreferences pref;
  final List<UserModel> Function() userData;
  final Function(List<UserModel>) userDataUpdate;
  const UserListTab1(
      {Key? key,
      required this.pref,
      required this.userData,
      required this.userDataUpdate})
      : super(key: key);

  @override
  State<UserListTab1> createState() => _UserListTab1State();
}

class _UserListTab1State extends State<UserListTab1> {
  bool intalized = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        if (!isLoad) {
          setState(() {});
        }
      }
    });
  }

  bool isLoad = false;
  int offset = 0;
  Future getData() async {
    isLoad = true;
    if (!intalized) {
      users = widget.userData().toList();
      if (users.isEmpty) await getDataFromCloud();
    } else {
      await getDataFromCloud();
    }
    selecUsersIds = widget.pref.getKeys().toList();
    isLoad = false;
    intalized = true;
  }

  Future getDataFromCloud() async {
    debugPrint('Getting Data From API');
    // print('offset: $offset');
    // int count = users.length;
    // String url = 'https://api.github.com/users?per_page=$offset?last_page=$count';
    offset = users.length + 10;
    String url = 'https://api.github.com/users?per_page=$offset';
    final resp = await http.get(Uri.parse(url));
    final map = json.decode(resp.body);
    final userLst = (map as List).map((e) => UserModel.fromMap(e));
    users = userLst.toList();
    // users.addAll(userLst);
    widget.userDataUpdate(users);
  }

  List<String> selecUsersIds = [];

  Future onTap(UserModel user) async {
    // bool isAv = selecUsersIds.contains(user.id);
    // if (isAv) {
    //   await widget.pref.remove(user.id);
    // } else {
    //   await widget.pref.setString(user.id, user.toJson());
    // }
    // selecUsersIds = widget.pref.getKeys().toList();
    Utils(context).showLoading();
    await provider.onTap(user);
    Navigator.pop(context);
  }

  final ScrollController _scrollController = ScrollController();
  List<UserModel> users = [];
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
                      // selecUsersIds: () => selecUsersIds,
                      scrollController: _scrollController,
                      onTap: onTap)),
              if (isLoading)
                const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Center(child: CircularProgressIndicator()))
            ],
          );
        }
      },
    );
  }
}

class UserListBuilder extends StatefulWidget {
  final List<UserModel> Function() users;
  // final List<String> Function() selecUsersIds;
  final ScrollController scrollController;
  final Function(UserModel) onTap;
  const UserListBuilder({
    Key? key,
    required this.users,
    required this.scrollController,
    required this.onTap,
    // required this.selecUsersIds
  }) : super(key: key);

  @override
  State<UserListBuilder> createState() => _UserListBuilderState();
}

class _UserListBuilderState extends State<UserListBuilder> {
  @override
  Widget build(BuildContext context) {
    final users = widget.users();
    // final selecUsersIds = widget.selecUsersIds();
    final selecUsersIds = provider.selecUsersIds;
    return ListView.separated(
      separatorBuilder: (c, i) => const Divider(),
      controller: widget.scrollController,
      shrinkWrap: true,
      itemCount: users.length,
      itemBuilder: (BuildContext context, i) {
        return UserListTile(
          user: users[i],
          isSelected: selecUsersIds.contains(users[i].id),
          onChanged: (v) {
            widget.onTap(users[i]);
            setState(() {});
          },
        );
      },
    );
  }
}
