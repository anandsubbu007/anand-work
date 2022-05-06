import 'package:dartz/dartz.dart';
import 'package:demoapp/core/error/failure.dart';
import 'package:demoapp/data/dataProvider/local_data.dart';
import 'package:demoapp/data/dataProvider/remote_data.dart';
import 'package:demoapp/data/model/model.dart';

abstract class UserDataRepo {
  Future<Either<Failure, List<UserProfile>>> getUserList(
      int offset, int length);
  Future<Either<Failure, List<UserProfile>>> getSelectedUserList();
  Future<Either<Failure, List<UserProfile>>> onTapUser(UserProfile user);
}

class UserDataRepoImpl implements UserDataRepo {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;

  UserDataRepoImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<UserProfile>>> getSelectedUserList() {
    return localDataSource.getLocalData();
  }

  @override
  Future<Either<Failure, List<UserProfile>>> getUserList(
      int offset, int length) {
    return remoteDataSource.fetchUser(offset, length);
  }

  @override
  Future<Either<Failure, List<UserProfile>>> onTapUser(UserProfile user) {
    return localDataSource.onUserTap(user);
  }
}
