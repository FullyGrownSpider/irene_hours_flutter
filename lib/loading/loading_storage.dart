import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:irene_hours/loading/button_conversion.dart';
import 'package:path_provider/path_provider.dart';

import '../models/reg_act.dart';

final _SuperStorage _companyStorage = _SuperStorage("Companies");
final _SuperStorage _actionsStorage = _SuperStorage("Actions");
final _SuperStorage _optionStorage = _SuperStorage("Options");
const String store = 'Store○';

const defaultFolder = "Irene-Uren";
const String defaultDirectory = '/home/a804/Documents'; //for testing
//never gets emptied, except on restart
Map<String, _SuperStorage> _filesInMemory = {};

void setStoreLocation(String s) {
  _optionStorage.update('$store$s', store);
}

Future<String> getStoreLocation() async {
  var data = (await _optionStorage.readAllData());
  if (data.isEmpty) return '';
  return data
      .firstWhere((e) => e.startsWith(store), orElse: () => '')
      .replaceFirst(store, '');
}

void deleteRegAction(RegAct cus) {
  _getFileForRegActions(cus.day).delete(uniquePartAction(cus));
}

Future<void> addRegAction(RegAct cus) {
  return _getFileForRegActions(cus.day).addItem(actionExportGenerator(cus));
}

Future<List<RegAct>> getRegActions(DateTime start, DateTime end) async {
  var days = end.difference(start).inDays;
  List<RegAct> list = [];
  List<Future> todos = [];
  for (int i = 0; i <= days; i++) {
    var date = start.add(Duration(days: i));
    todos.add(
      _getFileForRegActions(date).readAllData().then(
        (itemList) => list.addAll(
          itemList.map((item) => actionImportGenerator(item, date)),
        ),
      ),
    );
  }
  //make sure all futures are completed
  for (var todo in todos) {
    await todo;
  }
  return list;
}

_SuperStorage _getFileForRegActions(DateTime day) {
  String s = "Act${dateToString(day)}";
  if (!_filesInMemory.containsKey(s)) {
    _filesInMemory[s] = _SuperStorage(s);
  }
  return _filesInMemory[s]!;
}

String dateToString(DateTime day) {
  return formatDate(day, [yy, '-', mm, '-', dd]);
}

void deleteAction(String cus) {
  _actionsStorage.delete(cus);
}

void addAction(String cus) {
  _actionsStorage.addItem(cus);
}

Future<List<String>> getAllActionsFromStorage() async {
  return (await _actionsStorage.readAllData()).toList();
}

void deleteCompany(String cus) {
  _companyStorage.delete(idOnlyExportGenerator(cus));
}

void addCompany(String cus) {
  _companyStorage.addItem(idOnlyExportGenerator(cus));
}

Future<List<String>> getAllCompanies() async {
  var list = (await _companyStorage.readAllData());
  if (list.isEmpty) return [];
  return list.map((e) => idOnlyImportGenerator(e)).toList();
}

Future<String> localPath() async {
  Directory directory;
  try {
    directory = await getApplicationDocumentsDirectory();
  } catch (_) {
    directory = Directory(defaultDirectory);
  }
  //should only be null if error
  String myFolder =
      '${directory.path}${Platform.pathSeparator}$defaultFolder${Platform.pathSeparator}';
  if (!Directory(myFolder).existsSync()) {
    Directory(myFolder).createSync();
  }
  return myFolder;
}

class _SuperStorage {
  File? _file;
  String _startLine = 'Byrd';
  List<Future<dynamic> Function()> todo = [];

  _SuperStorage(String fileName) {
    _doAction(() => localPath().then((path) => _file = File('$path$fileName.byd')));
  }

  Future<File?> get _localFile async {
    if (_file == null) return null;
    if (_file!.existsSync()) {
      return _file;
    }
    //create the directory
    _file!.createSync(recursive: true);
    return null;
  }

  Future<DateTime> _lastUpdate() async {
    try {
      final file = await _localFile;
      if (file == null) {
        return DateTime.now().subtract(const Duration(days: 300));
      }
      // Read the date
      var dateText = (await file.readAsLines()).first;
      return DateTime.parse(dateText.replaceFirst('Byrd', ''));
    } catch (e) {
      return DateTime.now().subtract(const Duration(days: 300));
    }
  }

