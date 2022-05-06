import 'package:demoapp/app.dart';
import 'package:demoapp/Bloc/model_cubit.dart';
import 'package:demoapp/widget/tab1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfileListTab2 extends StatelessWidget {
  const UserProfileListTab2({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();
    return Scaffold(
      body: UserListBuilder(
          scrollController: _scrollController, isSelectedUser: true),
      floatingActionButton: FloatingActionButton.extended(
          key: const Key('FloatingActionButton'),
          onPressed: () async {
            Utils(context).showLoading();
            await context.read<UserDataRepoCubit>().deleteAll();
            Navigator.pop(context);
          },
          label: const Text('Deselect All')),
    );
  }
}
