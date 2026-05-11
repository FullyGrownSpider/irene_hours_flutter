import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:irene_hours/loading/html_export.dart';
import 'package:irene_hours/loading/loading_storage.dart';
import 'package:irene_hours/models/reg_act.dart';

class Loading {
  static const String htmlFileName = 'usedHTML.html';

  void storeCompany(String companyName) {
    addCompany(companyName);
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

  void setPath(String s) {
    setStoreLocation(s);
  }

  Future<String> getLang() {
    return getPrefLang();
  }

  String getLangSync() {
    return getPrefLangSync();
  }

  void setLang(String s) {
    setPrefLang(s);
  }


  void createExport(
    DateTime start,
    DateTime end,
    String? companyName,
    Future<void> Function(String s) showMyDialog,
  ) async {
    var fullPath = await getPath();
    if (fullPath.isEmpty) {
      exportToHTML('', [], showMyDialog);
      return;
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
    exportToHTML('${fullPath.replaceAll(Platform.pathSeparator + Platform.pathSeparator, Platform.pathSeparator)}.html', allActions, showMyDialog);
  }

  Future<void> exportHTML() async {
    final path = await localPath();

    var file = File('$path$htmlFileName');

    file.writeAsStringSync(defaultHTML);
  }
}