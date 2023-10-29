import 'package:bloc/bloc.dart';
import 'package:listar_flutter_pro/blocs/bloc.dart';
import 'package:listar_flutter_pro/models/model.dart';
import 'package:listar_flutter_pro/repository/repository.dart';

import 'cubit.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit() : super(FormLoading());

  ///Init Booking data
  Future<void> initBooking(int id) async {
    final result = await BookingRepository.loadBookingForm(id);
    if (result != null) {
      emit(FormSuccess(
        bookingStyle: result[0],
        bookingPayment: result[1],
      ));
    }
  }

  ///Calc price
  Future<String?> calcPrice({
    required int id,
    required FormSuccess form,
  }) async {
    final params = {
      "resource_id": id,
      ...form.bookingStyle.params,
    };
    return await BookingRepository.calcPrice(params);
  }

  ///Order
  Future<ResultApiModel> order({
    required int id,
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String address,
    String? message,
    required FormSuccess form,
  }) async {
    final params = {
      "resource_id": id,
      "payment_method": form.bookingPayment.method?.id,
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "phone": phone,
      "address": address,
      "memo": message,
      ...form.bookingStyle.params,
    };
    return await BookingRepository.order(params);
  }
}
