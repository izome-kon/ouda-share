import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:listar_flutter_pro/models/model.dart';
import 'package:listar_flutter_pro/utils/utils.dart';

class TableBookingModel extends BookingStyleModel {
  DateTime? startDate;
  TimeOfDay? startTime;
  List tableList;
  List selected = [];

  TableBookingModel({
    price,
    adult,
    children,
    this.startDate,
    this.startTime,
    required this.tableList,
  }) : super(price: price, adult: adult, children: children);

  @override
  Map<String, dynamic> get params {
    return {
      'booking_style': 'table',
      'adult': adult,
      'children': children,
      'start_date': startDate?.dateView,
      'start_time': startTime?.viewTime,
      'table_num': selected.map((e) {
        return e['id'];
      }).toList(),
    };
  }

  factory TableBookingModel.fromJson(Map<String, dynamic> json) {
    TimeOfDay? startTime;
    if (json['start_time'] != null) {
      startTime = TimeOfDay.fromDateTime(
        DateFormat('HH:mm').parse(json['start_time']),
      );
    }

    return TableBookingModel(
      price: json['price'] as String,
      startDate: DateTime.tryParse(json['start_date']),
      startTime: startTime,
      tableList: json['select_options'] ?? [],
    );
  }
}
