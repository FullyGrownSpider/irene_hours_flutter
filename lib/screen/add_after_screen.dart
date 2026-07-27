import 'package:flutter/material.dart';
import 'package:irene_hours/models/reg_act.dart';
import 'package:irene_hours/translations.dart';
import 'package:irene_hours/ui_elements/arthur_text.dart';

import '../loading/loading.dart';
import '../models/company.dart';
import '../ui_elements/day-picker.dart';
import '../ui_elements/time-picker.dart';

class AddAfterScreen extends StatefulWidget {
  final Loading l = Loading();
  final Company company;
  final String action;

  AddAfterScreen(this.company, this.action, {super.key});

  @override
  State<AddAfterScreen> createState() => _AddAfterScreenState();
}

class _AddAfterScreenState extends State<AddAfterScreen> {
  TimePicker hour = TimePicker();
  DatePicker date = DatePicker(language[Words.dayArrow]!);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: date.getMyWidget(context)),
          Center(child: arthurText(widget.company.companyName)),
          Center(child: arthurText(widget.action)),
          Center(child: hour.getMyWidget(context)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              arthurButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: arthurText(language[Words.cancel]!),
              ),
              arthurButton(
                onPressed: () {
                  widget.l.storeRegAct(
                    RegAct(
                      hour.getStartTime(),
                      widget.company,
                      widget.action,
                      hour.getEndTime(),
                      date.getDate(),
                    ),
                  );
                  Navigator.pop(context);
                },
                child: arthurText(language[Words.submit]!),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
