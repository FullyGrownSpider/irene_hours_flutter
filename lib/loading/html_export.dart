import 'dart:io';
import 'package:date_format/date_format.dart';
import 'package:irene_hours/translations.dart';

import '../models/reg_act.dart';
import 'loading.dart';

//TODO other lang
final String _workTimeReplace = "WERKTIJD";
final String _tableReplaceReplace = "TABLEDATA";

Future<void> exportToHTML(
  String fullPath,
  List<RegAct> actionsList,
  void Function(String) showDialoge,
) async {
  if (fullPath.isEmpty ||
      !Directory(
        fullPath.substring(0, fullPath.lastIndexOf(Platform.pathSeparator)),
      ).existsSync()) {
    showDialoge(language[Words.noPath]!);
    return;
  }
  List<RegAct> actions = [];
  actions.addAll(actionsList);
  if (actions.isEmpty) {
    showDialoge(language[Words.noData]!);
    return;
  }

  actions.sort((a, b) => a.compareTo(b));
  var data = await createFile(actions);

  // Save the document...
  File(fullPath).writeAsString(data);
}

//actions cant have 0 items or there will be an error
Future<String> createFile(List<RegAct> actions) async {
  String newFile = await Loading().readHTML();

  StringBuffer tableBuf = StringBuffer();
  List<String> currentRow = [];
  List<String> rowsNoDate = [];
  String prevCompany = actions.first.companyName;
  bool single = !actions.any((x) => x.companyName != prevCompany);
  int sameCompany = 0;
  var companyTime = <String,int>{};
  var companyTimeFull = <String,int>{};
  int totalForThisDay = 0;
  DateTime prevDay = actions.first.day;
  for (var action in actions) {
    if (action.day.difference(prevDay).inDays >= 1) {
      int index = rowsNoDate.length-sameCompany;
      rowsNoDate[index] = createLayerdItem(prevCompany, sameCompany) + rowsNoDate[index];
      sameCompany = 0;

      var timePrint = totalForThisDay;
      currentRow.add(createRowsWithSingleDate(prevDay, rowsNoDate, timePrint, companyTime, single));
      prevDay = action.day;
      prevCompany = action.companyName;
      totalForThisDay = 0;
      rowsNoDate.clear();
      mapCopy(companyTime, companyTimeFull);
      companyTime.clear();
    }
    totalForThisDay += action.getTime();
    String exportValue = createRowData(action);
    rowsNoDate.add(exportValue);

    if (prevCompany == action.companyName){
      sameCompany++;
      if (companyTime[action.companyName] == null) {
        companyTime[action.companyName] = action.getTime();
      } else {
        companyTime[action.companyName] = companyTime[action.companyName]! + action.getTime();
      }
      //Store the action
    } else {
      companyTime[action.companyName] = action.getTime();
      int index = rowsNoDate.length-sameCompany - 1;
      rowsNoDate[index] = createLayerdItem(prevCompany, sameCompany) + rowsNoDate[index];
      prevCompany = action.companyName;
      sameCompany = 1;
    }

  }
  //add the final company
  int index = rowsNoDate.length-sameCompany;
  rowsNoDate[index] = createLayerdItem(prevCompany, sameCompany) + rowsNoDate[index];
  //add final day
  currentRow.add(createRowsWithSingleDate(prevDay, rowsNoDate, totalForThisDay, companyTime, single));
  for (var row in currentRow) {
    tableBuf.write(row);
  }
  mapCopy(companyTime, companyTimeFull);

  StringBuffer minutesStringTot = StringBuffer('<tr>Werktijd totaal: ${createTimeText(companyTimeFull.values.fold(0, (a, b) => a+b))}</tr>');
  if (!single) {
    for (var time in companyTimeFull.entries) {
      minutesStringTot.write(
          '<tr>\nVoor ${time.key} : ${createTimeText(time.value)}</tr>');
    }
    newFile = newFile.replaceAll(_workTimeReplace, minutesStringTot.toString());
  } else {
    newFile = newFile.replaceAll(_workTimeReplace, 'Voor $prevCompany $minutesStringTot');
  }
  newFile = newFile.replaceFirst(_tableReplaceReplace, tableBuf.toString());
  return newFile;
}

