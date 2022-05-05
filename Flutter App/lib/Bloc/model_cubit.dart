// ignore_for_file: avoid_print
import 'package:demoapp/data/dataProvider/local_data.dart';
import 'package:demoapp/data/model/model.dart';
import 'package:demoapp/Bloc/model_state.dart';
import 'package:demoapp/data/dataProvider/remote_user_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  UserProfileCubit() : super(UserProfileLoadInitial()) {
    selectedUsers = LocalDatabase().selectedUsers;
  }

  List<UserProfile> selectedUsers = [];
  List<UserProfile> fetchedUsers = [];
  LocalDatabase localDb = LocalDatabase();

  List<String> get selecUsersIds => selectedUsers.map((e) => e.id).toList();

  Future onTap(UserProfile user) async {
    selectedUsers = await localDb.onTap(user);
    emit(UserProfileOnSelectionChange([...selectedUsers]));
  }

  Future deleteAll() async {
    selectedUsers = await localDb.deleteAll();
    emit(UserProfileClearAll());
  }

  Future<Output<List<UserProfile>>> fetchUser(int count,
      [bool? intalized]) async {
    if (!(intalized ?? true)) {
      if (fetchedUsers.isEmpty) {
        var output = await fetchUserData(count);
        return output;
      } else {
        return Output(report: 'Data Load Not Required', isSuccess: true);
      }
    } else {
      var output = await fetchUserData(count);
      return output;
    }
  }

  Future<Output<List<UserProfile>>> fetchUserData(int count) async {
    var output = await RestAPI().fetchUser(fetchedUsers.length, count);
    if (output.isSuccess) {
      fetchedUsers = output.value ?? [];
    } else {
      output.value = fetchedUsers;
    }
    return output;
  }
}
