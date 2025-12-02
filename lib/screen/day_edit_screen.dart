import 'package:flutter/material.dart';
import 'package:irene_hours/translations.dart';
import 'package:irene_hours/ui_elements/day-picker.dart';
import 'package:irene_hours/ui_elements/reg_action_display.dart';

import '../loading/loading.dart';
import '../ui_elements/arthur_text.dart';

class DayEditScreen extends StatefulWidget {
  final Loading l = Loading();

  DayEditScreen({super.key});

  @override
  State<DayEditScreen> createState() => _DayEditScreenState();
}

class _DayEditScreenState extends State<DayEditScreen> {
  DatePicker dayPicker = DatePicker(language['selectedDay']!);
  List<RegActDisplay> regActs = [];

  late DateTime _curDate;

  //button save, cancel, yesterday? tomorrow?

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (BuildContext subcontext, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      height: 40.0,
                      alignment: Alignment.topCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          dayPicker.getMyWidget(
                            context,
                            (s) => setState(() {
                              _curDate = s;
                            }),
                          ),
                          Text('  '),
                          arthurButton(
                            onPressed: () => saveClick(context),
                            child: arthurText(language['ok']!),
                          ),
                          arthurButton(
                            onPressed: () => Navigator.pop(context),
                            child: arthurText(language['cancel']!),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.topCenter,
                        child: SingleChildScrollView(
                          child: FutureBuilder(
                            future: createActions(context),
                            builder: (context, widget) =>
                                widget.data == null ? Text('') : widget.data!,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _curDate = dayPicker.getDate();
  }

  void saveClick(BuildContext context) {
    for (var e in regActs) {
      var result = e.shouldStore();
      if (result == null) {
        if (e.wantDelete()){
          widget.l.removeRegActFromStorage(e.old);
        }
        continue;
      }
      widget.l.removeRegActFromStorage(e.old);
      widget.l.storeRegAct(result);
    }
    Navigator.pop(context);
  }

  Future<Widget> createActions(BuildContext context) async {
    var acts = (await widget.l.getAllRegActions(
      _curDate,
      _curDate,
    ))..sort((a,b) => a.compareTo(b));

    regActs = acts.map((e) => RegActDisplay(e)).toList();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: regActs.map((e) => e.getMyWidget(context)).toList(),
    );
  }
}
