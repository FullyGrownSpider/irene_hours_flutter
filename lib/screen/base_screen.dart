import 'package:flutter/material.dart';
import 'package:irene_hours/screen/add_after_screen.dart';
import 'package:irene_hours/screen/day_edit_screen.dart';
import 'package:irene_hours/ui_elements/add_remove_box.dart';
import 'package:irene_hours/loading/loading.dart';
import 'package:irene_hours/ui_elements/add_remove_company_box.dart';
import 'package:irene_hours/ui_elements/arthur_text.dart';
import 'package:irene_hours/ui_elements/day-picker.dart';
import 'package:irene_hours/ui_elements/lang_picker.dart';
import 'package:irene_hours/ui_elements/start_button.dart';

import '../models/company.dart';
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
  late LangPicker langPicker;
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
      _showMyDialog(language[Words.forgotSelect]!);
    },
  );

  Company? selectedCompany;
  String? selectedAction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder(
                future: companyBox != null ? null : widget.l.getAllCompanies(),
                builder: (a, b) {
                  if (companyBox != null) return companyBox!.getMyWidget();
                  if (!b.hasData) return const Text('');
                  b.data!.sort((a, b) => a.compareTo(b));
                  companyBox = createCompanyBox(context, b.data!);
                  return companyBox!.getMyWidget();
                },
              ),
              FutureBuilder(
                future: actionBox != null ? null : widget.l.getAllActions(),
                builder: (a, b) {
                  if (actionBox != null) return actionBox!.getMyWidget();
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
                      if (selectedCompany == null || selectedAction == null) {
                        _showMyDialog(language[Words.forgotSelect]!);
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (context) =>
                              AddAfterScreen(selectedCompany!, selectedAction!),
                        ),
                      );
                    },

                    child: arthurText(language[Words.afterwards]!),
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
                    child: arthurText(language[Words.editDay]!),
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
                    child: arthurText(language[Words.dayExport]!),
                  ),
                  arthurButton(
                    onPressed: () {
                      if (companyBox!.getSelected() == null) {
                        _showMyDialog(language[Words.forgotSelect]!);
                        return;
                      }
                      widget.l.createExport(
                        daysStart.getDate(),
                        daysEnd.getDate(),
                        companyBox!.getSelected(),
                        _showMyDialog,
                      );
                    },
                    child: arthurText(language[Words.companyExport]!),
                  ),
                ],
              ),
              arthurText('   '),
              arthurButton(
                onPressed: () {
                  widget.l.exportHTML();
                },
                child: arthurText(language[Words.defaultHTML]!),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  arthurButton(
                    onPressed: () {
                      setStorageLocation(context);
                    },
                    child: arthurText(language[Words.exportLocation]!),
                  ),
                  FutureBuilder(
                    future: widget.l.getPath(),
                    builder: (newContext, text) =>
                        arthurText(text.hasData ? shorten(text.data!, 40) : ''),
                  ),
                ],
              ),
              langPicker.getMyWidget()
            ],
          ),
        ),
      )),
    );
  }

  @override
  void initState() {
    super.initState();
    daysEnd = DatePicker(language[Words.dayPickEnd]!);
    daysStart = DatePicker(language[Words.dayPickStart]!);
    langPicker = LangPicker((newLang) => setState(() {}), Loading().getLangSync);
  }

  AddRemoveCompanyBox createCompanyBox(BuildContext context, List<Company> data) {
    return AddRemoveCompanyBox(
      language[Words.companies]!,
      data.map((e) => e.companyName).toList(),
      (s) {
        setState(() {
          widget.l.removeCompanyFromStorgage(s);
        });
      },
      (s) {
        if (s != null) {
          var company = data.firstWhere((e) => e.companyName == s,
              orElse: () {
                var c = Company(s);
                  data.add(c);
                  return c;
              });
          selectedCompany = company;
        } else {
          selectedCompany = null;
        }
        setState(() {});},
      () => selectedCompany,
      (s) {
        displayTextInputDialog(context, s, language[Words.companyInput]!).then((e) {
          if (e == null || e.isEmpty) return;
          setState(() {
            companyBox?.addItemToBox(e);
            var newCompany = Company(e);
            widget.l.storeCompany(newCompany);
          });
        });
      },
      widget.l.storeCompany
    );
  }

  AddRemoveBox createActionBox(BuildContext context, List<String> data) {
    return AddRemoveBox<String>(
      language[Words.theAction]!,
      data,
      (s) {
        widget.l.removeActionFromStorage(s);
      },
      (s) => selectedAction = s,
      () => selectedAction,
      (s) {
        displayTextInputDialog(context, s, language[Words.actionInput]!).then((e) {
          if (e == null || e.isEmpty) return;
          setState(() {
            actionBox?.addItemToBox(e);
            widget.l.storeAction(e);
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
          title: arthurText(language[Words.problem]!),
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
    displayTextInputDialog(context, '', language[Words.askPath]!).then((e) {
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