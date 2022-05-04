import 'package:bloc_test/bloc_test.dart';
import 'package:demoapp/BlocMethod/model.dart';
import 'package:demoapp/BlocMethod/model_cubit.dart';
import 'package:demoapp/BlocMethod/model_state.dart';
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
    blocTest<UserProfileCubit, UserProfileState>(
      'emits [fetchUsers, UserProfilenewData] states for'
      'successful task loads',
      build: () => taskCubit,
      act: (cubit) => cubit.fetchUsers(1),
      expect: () => [
        // ({login: mojombo, id: 1, avatar_url: https://avatars.githubusercontent.com/u/1?v=4})
        UserProfilenewData(const [initialItem])
      ],
    );
    blocTest<UserProfileCubit, UserProfileState>(
      'emits [TaskLoadInProgress, TaskLoadSuccess] with correct urgent tasks',
      build: () => taskCubit,
      act: (cubit) => cubit.onTap(initialItem),
      expect: () => [
        UserProfileOnSelectionChange(const [initialItem])
      ],
    );
    blocTest<UserProfileCubit, UserProfileState>(
      'emits [TaskLoadInProgress, TaskLoadSuccess] with correct urgent tasks',
      build: () => taskCubit,
      act: (cubit) => cubit.onTap(initialItem),
      expect: () => [UserProfileOnSelectionChange(const [])],
    );
    blocTest<UserProfileCubit, UserProfileState>(
      'emits [TaskLoadInProgress, TaskLoadSuccess] with correct urgent tasks',
      build: () => taskCubit,
      act: (cubit) => cubit.getLocalData(),
      expect: () => [],
    );

    tearDown(() {
      taskCubit.close();
    });
  });
}
