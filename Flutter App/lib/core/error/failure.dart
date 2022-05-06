import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

// General failures
class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

// ignore: must_be_immutable
class FailureExceptation extends Failure {
  String? message;
  String? type;
  FailureExceptation({this.message, this.type});
}
