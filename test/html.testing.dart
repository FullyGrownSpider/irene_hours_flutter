import 'dart:io';
import 'dart:math';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:irene_hours/loading/html_export.dart';
import 'package:irene_hours/loading/loading.dart';
import 'package:irene_hours/loading/loading_storage.dart';
import 'package:irene_hours/models/company.dart';
import 'package:irene_hours/models/reg_act.dart';
import 'package:irene_hours/translations.dart';

void main() {
  dutch();

  clear();
  test('export html', _exportHtmlTest);

  WidgetsFlutterBinding.ensureInitialized();
  clear();
  test('create html', _createEmptyHtml);

  //vibes based test
  myTest();
  // test('export actions', _storeActions);
  // test('export companies', _storeCompanies);
  // test('export regAct', _storeRegAct1Day);
  // test('export regAct', _storeRegAct2Day);
}

Future<void> myTest() async {
  // var t= await createFile(createList(3));
  //
  // var tx= await createFile(createList(1));
  //
  // var ty =await createFile(createList2());
  var x = 1;

}
List<RegAct> createList(int comp){
  List<RegAct> list = [];
  var r = Random(7);
  for (int i = 0; i < 30; i++) {
    var time = DateTime.now();
    time = time.add(Duration(hours: i));
    list.add(RegAct(time, Company("${language[Words.companies]}${r.nextInt(comp)}"), "${language[Words.theAction]}${(i/2).toInt()}", time.add(Duration(minutes: 10)),time.add(Duration(days: (i/3).toInt()))));
  }
  return list;
}


List<RegAct> createList2(){
  List<RegAct> list = [];
  var timeBase = DateTime.now();
  var time = timeBase.add(Duration(hours: 1));
  list.add(RegAct(time, Company("BedrijfX"), "actieX", time.add(Duration(minutes: 10)),timeBase));
  time = time.add(Duration(hours: 1));
  list.add(RegAct(time, Company("BedrijfX"), "actieX", time.add(Duration(minutes: 30)),timeBase));

  return list;
}


void clear() {
  var directory = Directory(
    defaultDirectory + Platform.pathSeparator + defaultFolder,
  );
  if (directory.existsSync()) {
    directory.deleteSync(recursive: true);
  }
}

Future<void> _exportHtmlTest() async {
  Loading loading = Loading();

  expect(defaultHTML, await loading.readHTML());
  loading.exportHTML();

  expect(defaultHTML, await loading.readHTML());
}

Future<void> _createEmptyHtml() async {
  //Somehow can't test this?????????
  // Loading loading = Loading();
  //
  // _setExport();
  // //first create empty html with default (need return empty)
  // loading.createExport(DateTime.now(), DateTime.now(), '', (s) async {});
  // _fileIsOk('', null, DateTime.now(), DateTime.now());
  // //add one thing
  // await loading.storeRegAct(_uniqueRegAct());
  // //export with one thing
  // loading.createExport(DateTime.now(), DateTime.now(), '', (s) async {});
  // //test
  //
  // _fileIsOk('arst', null, DateTime.now(), DateTime.now());
  // //make an empty html
  // //test its empty
}

Future<void> _fileIsOk(
  String org,
  String? companyName,
  DateTime start,
  DateTime end,
) async {
  var path = 'Export';
  if (companyName != null) {
    path += '-$companyName';
  }
  path += formatDate(start, [yy, '-', mm, '-', dd]);
  if (!RegAct.sameDay(start, end)) {
    path += '_${formatDate(start, [yy, '-', mm, '-', dd])}';
  }
  var file = File(
    '$defaultDirectory${Platform.pathSeparator}$defaultFolder${Platform.pathSeparator}$path',
  );
  if (file.existsSync()) {
    expect(org, file.readAsStringSync());
  } else {
    expect(org, '');
  }
}

Future<void> _setExport() async {
  Loading loading = Loading();
  final path =
      '$defaultDirectory${Platform.pathSeparator}$defaultFolder${Platform.pathSeparator}';
  loading.setPath(path); //testing on different pc? edit this location
  expect(await loading.getPath(), path);
}

List<RegAct> _conversionList() {
  return List<RegAct>.generate(
    10,
    (int index) => RegAct(
      DateTime.now().add(Duration(minutes: -20 + -60 * index)),
      Company('companyName:$index'),
      ' actionName',
      DateTime.now().add(Duration(minutes: -10 + -60 * index)),
      DateTime.now(),
    ),
    growable: true,
  );
}

RegAct _uniqueRegAct() => RegAct(
  DateTime.now().add(Duration(minutes: (-20))),
    Company('companyName:-1'),
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
