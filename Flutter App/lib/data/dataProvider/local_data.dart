// Singleton Class For Local DB
import 'package:demoapp/data/model/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Singleton Class For Local DB
class LocalDatabase {
  static final LocalDatabase _singleton = LocalDatabase._internal();
  factory LocalDatabase() => _singleton;
  LocalDatabase._internal();
  SharedPreferences? pref;
  List<UserProfile> selectedUsers = [];

  Future init() async {
    pref = await SharedPreferences.getInstance();
    getLocalData();
  }

  Future getLocalData() async {
    selectedUsers = pref!
        .getKeys()
        .map((e) => UserProfile.fromJson(pref!.getString(e)!))
        .toList();
  }

  Future<List<UserProfile>> deleteAll() async {
    await pref!.clear();
    selectedUsers = [];
    return selectedUsers;
  }

  Future<List<UserProfile>> onTap(UserProfile user) async {
    bool isAv = pref!.containsKey(user.id);
    if (isAv) {
      await pref!.remove(user.id);
      selectedUsers.removeWhere((e) => e.id == user.id);
    } else {
      await pref!.setString(user.id, user.toJson());
      selectedUsers.add(user);
    }
    return selectedUsers;
  }
}
