import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:irene_hours/ui_elements/arthur_text.dart';

class DatePicker {
  final ValueNotifier<DateTime> _notifier = ValueNotifier(DateTime.now());

  final String _text;

  DatePicker(this._text);

  Widget getMyWidget(BuildContext context, [void Function(DateTime)? onChanged]) {
    return ValueListenableBuilder(
      valueListenable: _notifier,
      builder: (context, value, widget) => arthurButton(
        child: arthurText(
          '$_text  ${formatDate(_notifier.value, [yyyy, ' - ', MM, ' - ', d])}',
        ),
        onPressed: () async {
          var result = await _selectDate(context);
          if (result != null) {
            _notifier.value = result;
            if (onChanged != null) {
              onChanged(result);
            }
          }
        },
      ),
    );
  }

  DateTime getDate() {
    return _notifier.value;
  }
  Future<DateTime?> _selectDate(BuildContext context) {
    return showDatePicker(
      context: context,
      initialDate: _notifier.value,
      firstDate: DateTime.now().add(Duration(days: -3560)),
      lastDate: DateTime.now().add(Duration(days: 3560)),
    );
  }
}