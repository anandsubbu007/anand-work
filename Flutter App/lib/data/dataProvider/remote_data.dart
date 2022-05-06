// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:demoapp/core/error/failure.dart';
import 'package:http/http.dart' as http;

import 'package:demoapp/data/constant.dart';
import 'package:demoapp/data/model/model.dart';

class RemoteDataSourceImp implements RemoteDataSource {
  http.Client client;
  RemoteDataSourceImp({required this.client});
  @override
  Future<Either<Failure, List<UserProfile>>> fetchUser(
      int offset, int length) async {
    try {
      final fetchedUsers = await getFromApi(offset, length);
      return Right(fetchedUsers);
    } on FormatException catch (e) {
      return Left(FailureExceptation(
          message: e.toString(), type: e.runtimeType.toString()));
    } on HttpException catch (e) {
      return Left(FailureExceptation(
          message: e.toString(), type: e.runtimeType.toString()));
    } on SocketException catch (e) {
      return Left(FailureExceptation(
          message: e.toString(), type: e.runtimeType.toString()));
    } catch (e) {
      return Left(FailureExceptation(
          message: e.toString(), type: e.runtimeType.toString()));
    }
  }

  Future<List<UserProfile>> getFromApi(int offset, int length) async {
    String url = Urls.userQuery(length, offset);
    final resp = await client.get(Uri.parse(url));
    final map = json.decode(resp.body);
    final userLst = (map as List).map((e) => UserProfile.fromMap(e));
    final fetchedUsers = userLst.toList();
    return fetchedUsers;
  }
}

abstract class RemoteDataSource {
  Future<Either<Failure, List<UserProfile>>> fetchUser(int offset, int length);
}
