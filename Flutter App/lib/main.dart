// ignore_for_file: avoid_print

import 'package:demoapp/app.dart';
import 'package:demoapp/Bloc/model_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  // runApp(const MyApp());
  BlocOverrides.runZoned(
    () => runApp(const MyApp()),
    blocObserver: AppBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserProfileCubit(),
      child: MaterialApp(
          title: 'Flutter Test',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: const MyHomePage(title: 'Title')),
    );
  }
}

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (bloc is Cubit) print(change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}
