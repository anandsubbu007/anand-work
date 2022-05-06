import 'package:demoapp/data/dataProvider/local_data.dart';
import 'package:demoapp/data/model/model.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class MockSharedPreferences extends Mock implements SharedPreferences {}

// @GenerateMocks([MockSharedPreferences])
void main() {
  late LocalDataSourceImp dataSource;
  late SharedPreferences mockSharedPreferences;

  setUp(() async {
    mockSharedPreferences = await SharedPreferences.getInstance();
    dataSource = LocalDataSourceImp(pref: mockSharedPreferences);
  });
  const initialItem = UserProfile(
      id: '1',
      imgURL: 'https://avatars.githubusercontent.com/u/1?v=4',
      name: 'mojombo');

  group('onUserTap', () {
    test(
      'Check That Data Stored Change On Tap',
      () async {
        bool isExist = mockSharedPreferences.containsKey(initialItem.id);
        await dataSource.onUserTap(initialItem);
        final data = mockSharedPreferences.getString(initialItem.id);
        if (isExist) {
          expect(data, null);
        } else {
          expect(UserProfile.fromJson(data!), equals(initialItem));
        }
      },
    );

    test(
      'Check Delete All User',
      () async {
        await dataSource.deleteAll();
        expect(mockSharedPreferences.getKeys().length, 0);
      },
    );
  });

  group('getLocalData', () {
    test(
      'Checking That Data Stored in Local',
      () async {
        if (!mockSharedPreferences.containsKey(initialItem.id)) {
          await dataSource.onUserTap(initialItem);
        }
        expect(mockSharedPreferences.getKeys().isNotEmpty, true);
      },
    );
  });
}
