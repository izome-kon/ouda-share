import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:listar_flutter_pro/models/model.dart';
import 'package:listar_flutter_pro/utils/utils.dart';

class DailyBookingModel extends BookingStyleModel {
  DateTime? startDate;
  TimeOfDay? startTime;
  DateTime? endDate;
  TimeOfDay? endTime;

  DailyBookingModel({
    price,
    adult,
    children,
    this.startDate,
    this.startTime,
    this.endDate,
    this.endTime,
  }) : super(price: price, adult: adult, children: children);

  @override
  Map<String, dynamic> get params {
    Map<String, dynamic> params = {
      'booking_style': 'daily',
      'adult': adult,
      'children': children,
      'start_date': startDate?.dateView,
      'start_time': startTime?.viewTime,
    };
    if (endDate != null) {
      params['end_date'] = DateFormat('yyyy-MM-dd').format(endDate!);
    }
    if (endTime != null) {
      params['end_time'] = endTime?.viewTime;
    }
    return params;
  }

  factory DailyBookingModel.fromJson(Map<String, dynamic> json) {
    TimeOfDay? startTime;
    TimeOfDay? endTime;
    if (json['start_time'] != null) {
      startTime = TimeOfDay.fromDateTime(
        DateFormat('HH:mm').parse(json['start_time']),
      );
    }

    if (json['end_time'] != null) {
      endTime = TimeOfDay.fromDateTime(
        DateFormat('HH:mm').parse(json['end_time']),
      );
    }
    return DailyBookingModel(
      price: json['price'] as String,
      startDate: DateTime.tryParse(json['start_date']),
      startTime: startTime,
      endDate: DateTime.tryParse(json['start_date']),
      endTime: endTime,
    );
  }
}
