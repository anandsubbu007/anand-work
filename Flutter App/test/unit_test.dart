import 'package:bloc_test/bloc_test.dart';
import 'package:demoapp/BlocMethod/model/model.dart';
import 'package:demoapp/BlocMethod/dataProvider/model_cubit.dart';
import 'package:demoapp/BlocMethod/dataProvider/model_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const initialItem = UserProfile(
      id: '1',
      imgURL: 'https://avatars.githubusercontent.com/u/1?v=4',
      name: 'mojombo');
  late UserProfileCubit taskCubit;
  setUp(() async {
    taskCubit = UserProfileCubit();
    await taskCubit.init();
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
      act: (cubit) => cubit.deSelectAll(),
      expect: () => [UserProfileClearAll()],
    );

    tearDown(() => taskCubit.close());
  });
}
