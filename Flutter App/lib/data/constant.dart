class Urls {
  static const String baseUrl = 'https://api.github.com/';

  static String userQuery(int length, int offset) =>
      '$baseUrl/users?per_page=${length + offset}';
}