  Future<DateTime> lastUpdate() async {
    return await _doAction(() => _lastUpdate());
  }

  Future<List<String>> readAllData() async {
    return await _doAction(() => _readAllData());
  }

  Future<List<String>> _readAllData() async {
    try {
      final file = await _localFile;
      if (file == null) return [];
      // Read the file
      return (await file.readAsLines()).sublist(1);
    } catch (e) {
      // If we encounter an error, return 0
      return [];
    }
  }

  Future<void> _writeStrings(List<String> items) async {
    _startLine =
        'Byrd${formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss])}';
    var file = await _localFile;
    if (file == null) {
      file = await _localFile;
      //if null we cant create it for some reason
      if (file == null) return;
    }
    items.insert(0, _startLine);
    await file.writeAsString(items.join('\n'));
  }

  Future<void> addItem(String string) async {
    if (newLineCheck(string)) throw Exception('illegal character');
    await _doAction(() => _addItem(string));
  }

  Future<void> _addItem(String string) async {
    var values = await _readAllData();
    values.add(string);
    await _writeStrings(values);
  }

  Future<void> addItems(List<String> string) async {
    if (string.any(newLineCheck)) throw Exception('illegal character');
    await _doAction(() => _addItems(string));
  }

  Future<void> _addItems(List<String> string) async {
    var values = await _readAllData();
    values.addAll(string);
    await _writeStrings(values);
  }

  Future<void> update(String newItem, String uniquePart) async {
    if (newLineCheck(uniquePart) || newLineCheck(newItem)) {
      throw Exception('illegal character');
    }
    await _doAction(() => _update(newItem, uniquePart));
  }

  Future _doAction(Future Function() method) async {
    todo.add(method);
    while (todo.first != method) {
      await waitTurn();
    }
    var result = await method();
    todo.remove(method);

    return result;
  }

  Future<void> _update(String newItem, String uniquePart) async {
    var values = await _readAllData();
    var index = values.indexWhere((e) => e.contains(uniquePart));
    if (index != -1) {
      values[index] = newItem;
      await _writeStrings(values);
    } else {
      _addItem(newItem);
    }
  }

  Future<void> updateAll(List<String> newItem, List<String> uniquePart) async {
    if (uniquePart.any(newLineCheck) || newItem.any(newLineCheck)) {
      throw Exception('illegal character');
    }
    await _doAction(() => _updateAll(newItem, uniquePart));
  }

  Future<void> _updateAll(List<String> newItem, List<String> uniquePart) async {
    var values = await _readAllData();
    for (int i = 0; i < newItem.length; i++) {
      var index = values.indexWhere((e) => e.contains(uniquePart[i]));
      values[index] = newItem[i];
    }
    await _writeStrings(values);
  }

  Future<void> delete(String uniquePart) async {
    if (newLineCheck(uniquePart)) {
      throw Exception('illegal character');
    }
    await _doAction(() => _delete(uniquePart));
  }

  Future<void> deleteAll(List<String> uniquePart) async {
    if (uniquePart.any((s) => newLineCheck(s))) {
      throw Exception('illegal character');
    }
    await _doAction(() => _deleteAll(uniquePart));
  }

  Future<void> _deleteAll(List<String> uniqueParts) async {
    var values = await _readAllData();
    for (var uniquePart in uniqueParts) {
      var index = values.indexWhere((e) => e.contains(uniquePart));
      if (index >= 0) {
        values.removeAt(index);
      }
    }
    await _writeStrings(values);
  }

  Future<void> _delete(String uniquePart) async {
    var values = await _readAllData();
    if (values.isEmpty) return;
    values.removeWhere((e) => e.contains(uniquePart));
    await _writeStrings(values);
  }

  Future<void> waitTurn() async {
    await Future.delayed(const Duration(milliseconds: 213));
  }

  static final RegExp lineEnd = RegExp(r'[\r\n\f]');

  static bool newLineCheck(String s) => (s.contains(lineEnd));
}
