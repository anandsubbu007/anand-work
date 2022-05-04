import 'dart:convert';

import 'package:demoapp/BlocMethod/model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserProfileCubit extends Cubit<int> {
  UserProfileCubit() : super(0);
  SharedPreferences? pref;
  Future init() async {
    pref = await SharedPreferences.getInstance();
    await getLocalData();
  }

  Future getLocalData() async {
    selectedUsers = pref!
        .getKeys()
        .map((e) => UserProfile.fromJson(pref!.getString(e)!))
        .toList();
  }

  List<String> get selecUsersIds => selectedUsers.map((e) => e.id).toList();
  List<UserProfile> selectedUsers = [];
  List<UserProfile> fetchedUsers = [];

  Future onTap(UserProfile user) async {
    bool isAv = pref!.containsKey(user.id);
    if (isAv) {
      await pref!.remove(user.id);
      selectedUsers.removeWhere((e) => e.id == user.id);
    } else {
      await pref!.setString(user.id, user.toJson());
      selectedUsers.add(user);
    }
    emit(state + 1);
  }

  Future deSelectAll() async {
    await pref!.clear();
    selectedUsers = [];
    emit(state - state);
  }

  Future fetchUsers(int count, bool intalized) async {
    if (!intalized) {
      if (fetchedUsers.isEmpty) {
        await fetchUserDatas(count);
      }
    } else {
      await fetchUserDatas(count);
    }
  }

  Future fetchUserDatas(int count) async {
    final offset = fetchedUsers.length + count;
    String url = 'https://api.github.com/users?per_page=$offset';
    final resp = await http.get(Uri.parse(url));
    final map = json.decode(resp.body);
    final userLst = (map as List).map((e) => UserProfile.fromMap(e));
    fetchedUsers = userLst.toList();
    emit(state + 1);
  }
}
