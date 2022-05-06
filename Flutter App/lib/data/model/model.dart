import 'dart:convert';

import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  const UserProfile({
    required this.id,
    required this.name,
    required this.imgURL,
  });

  final String id;
  final String name;
  final String imgURL;

  @override
  List<Object> get props => [id, name];

  Map<String, dynamic> toMap() {
    return {
      'login': name,
      'id': id,
      'avatar_url': imgURL,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
        id: map['id']?.toString() ?? '',
        name: map['login'] ?? '',
        imgURL: map['avatar_url'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory UserProfile.fromJson(String source) =>
      UserProfile.fromMap(json.decode(source));
}

class Output<T> {
  String report;
  int? statusCode;
  T value;
  bool isSuccess;
  Output(
      {required this.report,
      this.statusCode,
      required this.value,
      required this.isSuccess});
}
