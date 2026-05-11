import 'package:flutter/material.dart';
import 'package:irene_hours/translations.dart';

import 'arthur_text.dart';

Future<String?> displayTextInputDialog(BuildContext context, String oText, String inputText) async {
  var controller = TextEditingController(text: oText);
  return showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.grey,
        title: arthurText(inputText),
        content: TextField(
          controller: controller,
        ),
        actions: <Widget>[
          arthurButton(
            child: arthurText(language[Words.cancel]!),
            onPressed: () {
              Navigator.pop(context, null);
            },
          ),
          arthurButton(
            child: arthurText(language[Words.ok]!),
            onPressed: () {
              Navigator.pop(context, controller.text);
            },
          ),
        ],
      );
    },
  );
}
