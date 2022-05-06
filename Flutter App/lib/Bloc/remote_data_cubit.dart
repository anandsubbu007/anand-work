// ignore_for_file: avoid_print
import 'package:demoapp/data/model/model.dart';
import 'package:demoapp/Bloc/model_state.dart';
import 'package:demoapp/data/dataProvider/remote_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RemoteUserDataRepoCubit extends Cubit<UserProfileState> {
  final RemoteDataSource remoteDataSource;

  List<UserProfile> fetchedUsers = [];

  RemoteUserDataRepoCubit({required this.remoteDataSource})
      : super(UserProfileLoadInitial());

  Future<Output<List<UserProfile>>> fetchUser(int count,
      [bool? intalized]) async {
    if (!(intalized ?? true)) {
      if (fetchedUsers.isEmpty) {
        var output = await fetchUserData(count);
        return output;
      } else {
        return Output(
            report: 'Data Load Not Required', isSuccess: true, value: []);
      }
    } else {
      var output = await fetchUserData(count);
      return output;
    }
  }

  Future<Output<List<UserProfile>>> fetchUserData(int count) async {
    var output = await remoteDataSource.fetchUser(fetchedUsers.length, count);
    final data = output.fold<Output<List<UserProfile>>>(
      (e) => Output(isSuccess: false, report: '${e.props}', value: []),
      (e) => Output(isSuccess: true, report: 'Gotcha', value: e),
    );
    fetchedUsers = data.value;
    emit(UserProfileOnSelectionChange(fetchedUsers));
    return data;
  }
}
