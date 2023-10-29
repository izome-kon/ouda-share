import 'package:listar_flutter_pro/models/model.dart';
import 'package:listar_flutter_pro/utils/utils.dart';

class HourlyBookingModel extends BookingStyleModel {
  DateTime? startDate;
  ScheduleModel? schedule;
  List<ScheduleModel> hourList;

  HourlyBookingModel({
    price,
    adult,
    children,
    this.startDate,
    this.schedule,
    required this.hourList,
  }) : super(price: price, adult: adult, children: children);

  @override
  Map<String, dynamic> get params {
    return {
      'booking_style': 'hourly',
      'adult': adult,
      'children': children,
      'start_date': startDate?.dateView,
      'start_time': schedule?.start.viewTime,
      'end_time': schedule?.end.viewTime,
    };
  }

  factory HourlyBookingModel.fromJson(Map<String, dynamic> json) {
    return HourlyBookingModel(
      price: json['price'] as String,
      startDate: DateTime.tryParse(json['start_date']),
      hourList: List.from(json['select_options'] ?? []).map((e) {
        return ScheduleModel.fromJson(e);
      }).toList(),
    );
  }
}
