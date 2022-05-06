import 'package:dartz/dartz.dart';
import 'package:demoapp/core/error/failure.dart';
import 'package:demoapp/data/model/model.dart';
import 'package:demoapp/data/repo/repo.dart';
// import 'package:equatable/equatable.dart';

class GetSelectedUserData {
  final UserDataRepo repository;
  GetSelectedUserData(this.repository);
  Future<Either<Failure, List<UserProfile>>> call() async {
    return await repository.getSelectedUserList();
  }
}

class GetAvailableUserData {
  final UserDataRepo repository;
  GetAvailableUserData(this.repository);
  Future<Either<Failure, List<UserProfile>>> call(
      int offset, int length) async {
    return await repository.getUserList(offset, length);
  }
}
