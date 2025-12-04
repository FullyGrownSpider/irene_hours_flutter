import '../models/reg_act.dart';

/// class used to turn the values used by buttons into string and back
final String storageSep = "◘";
final String storageIdentifier = "○";
final String storageListSep = "•";

Map<String, String> lineConversion(String line) {
  var map = <String, String>{};
  line
      .split(storageSep)
      .where((e) => e.length > 2 && e.contains(storageIdentifier))
      .forEach((o) {
    var value = o.split(storageIdentifier);
    map[value[0]] = value[1];
  });
  return map;
}

RegAct actionImportGenerator(String line, DateTime date) {
  var list = lineConversion(line);
  return RegAct(
    dataImportGenerator<DateTime>(
      list[_basicValuesToString(_BasicValues.v1)],
    ),
    dataImportGenerator<String>(list[_basicValuesToString(_BasicValues.v2)]),
    dataImportGenerator<String>(list[_basicValuesToString(_BasicValues.v3)]),
    dataImportGenerator<DateTime>(
      list[_basicValuesToString(_BasicValues.v4)],
    ),
    date,
  );
}

String actionExportGenerator(RegAct action) {
  return dataExportGenerator(
    action.startTime,
    _basicValuesToString(_BasicValues.v1),
  ) +
      dataExportGenerator(
        action.actionName,
        _basicValuesToString(_BasicValues.v3),
      ) +
      dataExportGenerator(
        action.companyName,
        _basicValuesToString(_BasicValues.v2),
      ) +
      dataExportGenerator(
        action.endTime,
        _basicValuesToString(_BasicValues.v4),
      ) +
      storageSep;
}

String idOnlyImportGenerator(String line) {
  var list = lineConversion(line);
  return dataImportGenerator<String>(
    list[_basicValuesToString(_BasicValues.id)],
  );
}

String idOnlyExportGenerator(String action) {
  return dataExportGenerator(action, _basicValuesToString(_BasicValues.id));
}

String _basicValuesToString(_BasicValues val) {
  var data = val.toString().split('.');
  return data[data.length - 1];
}

String uniquePartAction(RegAct line) {
  return actionExportGenerator(line);
}

dynamic dataImportGenerator<T>(String? sx) {
  String s = sx ?? '';
  if (T == String) {
    return s;
  } else if (T == int) {
    if (s.isEmpty) return 0;
    return int.parse(s);
  } else if (T == bool) {
    return 't' == s;
  } else if (T == DateTime) {
    if (s.isEmpty) {
      return DateTime.now();
    } else {
      List x = s.split(storageListSep);
        return DateTime(
        DateTime
            .now()
            .year,
        1,
        1,
        dataImportGenerator<int>(x[x.length -2]),
        dataImportGenerator<int>(x[x.length -1]),
      );
    }
  }
  return "";
}

String dataExportGenerator(Object? value, String valueName) {
  if (value == null) return "";
  StringBuffer buf = StringBuffer(storageSep + valueName + storageIdentifier);
  if (value is DateTime) {
    DateTime temp = value;
    buf.write(temp.hour);
    buf.write(storageListSep);
    buf.write(temp.minute);
  } else if (value is bool) {
    bool temp = value;
    buf.write((temp) ? "t" : "");
  } else {
    buf.write(value);
  }
  return buf.toString();
}

enum _BasicValues { v1, v2, v3, v4, id }
