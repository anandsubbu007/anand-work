// Singleton Class For Local DB
import 'package:demoapp/core/error/failure.dart';
import 'package:demoapp/data/model/model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dartz/dartz.dart';

abstract class LocalDataSource {
  Future<Either<Failure, List<UserProfile>>> getLocalData();
  Future<Either<Failure, bool>> deleteAll();
  Future<Either<Failure, List<UserProfile>>> onUserTap(UserProfile user);
}

// Singleton Class For Local DB
class LocalDataSourceImp implements LocalDataSource {
  final SharedPreferences pref;

  LocalDataSourceImp({required this.pref}) {
    getLocalData();
  }

  List<UserProfile> selectedUsers = [];

  @override
  Future<Either<Failure, List<UserProfile>>> getLocalData() async {
    try {
      selectedUsers = pref
          .getKeys()
          .map((e) => UserProfile.fromJson(pref.getString(e)!))
          .toList();
      return Right(selectedUsers);
    } on Exception {
      return Left(FailureExceptation());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteAll() async {
    try {
      await pref.clear();
      selectedUsers = [];
      return const Right(true);
    } on Exception {
      return Left(FailureExceptation());
    }
  }

  @override
  Future<Either<Failure, List<UserProfile>>> onUserTap(UserProfile user) async {
    try {
      bool isAv = pref.containsKey(user.id);
      if (isAv) {
        await pref.remove(user.id);
        selectedUsers.removeWhere((e) => e.id == user.id);
      } else {
        await pref.setString(user.id, user.toJson());
        selectedUsers.add(user);
      }
      return Right(selectedUsers);
    } on Exception {
      return Left(FailureExceptation());
    }
  }
}
