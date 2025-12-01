import 'package:flutter/material.dart';
import 'package:irene_hours/models/reg_act.dart';
import 'package:irene_hours/ui_elements/arthur_text.dart';
import 'package:irene_hours/ui_elements/text_input_popup.dart';
import 'package:irene_hours/ui_elements/time-picker.dart';

class RegActDisplay {
  final TimePicker _timeStart = TimePicker();
  late final ValueNotifier<String> _companyName = ValueNotifier(
        old.companyName,
      ),
      _action = ValueNotifier(old.actionName);

  // late String _companyName = old.companyName, _action = old.actionName;
  final ValueNotifier<bool> _deleteMe = ValueNotifier(false);
  RegAct old;

  RegActDisplay(this.old) {
    _timeStart.setTimeStart(old.startTime);
    _timeStart.setTimeEnd(old.endTime);
  }

  Widget getMyWidget(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _deleteMe,
      builder: (newContext, toDelete, widget) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          arthurButton(
            onPressed: () => textPressed(context, _companyName),
            child: ValueListenableBuilder(
              valueListenable: _companyName,
              builder: (newContext, newValue, widget) => arthurText(toDelete ? '❌$newValue' : newValue),
            ),
          ),
          arthurButton(
            onPressed: () => textPressed(context, _action),
            child: ValueListenableBuilder(
              valueListenable: _action,
              builder: (newContext, newValue, widget) => arthurText(toDelete ? '❌$newValue' : newValue),
            ),
          ),
          _timeStart.getMyWidget(context),
          arthurButton(onPressed: deleteMe, child: arthurText(toDelete ? '✔' : '❌')),
        ],
      ),
    );
  }

  void textPressed(BuildContext context, ValueNotifier correct) {
    displayTextInputDialog(context, correct.value).then((e) {
      if (e == null) return;
      correct.value = e;
    });
  }

  ///will return new regact if it needs to be updated
  RegAct? shouldStore() {
    if (_deleteMe.value) {
      return null;
    }
    RegAct newValue = RegAct(
      _timeStart.getStartTime(),
      _companyName.value,
      _action.value,
      _timeStart.getEndTime(),
      old.day,
    );
    if (newValue != old) {
      return newValue;
    }
    return null;
  }

  bool wantDelete(){
    return _deleteMe.value;
  }

  void deleteMe() {
    _deleteMe.value = !_deleteMe.value;
  }
}
