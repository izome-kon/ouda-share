import 'package:listar_flutter_pro/models/model.dart';

abstract class BookingState {}

class FormLoading extends BookingState {}

class FormSuccess extends BookingState {
  final BookingStyleModel bookingStyle;
  final BookingPaymentModel bookingPayment;

  FormSuccess({
    required this.bookingStyle,
    required this.bookingPayment,
  });
}
