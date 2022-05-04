import 'package:demoapp/main.dart';
import 'package:demoapp/provider.dart';
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
    users = provider.selectedUsers;
    // selecUsersIds
    //     .map((e) => UserModel.fromJson(widget.pref.getString(e)!))
    //     .toList();
    return users;
  }

  Future onTap(UserModel user) async {
    // bool isAv = selecUsersIds.contains(user.id);
    Utils(context).showLoading();
    await provider.onTap(user);
    // if (isAv) {
    //   // selecUsersIds.removeWhere((e) => e == user.id);
    //   await widget.pref.remove(user.id);
    // } else {
    //   // selecUsersIds.add(user.id);
    //   users.add(user);
    //   await widget.pref.setString(user.id, user.toString());
    // }
    users.removeWhere((e) => e.id == user.id);
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
                  // selecUsersIds: () => selecUsersIds,
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
          await provider.deSelectAll();
          Navigator.pop(context);
          setState(() {});
        },
        label: const Text('Deselect All'),
      ),
    );
  }
}
