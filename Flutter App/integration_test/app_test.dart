// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// ignore_for_file: prefer_const_constructors, avoid_print, unnecessary_brace_in_string_interps

// import 'package:demoapp/BlocMethod/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:demoapp/main.dart' as app;
// ignore: import_of_legacy_library_into_null_safe
import 'package:integration_test/integration_test.dart';
import 'package:collection/collection.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('User Fetching', () {
    AppTesting apptesting;
    testWidgets('App Intilization', (WidgetTester tester) async {
      app.main();
      apptesting = AppTesting(tester: tester);
      await apptesting.checkForIntalized();
      await apptesting.checkTabVisibility(0);
      await apptesting.isDataLoaded();
      await apptesting.paginationCheck();
      await apptesting.unSelectIfExist();
      final selectedKeys = await apptesting.checkButtonCheck();
      await Future.delayed(Duration(seconds: 2));
      await apptesting.changeTab(1);
      await Future.delayed(Duration(seconds: 2));
      await apptesting.checkKeyStoredLocaly(selectedKeys);
      await Future.delayed(Duration(seconds: 2));
      await apptesting.presCheckBoxToVerify(selectedKeys.first, 2);
      await Future.delayed(Duration(seconds: 2));
      await apptesting.unCheckAll();
      await Future.delayed(Duration(seconds: 2));
      await apptesting.changeTab(0);
      await Future.delayed(Duration(seconds: 5));
    });
  });
}

class AppTesting {
  WidgetTester tester;
  AppTesting({required this.tester});

  Future checkForIntalized() async {
    await tester.pumpAndSettle();
    expect(find.textContaining('Tab').evaluate().length, 2);
    var byType = find.byKey(Key('Inialize'));
    final futWid = tester.widget<FutureBuilder>(byType);
    await futWid.future;
    print('Intalization Completed');
  }

  Future checkTabVisibility(int idx) async {
    final tabKey = find.byKey(Key('TAB'));
    final tabWid = tester.widget<TabBarView>(tabKey);
    expect(tabWid.controller?.index, idx);
  }

  Future isDataLoaded() async {
    await tester.pumpAndSettle();
    final userList = find.byKey(Key('ListViewKey'));
    final wigeg = tester.widget<ListView>(userList);
    expect((wigeg.childrenDelegate.estimatedChildCount ?? 0) > 0, true);
  }

  int getlistOfUser() {
    // return tester.widgetList<UserProfileListTile>(find.byType(UserProfileListTile)).length;
    final userList = find.byKey(Key('ListViewKey'));
    final wigeg = tester.widget<ListView>(userList);
    // Don't Know how to get itemcount in list view
    return int.tryParse(wigeg.restorationId ?? '') ?? 0;
  }

  Future paginationCheck() async {
    final userListView = find.byKey(Key('ListViewKey'));
    int val1 = getlistOfUser();
    expect(val1 > 0, true);
    await tester.fling(userListView, const Offset(0, -1000), 1000);
    await tester.pumpAndSettle();
    int val2 = getlistOfUser();
    expect(val2 > val1, true);
    await tester.fling(userListView, const Offset(0, -1000), 1000);
    await tester.pumpAndSettle();
    int val3 = getlistOfUser();
    expect(val3 > val2, true);
    await tester.fling(userListView, const Offset(0, 5000), 1000);
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 1));
  }

  Future<List<Key>> checkButtonCheck() async {
    final widList = tester.widgetList<Checkbox>(find.byType(Checkbox));
    final visibleKeys = widList.map((e) => e.key!).toList();
    final selectKey = visibleKeys.slice(0, 3);
    await Future.forEach(selectKey, (Key e) async {
      await Future.delayed(Duration(milliseconds: 100), () async {
        print('$e Tapped To Save');
        await tester.tap(find.byKey(e));
        await tester.pumpAndSettle();
      });
    });
    await tester.pumpAndSettle();
    final widList2 = tester.widgetList<Checkbox>(find.byType(Checkbox));
    final selectedKeys =
        widList2.where((e) => e.value == true).map((e) => e.key!).toList();
    expect(selectKey.length, selectedKeys.length);
    // await Future.delayed(Duration(seconds: 1));
    return selectKey;
  }

  Future unSelectIfExist() async {
    final widList = tester.widgetList<Checkbox>(find.byType(Checkbox));
    final preSelectedKeys =
        widList.where((e) => e.value == true).map((e) => e.key!).toList();
    print('preSelectedKeys Found: $preSelectedKeys');
    if (preSelectedKeys.isNotEmpty) {
      await Future.forEach(preSelectedKeys, (Key e) async {
        print('$e Tapped to remove');
        await tester.tap(find.byKey(e));
        await tester.pumpAndSettle();
      });
      await tester.pumpAndSettle();
      final widList2 = tester.widgetList<Checkbox>(find.byType(Checkbox));
      final selectedKeys =
          widList2.where((e) => e.value == true).map((e) => e.key!).toList();
      expect(selectedKeys.length, 0);
      // await Future.delayed(Duration(seconds: 1));
    }
  }

  Future changeTab(int idx) async {
    final tabKey = find.byKey(Key('Tab $idx'));
    await tester.tap(tabKey);
    await tester.pumpAndSettle();
    await checkTabVisibility(idx);
  }

  Future checkKeyStoredLocaly(List<Key> keys) async {
    final widList = tester.widgetList<Checkbox>(find.byType(Checkbox));
    final preSelectedKeys =
        widList.where((e) => e.value == true).map((e) => e.key!).toList();
    expect(preSelectedKeys.length, keys.length,
        reason: 'Checking For Locally Stored User');
    await tester.pumpAndSettle();
  }

  Future presCheckBoxToVerify(Key key, int expectedLen) async {
    await tester.tap(find.byKey(key));
    await tester.pumpAndSettle();
    final widList = tester.widgetList<Checkbox>(find.byType(Checkbox));
    final preSelectedKeys =
        widList.where((e) => e.value == true).map((e) => e.key!).toList();
    expect(preSelectedKeys.length, expectedLen);
    await tester.pumpAndSettle();
  }

  Future unCheckAll() async {
    await checkTabVisibility(1);
    await tester.tap(find.byKey(Key('FloatingActionButton')));
    await tester.pumpAndSettle();
    final widList = tester.widgetList<Checkbox>(find.byType(Checkbox));
    final preSelectedKeys =
        widList.where((e) => e.value == true).map((e) => e.key!).toList();
    expect(preSelectedKeys.length, 0);
  }
}
