class RegAct implements Comparable<RegAct> {
  final DateTime day;
  final DateTime startTime;
  final DateTime endTime;
  final String companyName;
  final String actionName;

  RegAct(
    this.startTime,
    this.companyName,
    this.actionName,
    this.endTime,
    this.day,
  );

  bool isActualTime() {
    return getTime() > 1;
  }

  int getTime() {
    return endTime.difference(startTime).inMinutes;
  }

  @override
  String toString() {
    return "$companyName - $actionName";
  }

  String fromString() {
    return "$companyName ⬛ $actionName: $startTime ⮕ $endTime";
  }

  @override
  int compareTo(RegAct o) {
    int data;
    if (!sameDay(day, o.day)) {
      data = day.compareTo(o.day);
      if (data != 0) {
        return data;
      }
    }
    data = startTime.compareTo(o.startTime);
    if (data == 0) {
      data = endTime.compareTo(o.endTime);
    }
    return data;
  }

  static bool sameTime(DateTime dayOne, DateTime dayTwo) {
    return dayOne.hour == dayTwo.hour && dayOne.minute == dayTwo.minute;
  }

  static bool sameDay(DateTime dayOne, DateTime dayTwo) {
    return dayOne.year == dayTwo.year &&
        dayOne.month == dayTwo.month &&
        dayOne.day == dayTwo.day;
  }

  @override
  bool operator ==(Object other) {
    if (other is! RegAct) {
      return false;
    }
    return sameTime(startTime, other.startTime) &&
        sameTime(endTime, other.endTime) &&
        actionName == other.actionName &&
        other.companyName == companyName &&
        sameDay(day, other.day);
  }
}
