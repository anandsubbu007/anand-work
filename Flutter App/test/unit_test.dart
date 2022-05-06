import 'package:bloc_test/bloc_test.dart';
import 'package:demoapp/Bloc/remote_data_cubit.dart';
import 'package:demoapp/data/dataProvider/local_data.dart';
import 'package:demoapp/data/dataProvider/remote_data.dart';
import 'package:demoapp/data/model/model.dart';
import 'package:demoapp/Bloc/model_cubit.dart';
import 'package:demoapp/Bloc/model_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void main() {
  const initialItem = UserProfile(
      id: '1',
      imgURL: 'https://avatars.githubusercontent.com/u/1?v=4',
      name: 'mojombo');
  late UserDataRepoCubit taskCubit;
  late LocalDataSource localDataSource;
  late SharedPreferences sharedPreferences;
  late RemoteUserDataRepoCubit remoteuserRepor;

  setUp(() async {
    sharedPreferences = await SharedPreferences.getInstance();
    localDataSource = LocalDataSourceImp(pref: sharedPreferences);
    taskCubit = UserDataRepoCubit(localDataSource: localDataSource);
    remoteuserRepor = RemoteUserDataRepoCubit(
        remoteDataSource: RemoteDataSourceImp(client: http.Client()));
  });
  group('UserProfileCubit test', () {
    blocTest<RemoteUserDataRepoCubit, UserProfileState>(
      'emits [fetchUsers, UserProfilenewData] states for'
      'successful task loads',
      build: () => remoteuserRepor,
      act: (cubit) => cubit.fetchUser(1),
      expect: () => [
        // ({login: mojombo, id: 1, avatar_url: https://avatars.githubusercontent.com/u/1?v=4})
        UserProfileOnSelectionChange(const [initialItem])
      ],
    );

    blocTest<UserDataRepoCubit, UserProfileState>(
      'emits [Deselect All Selected Profile] with correct urgent tasks',
      build: () => taskCubit,
      act: (cubit) => cubit.deleteAll(),
      expect: () => [UserProfileClearAll()],
    );

    blocTest<UserDataRepoCubit, UserProfileState>(
      'emits [UserProfile On Tap: SelectionChange] with correct urgent tasks',
      build: () => taskCubit,
      act: (cubit) => cubit.onTap(initialItem),
      expect: () => [
        UserProfileOnSelectionChange(const [initialItem])
      ],
    );
    blocTest<UserDataRepoCubit, UserProfileState>(
      'emits [UserProfile on Tap Selected Profile to Deselect] with correct urgent tasks',
      build: () => taskCubit,
      act: (cubit) => cubit.onTap(initialItem),
      expect: () => [UserProfileOnSelectionChange(const [])],
    );
    blocTest<UserDataRepoCubit, UserProfileState>(
      'emits [Deselect All Selected Profile] with correct urgent tasks',
      build: () => taskCubit,
      act: (cubit) => cubit.deleteAll(),
      expect: () => [UserProfileClearAll()],
    );

    tearDown(() => taskCubit.close());
  });
}
