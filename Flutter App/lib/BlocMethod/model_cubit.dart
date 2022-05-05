// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:demoapp/BlocMethod/model.dart';
import 'package:demoapp/BlocMethod/model_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserProfileCubit extends Cubit<UserProfileState> {
  UserProfileCubit() : super(UserProfileLoadInitial());
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
    emit(UserProfileOnSelectionChange([...selectedUsers]));
  }

  Future deSelectAll() async {
    await pref!.clear();
    selectedUsers = [];
    emit(UserProfileClearAll());
  }

  Future<Output<List<UserProfile>>> fetchUser(int count,
      [bool? intalized]) async {
    if (!(intalized ?? true)) {
      if (fetchedUsers.isEmpty) {
        var output = await RestAPI().fetchUser(fetchedUsers.length, count);
        fetchedUsers = output.value ?? [];
        return output;
      } else {
        return Output(report: 'Data Load Not Required', isSuccess: true);
      }
    } else {
      var output = await RestAPI().fetchUser(fetchedUsers.length, count);
      fetchedUsers = output.value ?? [];
      return output;
    }
    // emit(UserProfilenewData([...fetchedUsers]));
  }
}

class RestAPI implements GitHubUserProfile {
  static const String baseUrl = 'https://api.github.com/';
  @override
  Future<Output<List<UserProfile>>> fetchUser(int offset, int length) async {
    final off = offset + length;
    String url = '${baseUrl}users?per_page=$off';
    try {
      final resp = await http.get(Uri.parse(url));
      final map = json.decode(resp.body);
      final userLst = (map as List).map((e) => UserProfile.fromMap(e));
      final fetchedUsers = userLst.toList();
      return Output(
          report: 'Fetched Data From API',
          isSuccess: true,
          value: fetchedUsers);
    } catch (e) {
      return Output(report: 'Error: $e', isSuccess: false);
    }
  }
}

abstract class GitHubUserProfile {
  Future<Output<List<UserProfile>>> fetchUser(int offset, int length) async =>
      Output(report: '', isSuccess: true, value: []);
}
