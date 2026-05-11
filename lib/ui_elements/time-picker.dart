import 'package:flutter/material.dart';

import '../translations.dart';
import 'arthur_text.dart';

class SingleHour {
  final ValueNotifier<TimeOfDay> _notifier = ValueNotifier(TimeOfDay.now());

  final String _text;

  SingleHour(this._text);

  Widget getMyWidget(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _notifier,
      builder: (context, value, widget) => arthurButton(
        child: arthurText(
          '$_text ${_notifier.value.hour} - ${_notifier.value.minute}',
        ),
        onPressed: () async {
          var result = await showTimePicker(
            context: context,
            initialTime: _notifier.value,
          );
          if (result != null) {
            _notifier.value = result;
          }
        },
      ),
    );
  }

  DateTime getTime() {
    var now = DateTime.now();
    var timeFound = DateTime(
      now.year,
      now.month,
      now.day,
      _notifier.value.hour,
      _notifier.value.minute,
    );
    return timeFound;
  }
}

class TimePicker {
  final SingleHour _startTime = SingleHour(language[Words.startTime]!),
      _endTime = SingleHour(language[Words.stopTime]!);

  TimePicker() {
    _startTime._notifier.addListener(_checkIt);
    _endTime._notifier.addListener(_checkIt);
  }

  void _checkIt() {
    if (_startTime._notifier.value.isAfter(_endTime._notifier.value)) {
      _endTime._notifier.value = _startTime._notifier.value;
    }
  }

  DateTime getStartTime() {
    return _startTime.getTime();
  }

  DateTime getEndTime() {
    return _endTime.getTime();
  }

  Widget getMyWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _startTime.getMyWidget(context),
        _endTime.getMyWidget(context),
      ],
    );
  }

  void setTimeEnd(DateTime newValue) => _endTime._notifier.value = TimeOfDay(
    hour: newValue.hour,
    minute: newValue.minute,
  );

  void setTimeStart(DateTime newValue) => _startTime._notifier.value =
      TimeOfDay(hour: newValue.hour, minute: newValue.minute);
}
