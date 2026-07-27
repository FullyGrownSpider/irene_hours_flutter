import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:irene_hours/loading/html_export.dart';
import 'package:irene_hours/loading/loading_storage.dart';
import 'package:irene_hours/models/reg_act.dart';
import 'package:irene_hours/translations.dart';

import '../models/company.dart';

class Loading {
  static const String htmlFileName = 'usedHTML.html';

  void storeCompany(Company company) {
    addCompany(company);
  }

  void removeCompanyFromStorgage(String companyName) {
    deleteCompany(companyName);
  }

  Future<List<Company>> getAllCompanies() async {
    return await getAllCompaniesFromStorage();
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

  Future<List<RegAct>> getAllRegActions(DateTime dayFrom, DateTime dayTo, List<Company> companies) {
    return getRegActions(dayFrom, dayTo, companies);
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
    Company? company,
    Future<void> Function(String s) showMyDialog,
  ) async {
    var fullPath = await getPath();
    if (fullPath.isEmpty) {
      exportToHTML('', '', [], showMyDialog);
      return;
    }
    var allActions = await getRegActions(start, end, await getAllCompanies());
    fullPath += '${Platform.pathSeparator}Export';
    if (company != null) {
      allActions.removeWhere((e) => e.companyName != company.companyName);
      fullPath += '-${company.companyName}';
    }
    fullPath += formatDate(start, [yy, '-', mm, '-', dd]);
    var fullText = language[Words.startDate]! + formatDate(start, [': ', yy, '-', mm, '-', dd]);
    if (!RegAct.sameDay(start, end)) {
      fullPath += '_${formatDate(end, [yy, '-', mm, '-', dd])}';
      fullText += ' ${language[Words.endDate]!} ${formatDate(end, [yy, '-', mm, '-', dd])}';
    }
    exportToHTML(fullText, '${fullPath.replaceAll(Platform.pathSeparator + Platform.pathSeparator, Platform.pathSeparator)}.html', allActions, showMyDialog);
  }

  Future<void> exportHTML() async {
    final path = await localPath();

    var file = File('$path$htmlFileName');

    file.writeAsStringSync(defaultHTML);
  }
}