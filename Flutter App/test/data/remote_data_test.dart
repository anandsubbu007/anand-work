// import 'dart:convert';
// import 'dart:io';

// import 'package:demoapp/data/constant.dart';
// import 'package:demoapp/data/dataProvider/remote_data.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:http/http.dart' as http;

// class MockHttpClient extends Mock implements http.Client {}

// void main() {
//   late RemoteDataSourceImp dataSource;
//   late MockHttpClient mockHttpClient;

//   setUp(() {
//     mockHttpClient = MockHttpClient();
//     dataSource = RemoteDataSourceImp(client: mockHttpClient);
//   });
//   // const initialItem = UserProfile(
//   //     id: '1',
//   //     imgURL: 'https://avatars.githubusercontent.com/u/1?v=4',
//   //     name: 'mojombo');
//   final uri = Uri.parse(Urls.userQuery(0, 1));
//   void setUpMockHttpClientSuccess200() {
//     when(mockHttpClient.get(uri)).thenAnswer((_) async => http.Response(
//         json.encode({
//           'login': 'mojombo',
//           'id': '1',
//           'avatar_url': 'https://avatars.githubusercontent.com/u/1?v=4',
//         }),
//         200));
//   }

//   void setUpMockHttpClientFailure404() {
//     when(mockHttpClient.get(Uri.parse(''), headers: anyNamed('headers')))
//         .thenAnswer((_) async => http.Response('Something went wrong', 404));
//   }

//   group('onUserTap', () {
//     // test(
//     //   'Check That Data Stored Change On Tap',
//     //   () async {
//     //     await dataSource.fetchUser(0, 10);
//     //   },
//     // );
//     test(
//       '''should perform a GET request on a URL with number
//        being the endpoint and with application/json header''',
//       () async {
//         // arrange
//         setUpMockHttpClientSuccess200();
//         // act
//         await dataSource.fetchUser(0, 1);
//         // assert
//         verify(mockHttpClient.get(
//           Uri.parse(Urls.userQuery(0, 1)),
//           headers: {'Content-Type': 'application/json'},
//         ));
//       },
//     );

//     test(
//       'should throw a ServerException when the response code is 404 or other',
//       () async {
//         // arrange
//         setUpMockHttpClientFailure404();
//         // act
//         final call = dataSource.fetchUser(0, 1);
//         print('call:: $call');
//         // assert
//         expect(call, throwsA(const TypeMatcher<HttpException>()));
//       },
//     );
//   });
// }
