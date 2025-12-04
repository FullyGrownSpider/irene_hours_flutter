import 'package:flutter/material.dart';
import 'package:irene_hours/screen/add_after_screen.dart';
import 'package:irene_hours/screen/day_edit_screen.dart';
import 'package:irene_hours/ui_elements/add_remove_box.dart';
import 'package:irene_hours/loading/loading.dart';
import 'package:irene_hours/ui_elements/arthur_text.dart';
import 'package:irene_hours/ui_elements/day-picker.dart';
import 'package:irene_hours/ui_elements/start_button.dart';

import '../translations.dart';
import '../ui_elements/text_input_popup.dart';

class BaseScreen extends StatefulWidget {
  final Loading l = Loading();

  BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  AddRemoveBox? companyBox, actionBox;
  late DatePicker daysStart, daysEnd;

  late StartButton startButton = StartButton(
    (s) {
      setState(() {
        widget.l.storeRegAct(s);
      });
    },
    () => selectedCompany,
    () => selectedAction,
    () {
      setState(() {
        companyBox!.flipActive();
        actionBox!.flipActive();
      });
    },
    () {
      _showMyDialog(language['forgotSelect']!);
    },
  );

  String selectedCompany = '';
  String selectedAction = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder(
                future: widget.l.getAllCompanyNames(),
                builder: (a, b) {
                  if (!b.hasData) return const Text('');
                  b.data!.sort((a, b) => a.compareTo(b));
                  companyBox = createCompanyBox(context, b.data!);
                  return companyBox!.getMyWidget();
                },
              ),
              FutureBuilder(
                future: widget.l.getAllActions(),
                builder: (a, b) {
                  if (!b.hasData) return const Text('');
                  b.data!.sort((a, b) => a.compareTo(b));
                  actionBox = createActionBox(context, b.data!);
                  return actionBox!.getMyWidget();
                },
              ),
              startButton.getMyWidget(),
              arthurText(' '),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  arthurButton(
                    onPressed: () {
                      if (selectedCompany.isEmpty || selectedAction.isEmpty) {
                        _showMyDialog(language['forgotSelect']!);
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (context) =>
                              AddAfterScreen(selectedCompany, selectedAction),
                        ),
                      );
                    },

                    child: arthurText(language['afterwards']!),
                  ),
                  arthurButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DayEditScreen(),
                        ),
                      );
                    },
                    child: arthurText(language['editDay']!),
                  ),
                ],
              ),
              arthurText(' '),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  daysStart.getMyWidget(context),
                  arthurText('  ⎻⎻⎻⎻⎻  '),
                  daysEnd.getMyWidget(context),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  arthurButton(
                    onPressed: () {
                      widget.l.createExport(
                        daysStart.getDate(),
                        daysEnd.getDate(),
                        null,
                        _showMyDialog,
                      );
                    },
                    child: arthurText(language['dayExport']!),
                  ),
                  arthurButton(
                    onPressed: () {
                      if (companyBox!.getSelected().isEmpty) {
                        _showMyDialog(language['forgotSelect']!);
                        return;
                      }
                      widget.l.createExport(
                        daysStart.getDate(),
                        daysEnd.getDate(),
                        companyBox!.getSelected(),
                        _showMyDialog,
                      );
                    },
                    child: arthurText(language['companyExport']!),
                  ),
                ],
              ),
              arthurText('   '),
              arthurButton(
                onPressed: () {
                  widget.l.exportHTML();
                },
                child: arthurText(language['defaultHTML']!),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  arthurButton(
                    onPressed: () {
                      setStorageLocation(context);
                    },
                    child: arthurText(language['exportLocation']!),
                  ),
                  FutureBuilder(
                    future: widget.l.getPath(),
                    builder: (newContext, text) =>
                        arthurText(text.hasData ? shorten(text.data!, 40) : ''),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    daysEnd = DatePicker(language['dayPickEnd']!);
    daysStart = DatePicker(language['dayPickStart']!);
  }

  AddRemoveBox createCompanyBox(BuildContext context, List<String> data) {
    return AddRemoveBox(
      language['companies']!,
      data,
      (s) {
        setState(() {
          widget.l.removeCompanyFromStorgage(s);
        });
      },
      (s) => selectedCompany = s,
      () => selectedCompany,
      (s) {
        displayTextInputDialog(context, s).then((e) {
          if (e == null || e.isEmpty) return;
          setState(() {
            widget.l.storeCompany(e);
          });
        });
      },
    );
  }

  AddRemoveBox createActionBox(BuildContext context, List<String> data) {
    return AddRemoveBox(
      language['actions']!,
      data,
      (s) {
        widget.l.removeActionFromStorage(s);
        createCompanyBox(context, data);
      },
      (s) => selectedAction = s,
      () => selectedAction,
      (s) {
        displayTextInputDialog(context, s).then((e) {
          if (e == null || e.isEmpty) return;
          setState(() {
            widget.l.storeAction(e);
            createActionBox(context, data);
          });
        });
      },
    );
  }

  Future<void> _showMyDialog(String s) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: arthurText(language['problem']!),
          content: SingleChildScrollView(
            child: ListBody(children: <Widget>[arthurText(s)]),
          ),
          actions: <Widget>[
            arthurButton(
              child: arthurText('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void setStorageLocation(BuildContext context) {
    displayTextInputDialog(context, '').then((e) {
      if (e == null) return;
      widget.l.setPath(e);
    });
  }

  String shorten(String s, int i) {
    if (s.length <= i) return s;
    int half = (i / 2).toInt();
    return '${s.substring(0, half - 3)}... ...${s.substring(s.length - half + 3, s.length)}';
  }
}
