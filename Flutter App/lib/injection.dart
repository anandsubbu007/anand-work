import 'package:demoapp/Bloc/model_cubit.dart';
import 'package:demoapp/Bloc/remote_data_cubit.dart';
import 'package:demoapp/data/dataProvider/local_data.dart';
import 'package:demoapp/data/dataProvider/remote_data.dart';
import 'package:demoapp/data/repo/repo.dart';
import 'package:demoapp/widget/usecase/get_user_data.dart';
import 'package:demoapp/widget/usecase/on_tap_user.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - User Data Fetch
  // Bloc
  sl.registerFactory(() => UserDataRepoCubit(localDataSource: sl()));
  sl.registerFactory(() => RemoteUserDataRepoCubit(remoteDataSource: sl()));
//
  // Use cases
  sl.registerLazySingleton(() => GetSelectedUserData(sl()));
  sl.registerLazySingleton(() => GetAvailableUserData(sl()));
  sl.registerLazySingleton(() => OnTapUserProfile(sl()));

  // Repository
  sl.registerLazySingleton<UserDataRepo>(
    () => UserDataRepoImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());

  // Data sources
  sl.registerLazySingleton<LocalDataSource>(
      () => LocalDataSourceImp(pref: sl()));

  sl.registerLazySingleton<RemoteDataSource>(
    () => RemoteDataSourceImp(client: sl()),
  );
}
