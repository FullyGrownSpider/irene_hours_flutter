import 'package:flutter/material.dart';
import 'package:irene_hours/models/reg_act.dart';

import '../translations.dart';
import 'arthur_text.dart';

class StartButton {
  DateTime? startTime;
  Widget indicator = arthurText('  🔴');
  Widget stoppedText = arthurText(language[Words.start]!);
  Widget startedText = arthurText(language[Words.stop]!);
  final Function(RegAct) exportRegAct;
  final String Function() getCompany;
  final String Function() getAction;
  final void Function() flipEnable;
  final void Function() cantStartError;

  StartButton(
    this.exportRegAct,
    this.getCompany,
    this.getAction,
    this.flipEnable,
    this.cantStartError,
  );

  late Widget buttonStart = arthurButton(
    onPressed: start,
    child: stoppedText,
  );
  late Widget buttonEnd = arthurButton(onPressed: end, child: startedText);

  void start() {
    if (getAction().isEmpty || getCompany().isEmpty) {
      cantStartError();
      return;
    }
    startTime = DateTime.now();
    flipEnable();
  }

  void end() {
    if (DateTime.now().difference(startTime!).inMinutes < 1) {
      flipEnable();
      startTime = null;
      return;
    }
    exportRegAct(
      RegAct(
        startTime!,
        getCompany(),
        getAction(),
        DateTime.now(),
        DateTime.now(),
      ),
    );
    flipEnable();
    startTime = null;
  }

  Widget getMyWidget() {
    if (startTime == null) {
      return buttonStart;
    } else {
      return Row(children: [buttonEnd, indicator]);
    }
  }
}
