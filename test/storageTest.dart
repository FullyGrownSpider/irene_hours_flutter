// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:irene_hours/loading/button_conversion.dart';
import 'package:irene_hours/loading/loading.dart';
import 'package:irene_hours/loading/loading_storage.dart';
import 'package:irene_hours/models/reg_act.dart';

void main() {
  test('regact convert back and forth', _conversionTest);
  test('export Location', _getAndSetExport);
  test('export actions', _storeActions);
  test('export companies', _storeCompanies);
  test('export regAct', _storeRegAct1Day);
  test('export regAct', _storeRegAct2Day);
}

void _clear() {
  var directory = Directory(
    defaultDirectory + Platform.pathSeparator + defaultFolder,
  );
  if (directory.existsSync()) {
    directory.deleteSync(recursive: true);
  }
}

Future<void> _storeActions() async {
  isTest = true;
  _clear();
  var loading = Loading();
  loading.removeActionFromStorage('s');
  var data = await loading.getAllCompanyNames();
  expect([], data);

  var list = _randomStrings();
  for (var e in list) {
    loading.storeAction(e);
  }
  data = await loading.getAllActions();
  loading.removeActionFromStorage('s');
  expect(list, data);
}

Future<void> _storeCompanies() async {
  isTest = true;
  _clear();
  var loading = Loading();
  var data = await loading.getAllCompanyNames();
  expect([], data);
  loading.removeCompanyFromStorgage('s');

  var list = _randomStrings();
  for (var e in list) {
    loading.storeCompany(e);
  }
  data = await loading.getAllCompanyNames();
  loading.removeCompanyFromStorgage('s');
  expect(list, data);
}

Future<void> _storeRegAct1Day() async {
  isTest = true;
  _clear();
  var loading = Loading();
  var data = await loading.getAllRegActions(DateTime.now(), DateTime.now());
  expect([], data);
  loading.removeRegActFromStorage(_uniqueRegAct());

  var list = _conversionList();
  for (var e in list) {
    loading.storeRegAct(e);
  }
  data = await loading.getAllRegActions(DateTime.now(), DateTime.now());
  loading.removeRegActFromStorage(_uniqueRegAct());
  expect(list, data);
}

Future<void> _storeRegAct2Day() async {
  isTest = true;
  _clear();
  var loading = Loading();

  var list = _conversionList();
  var newDay = DateTime.now().add(Duration(days: -1));
  for (var e in list) {
    loading.storeRegAct(
      RegAct(e.startTime, e.companyName, e.actionName, e.endTime, newDay),
    );
    loading.storeRegAct(e);
  }
  var data = await loading.getAllRegActions(
    DateTime.now().add(Duration(days: -1)),
    DateTime.now(),
  );
  loading.removeRegActFromStorage(_uniqueRegAct());
  expect(data.length, list.length * 2);
}

Future<void> _getAndSetExport() async {
  isTest = true;
  _clear();
  var loading = Loading();
  expect('', await loading.getPath());
  _clear();

  loading.setPath('');
  expect('', await loading.getPath());

  final path =
      '$defaultDirectory${Platform.pathSeparator}$defaultFolder${Platform.pathSeparator}';
  loading.setPath(path); //testing on different pc? edit this location
  expect(path, await loading.getPath());
}

void _conversionTest() {
  var list = _conversionList();
  var oldList = list.map((e) => actionExportGenerator(e)).toList();
  var newList = oldList.map((e) => actionImportGenerator(e, DateTime.now()));
  for (var e in newList) {
    expect(true, list.contains(e));
  }
}

List<RegAct> _conversionList() {
  return List<RegAct>.generate(
    10,
    (int index) => RegAct(
      DateTime.now().add(Duration(minutes: -20 + -60 * index)),
      'companyName:$index',
      ' actionName',
      DateTime.now().add(Duration(minutes: -10 + -60 * index)),
      DateTime.now(),
    ),
    growable: true,
  );
}

RegAct _uniqueRegAct() => RegAct(
  DateTime.now().add(Duration(minutes: (-20))),
  'companyName:-1',
  ' actionName',
  DateTime.now().add(Duration(minutes: -10)),
  DateTime.now(),
);

List<String> _randomStrings() {
  return List<String>.generate(
    10,
    (int index) => 'wow random nr:$index',
    growable: true,
  );
}
