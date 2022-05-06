import 'package:dartz/dartz.dart';
import 'package:demoapp/core/error/failure.dart';
import 'package:demoapp/data/model/model.dart';
import 'package:demoapp/data/repo/repo.dart';

class OnTapUserProfile {
  final UserDataRepo repository;
  OnTapUserProfile(this.repository);
  Future<Either<Failure, List<UserProfile>>> call(UserProfile user) async {
    return await repository.onTapUser(user);
  }
}
