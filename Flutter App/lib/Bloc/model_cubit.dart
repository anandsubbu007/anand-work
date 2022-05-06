// ignore_for_file: avoid_print
import 'package:demoapp/data/dataProvider/local_data.dart';
import 'package:demoapp/data/model/model.dart';
import 'package:demoapp/Bloc/model_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserDataRepoCubit extends Cubit<UserProfileState> {
  final LocalDataSource localDataSource;

  Future<List<UserProfile>> get selectedUsers async {
    final output = await localDataSource.getLocalData();
    final data = output.fold<Output<List<UserProfile>>>(
      (e) => Output(isSuccess: false, report: '${e.props}', value: []),
      (e) => Output(isSuccess: true, report: 'Gotcha', value: e),
    );
    return data.value;
  }

  UserDataRepoCubit({required this.localDataSource})
      : super(UserProfileLoadInitial()) {
    localDataSource.getLocalData();
  }
  Future<bool> isSelecUsersId(String id) async =>
      (await selectedUsers).map((e) => e.id).contains(id);

  Future<Output<List<UserProfile>>> onTap(UserProfile user) async {
    final output = await localDataSource.onUserTap(user);
    final data = output.fold<Output<List<UserProfile>>>(
      (e) => Output(isSuccess: false, report: '${e.props}', value: []),
      (e) => Output(isSuccess: true, report: 'Gotcha', value: e),
    );
    emit(UserProfileOnSelectionChange(data.value));
    return data;
  }

  Future<bool> deleteAll() async {
    final output = await localDataSource.deleteAll();
    final res = output.fold<bool>((e) => false, (e) => e);
    emit(UserProfileClearAll());
    return res;
  }

}
