import 'package:listar_flutter_pro/models/model.dart';

abstract class BookingManagementState {}

class BookingListLoading extends BookingManagementState {}

class BookingListSuccess extends BookingManagementState {
  final List<BookingItemModel> listBooking;
  final List<BookingItemModel> listRequest;
  final bool canLoadMoreBooking;
  final bool canLoadMoreRequest;
  final bool loadingMoreBooking;
  final bool loadingMoreRequest;

  BookingListSuccess({
    required this.listBooking,
    required this.listRequest,
    required this.canLoadMoreBooking,
    required this.canLoadMoreRequest,
    this.loadingMoreRequest = false,
    this.loadingMoreBooking = false,
  });
}
