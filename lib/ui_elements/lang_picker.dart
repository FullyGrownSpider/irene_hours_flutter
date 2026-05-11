import 'package:flutter/material.dart';
import 'package:irene_hours/loading/loading.dart';

import '../translations.dart';

class LangPicker {
  late final DropdownButton<String> languages;
  void Function(String) resetUI;
  ValueNotifier<bool> change = ValueNotifier<bool>(false);

  LangPicker(this.resetUI,
      String Function() getSelected){
    var langMap = languageMap();
    String getRealSelected() => langMap.entries.firstWhere((e) => e.value == getSelected()).key;
    languages = _createDropdown(langMap.keys.toList(), getRealSelected(), setSelected, getRealSelected);

  }

  void setSelected(String newLang){
    Loading().setLang(newLang);
    pickLang(newLang);
    resetUI(newLang);
  }

  Widget getMyWidget(){
    return SizedBox(height: 50, width: 600, child: Align(alignment: AlignmentGeometry.centerRight, child: languages));
  }
  
  DropdownButton<String> _createDropdown(List<String> languages, String hint, void Function(String) setSelected, String Function() getSelected) {
    return DropdownButton<String>(
        hint: ValueListenableBuilder(
            valueListenable: change,
            builder: (context, subValue, widget) => Text(getSelected().isEmpty
                ? hint
                : getSelected())),
        items: languages.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (s) {
          if (s == null || s.isEmpty) {
            return;
          }
          setSelected(languageMap()[s]!);
          change.value = !change.value;
        });
  }
}