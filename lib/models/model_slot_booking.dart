import 'package:listar_flutter_pro/models/model.dart';

class SlotBookingModel extends BookingStyleModel {
  SlotBookingModel({
    price,
    adult,
    children,
  }) : super(price: price, adult: adult, children: children);

  @override
  Map<String, dynamic> get params {
    return {
      'booking_style': 'slot',
      'adult': adult,
      'children': children,
    };
  }

  factory SlotBookingModel.fromJson(Map<String, dynamic> json) {
    return SlotBookingModel(
      price: json['price'] as String,
    );
  }
}
