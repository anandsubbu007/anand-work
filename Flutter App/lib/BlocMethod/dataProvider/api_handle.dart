// ignore_for_file: file_names

import 'package:demoapp/BlocMethod/model/model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RestAPI implements GitHubUserProfile {
  static const String baseUrl = 'https://api.github.com/';
  @override
  Future<Output<List<UserProfile>>> fetchUser(int offset, int length) async {
    final off = offset + length;
    String url = '${baseUrl}users?per_page=$off';
    try {
      final resp = await http.get(Uri.parse(url));
      final map = json.decode(resp.body);
      final userLst = (map as List).map((e) => UserProfile.fromMap(e));
      final fetchedUsers = userLst.toList();
      return Output(
          report: 'Fetched Data From API',
          isSuccess: true,
          value: fetchedUsers);
    } catch (e) {
      return Output(report: 'Error: $e', isSuccess: false);
    }
  }
}

abstract class GitHubUserProfile {
  Future<Output<List<UserProfile>>> fetchUser(int offset, int length) async =>
      Output(report: '', isSuccess: true, value: []);
}
