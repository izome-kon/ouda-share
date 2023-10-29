import 'package:flutter/material.dart';
import 'package:listar_flutter_pro/models/model.dart';
import 'package:listar_flutter_pro/utils/utils.dart';

class BookingItemModel {
  final int id;
  final String title;
  final String status;
  final Color statusColor;
  final DateTime? date;
  final String? paymentName;
  final String? payment;
  final String? transactionID;
  final int? total;
  final String? currency;
  final String? totalDisplay;
  final String? billFirstName;
  final String? billLastName;
  final String? billPhone;
  final String? billEmail;
  final String? billAddress;
  final List<BookingResourceModel>? resource;
  final bool? allowCancel;
  final bool? allowPayment;
  final String? createdOn;
  final String? paidOn;
  final String? createdVia;
  final String? createdBy;

  BookingItemModel({
    required this.id,
    required this.title,
    required this.status,
    required this.statusColor,
    this.date,
    this.paymentName,
    this.payment,
    this.transactionID,
    this.total,
    this.currency,
    this.totalDisplay,
    this.billFirstName,
    this.billLastName,
    this.billPhone,
    this.billEmail,
    this.billAddress,
    this.resource,
    this.allowCancel,
    this.allowPayment,
    this.createdOn,
    this.paidOn,
    this.createdVia,
    this.createdBy,
  });

  factory BookingItemModel.fromJson(Map<String, dynamic> json) {
    return BookingItemModel(
      id: int.tryParse('${json['ID'] ?? json['booking_id']}') ?? 0,
      title: json['title'] ?? '',
      status: json['status_name'] ?? '',
      statusColor: UtilColor.getColorFromHex(json['status_color']),
      date: DateTime.tryParse(
        json['date'] ?? json['created_on'],
      ),
      paymentName: json['payment_name'] ?? '',
      payment: json['payment'] ?? '',
      transactionID: json['txn_id'] ?? '',
      total: json['total'] ?? 0,
      currency: json['currency'] ?? '',
      totalDisplay: json['total_display'] ?? '',
      billFirstName: json['billing_first_name'] ?? '',
      billLastName: json['billing_last_name'] ?? '',
      billPhone: json['billing_phone'] ?? '',
      billEmail: json['billing_email'] ?? '',
      billAddress: json['billing_address_1'] ?? '',
      resource: List.from(json['resources'] ?? []).map((item) {
        return BookingResourceModel.fromJson(item);
      }).toList(),
      allowCancel: json['allow_cancel'] ?? false,
      allowPayment: json['allow_payment'] ?? false,
      createdOn: json['created_on'] ?? '',
      paidOn: json['paid_date'] ?? '',
      createdVia: json['create_via'] ?? '',
      createdBy: '${json['first_name']} ${json['last_name']}',
    );
  }

  factory BookingItemModel.fromNotification(Map<String, dynamic> json) {
    return BookingItemModel(
      id: int.tryParse('${json['ID'] ?? json['booking_id']}') ?? 0,
      title: json['title'] ?? '',
      status: json['status_name'] ?? '',
      statusColor: UtilColor.getColorFromHex(json['status_color']),
      date: DateTime.tryParse(
        json['date'] ?? json['created_on'] ?? '',
      ),
    );
  }
}
