import 'package:bloc_test/bloc_test.dart';
import 'package:demoapp/data/dataProvider/local_data.dart';
// import 'package:demoapp/data/model/dataProvider/local_data.dart';
import 'package:demoapp/data/model/model.dart';
import 'package:demoapp/Bloc/model_cubit.dart';
import 'package:demoapp/Bloc/model_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const initialItem = UserProfile(
      id: '1',
      imgURL: 'https://avatars.githubusercontent.com/u/1?v=4',
      name: 'mojombo');
  late UserProfileCubit taskCubit;
  setUp(() async {
    taskCubit = UserProfileCubit();
    await LocalDatabase().init();
    // await taskCubit.init();
  });
  group('UserProfileCubit test', () {
    // blocTest<UserProfileCubit, UserProfileState>(
    //   'emits [fetchUsers, UserProfilenewData] states for'
    //   'successful task loads',
    //   build: () => taskCubit,
    //   act: (cubit) => cubit.fetchUser(1),
    //   expect: () => [
    //     // ({login: mojombo, id: 1, avatar_url: https://avatars.githubusercontent.com/u/1?v=4})
    //     // UserProfilenewData(const [initialItem])
    //   ],
    // );
    blocTest<UserProfileCubit, UserProfileState>(
      'emits [UserProfile On Tap: SelectionChange] with correct urgent tasks',
      build: () => taskCubit,
      act: (cubit) => cubit.onTap(initialItem),
      expect: () => [
        UserProfileOnSelectionChange(const [initialItem])
      ],
    );
    blocTest<UserProfileCubit, UserProfileState>(
      'emits [UserProfile on Tap Selected Profile to Deselect] with correct urgent tasks',
      build: () => taskCubit,
      act: (cubit) => cubit.onTap(initialItem),
      expect: () => [UserProfileOnSelectionChange(const [])],
    );
    blocTest<UserProfileCubit, UserProfileState>(
      'emits [Deselect All Selected Profile] with correct urgent tasks',
      build: () => taskCubit,
      act: (cubit) => cubit.deleteAll(),
      expect: () => [UserProfileClearAll()],
    );

    tearDown(() => taskCubit.close());
  });
}
