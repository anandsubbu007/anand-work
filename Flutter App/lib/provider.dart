// Singleton
import 'package:demoapp/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

DataProvider provider = DataProvider();

class DataProvider {
  static final DataProvider _singleton = DataProvider._internal();

  factory DataProvider() {
    return _singleton;
  }
  DataProvider._internal();
  SharedPreferences? pref;
  Future init() async {
    pref = await SharedPreferences.getInstance();
    // selecUsersIds = pref!.getKeys().toList();
    selectedUsers = pref!
        .getKeys()
        .map((e) => UserModel.fromJson(pref!.getString(e)!))
        .toList();
  }

  List<String> get selecUsersIds => selectedUsers.map((e) => e.id).toList();
  List<UserModel> selectedUsers = [];

  Future onTap(UserModel user) async {
    bool isAv = selecUsersIds.contains(user.id);
    if (isAv) {
      await pref!.remove(user.id);
      selectedUsers.removeWhere((e) => e.id == user.id);
    } else {
      await pref!.setString(user.id, user.toJson());
      selectedUsers.add(user);
    }
    // selecUsersIds = pref!.getKeys().toList();
  }

  Future deSelectAll() async {
    await pref!.clear();
    selectedUsers = [];
    // selecUsersIds = [];
  }
}