void mapCopy(Map<String, int> companyTime, Map<String, int> companyTimeFull) {
  for (var time in companyTime.entries){
    if (!companyTimeFull.containsKey(time.key)) {
      companyTimeFull[time.key] = time.value;
    } else {
      companyTimeFull[time.key] = companyTimeFull[time.key]! + time.value;
    }
  }
}

String biggerColumn(String data, int columns, String align) {
  return '<td style="padding: 0.2rem; font-weight: bold; text-align:$align" colspan="$columns">$data</td>\n';
}

String createDateTop(String date, String time){
  return rowStart() + biggerColumn("Dag: $date",3,"center")+biggerColumn("Totaal: $time",2,"right")+ rowEnd();
}

String createLayerdItem(String data, int amount) {
  return '<td rowspan="$amount">$data</td>\n';
}

String createDateBottom(Map<String, int> compTime){
  var buf = StringBuffer();

  var sortedByKeyMap = Map.fromEntries(
      compTime.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key))).entries;
  for (var cT in sortedByKeyMap){
  buf.write(rowStart());
  buf.write(biggerColumn("Voor ${cT.key}", 3, "center"));
  buf.write(biggerColumn("${createTimeText(cT.value)} uur", 2, "right"));
  buf.write(rowEnd());
  }
  return buf.toString();
}

String createTimeText(int minsTot) {
  return '${(minsTot / 60).toInt().toString().padLeft(2, '0')}:${(minsTot % 60).toString().padLeft(2, '0')}';
}

String createDateTimeTimeText(DateTime time) {
  return formatDate(time, [HH, ':', nn]);
}
String createDateText(DateTime time) {
  return formatDate(time, [d, '-', M, '-', yyyy]);
}

String createRowsWithSingleDate(DateTime day, List<String> otherData, int time, Map<String, int> companyTime, bool single) {
  StringBuffer buf = StringBuffer();
  buf.write(rowStart());
  buf.write(biggerColumnNoLines(".",5,"right"));
  buf.write(rowEnd());
  buf.write(createDateTop(createDateText(day),createTimeText(time)));
  if (!single) {
    buf.write(createDateBottom(companyTime));
  }
  buf.write(language[Words.tableTop]!);
  for (var item in otherData){
    buf.write(item);
    buf.write(rowEnd());
  }
  return buf.toString();
}

String createRowData(RegAct action) {
  int mins = action.getTime();
  var minsTot = createTimeText(mins);
  return (createRowItem(action.actionName) +
      createRowItemForTime(createDateTimeTimeText(action.startTime)) +
      createRowItemForTime(createDateTimeTimeText(action.endTime)) +
      createRowItemForTime(minsTot));
}

String createRowItem(String data) {
  return '<td>$data</td>\n';
}

String createRowItemForTime(String data) {
  return '<td style="text-align:right;">$data</td>\n';
}

String biggerColumnNoLines(String data, int columns, String align) {
  return '<td style="border: 0px solid black; padding: 0.2rem; font-weight: bold; font-size:larger; text-align:$align" colspan="$columns">$data</td>\n';
}
String rowEnd() {
  return "</tr>\n";
}

String rowStart() {
  return "<tr>\n";
}


String defaultHTML = '''
<!DOCTYPE html>
<html>
<head>
<style>

div {
width: 100%;
display: flex;
align-items: center;
}

table {
border-spacing: 0;
}

.tableData td {
border-style: solid;
border-width: 1px;
margin: 0;
}

th {
font-size: larger
}

</style>
</head>
<body>
<img align="right" src="data:image/png;base64,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" />
<table>
WERKTIJD
</table>
<table class="tableData" style="width: 100%">
<colgroup>
<col span="1" style="width:20%;">
<col span="1"">
<col span="1" style="width:10%;">
<col span="1" style="width:10%;">
<col span="1" style="width:10%;">
</colgroup>
TABLEDATA
</table>
</body>
</html>''';
