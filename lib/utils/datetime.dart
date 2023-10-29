import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension TimeParsing on TimeOfDay {
  String get viewTime {
    String _addLeadingZeroIfNeeded(int value) {
      if (value < 10) return '0$value';
      return value.toString();
    }

    final hourLabel = _addLeadingZeroIfNeeded(hour);
    final minuteLabel = _addLeadingZeroIfNeeded(minute);

    return '$hourLabel:$minuteLabel';
  }
}

extension DateView on DateTime {
  String get dateView {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  String get fullDateView {
    return DateFormat('EEE, MMM d, yy').format(this);
  }
}
