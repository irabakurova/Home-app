extension DateTimeExtensions on DateTime {
  /// Returns date-only (midnight) in local timezone
  DateTime get dateOnly => DateTime(year, month, day);

  /// Unix timestamp in milliseconds
  int get timestampMs => millisecondsSinceEpoch;

  /// E.g. "7 июня 2026"
  String get russianDate {
    const months = [
      '', 'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
      'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря',
    ];
    return '$day ${months[month]} $year';
  }

  /// Day name in Russian
  String get russianWeekday {
    const days = [
      '', 'Понедельник', 'Вторник', 'Среда',
      'Четверг', 'Пятница', 'Суббота', 'Воскресенье',
    ];
    return days[weekday];
  }

  /// Short day name
  String get russianWeekdayShort {
    const days = ['', 'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    return days[weekday];
  }

  /// Start of the week (Monday)
  DateTime get startOfWeek {
    final d = dateOnly;
    return d.subtract(Duration(days: d.weekday - 1));
  }
}

extension TimestampExtension on int {
  DateTime get fromTimestampMs => DateTime.fromMillisecondsSinceEpoch(this);
}
