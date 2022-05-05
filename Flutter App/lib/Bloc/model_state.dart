import 'package:demoapp/data/model/model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class UserProfileState extends Equatable {
  @override
  List<UserProfile> get props => [];
}

class UserProfileLoadInitial extends UserProfileState {}

class UserProfileOnSelectionChange extends UserProfileState {
  UserProfileOnSelectionChange(this.user);
  final List<UserProfile> user;
  @override
  List<UserProfile> get props => [...user];

  @override
  String toString() => 'UserProfileOnSelectionChange(users: ${user.length})';
}

class UserProfilenewData extends UserProfileState {
  UserProfilenewData(this.user);
  final List<UserProfile> user;
  @override
  List<UserProfile> get props => [...user];

  @override
  String toString() => 'UserProfilenewData(users: ${user.length})';
}

class UserProfileClearAll extends UserProfileState {
  @override
  List<UserProfile> get props => [];

  @override
  String toString() => 'UserProfileClearAll(users: [])';
}

class UserProfileLoadFailure extends UserProfileState {}




