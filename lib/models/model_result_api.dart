import 'package:listar_flutter_pro/models/model.dart';

class ResultApiModel {
  final bool success;
  final dynamic data;
  final dynamic attr;
  final dynamic payment;
  final PaginationModel? pagination;
  final UserModel? user;
  final String message;

  ResultApiModel({
    required this.success,
    required this.message,
    this.data,
    this.pagination,
    this.attr,
    this.payment,
    this.user,
  });

  factory ResultApiModel.fromJson(Map<String, dynamic> json) {
    UserModel? user;
    PaginationModel? pagination;
    String message = 'Unknown';

    if (json['user'] != null) {
      user = UserModel.fromJson(json['user']);
    }
    if (json['pagination'] != null) {
      pagination = PaginationModel.fromJson(json['pagination']);
    }
    if (json['success'] == true) {
      message = "save_data_success";
    }
    return ResultApiModel(
      success: json['success'] ?? false,
      data: json['data'],
      pagination: pagination,
      attr: json['attr'],
      payment: json['payment'],
      user: user,
      message: json['message'] ?? json['msg'] ?? message,
    );
  }
}
