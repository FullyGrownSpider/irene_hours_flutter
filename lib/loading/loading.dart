import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:irene_hours/loading/html_export.dart';
import 'package:irene_hours/loading/loading_storage.dart';
import 'package:irene_hours/models/reg_act.dart';

class Loading {
  static const String htmlFileName = 'usedHTML.html';

  Future<void> storeCompany(String companyName) {
    return addCompany(companyName);
  }

  void removeCompanyFromStorgage(String companyName) {
    deleteCompany(companyName);
  }

  Future<List<String>> getAllCompanyNames() async {
    return await getAllCompanies();
  }

  void removeActionFromStorage(String s) {
    deleteAction(s);
  }

  void storeAction(String s) {
    addAction(s);
  }

  Future<List<String>> getAllActions() async {
    return await getAllActionsFromStorage();
  }

  Future<void> storeRegAct(RegAct ra) {
    return addRegAction(ra);
  }

  void removeRegActFromStorage(RegAct ra) {
    deleteRegAction(ra);
  }

  Future<List<RegAct>> getAllRegActions(DateTime dayFrom, DateTime dayTo) {
    return getRegActions(dayFrom, dayTo);
  }

  Future<String> readHTML() async {
    final path = await localPath();

    var file = File('$path$htmlFileName');
    if (!file.existsSync()) {
      return defaultHTML;
    }
    return file.readAsStringSync();
  }

  Future<void> createDefaultHTML() async {
    final path = await localPath();

    var file = File('$path$htmlFileName');
    file.writeAsStringSync(defaultHTML);
  }

  Future<String> getPath() {
    return getStoreLocation();
  }

  Future<void> setPath(String s) {
    return setStoreLocation(s);
  }

  Future<void> createExport(
    DateTime start,
    DateTime end,
    String? companyName,
    Future<void> Function(String s) showMyDialog,
  ) async {
    var fullPath = await getStoreLocation();
    if (fullPath.isEmpty) {
      return exportToHTML('', [], showMyDialog);
    }
    var allActions = await getRegActions(start, end);
    fullPath += '${Platform.pathSeparator}Export';
    if (companyName != null) {
      allActions.removeWhere((e) => e.companyName != companyName);
      fullPath += '-$companyName';
    }
    fullPath += formatDate(start, [yy, '-', mm, '-', dd]);
    if (!RegAct.sameDay(start, end)) {
      fullPath += '_${formatDate(start, [yy, '-', mm, '-', dd])}';
    }
    return exportToHTML(
      '${fullPath.replaceAll(Platform.pathSeparator + Platform.pathSeparator, Platform.pathSeparator)}.html',
      allActions,
      showMyDialog,
    );
  }

  Future<void> exportHTML() async {
    final path = await localPath();

    var file = File('$path$htmlFileName');

    file.writeAsStringSync(defaultHTML);
  }
}
