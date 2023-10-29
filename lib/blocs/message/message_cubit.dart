import 'dart:async';

import 'package:bloc/bloc.dart';

class MessageCubit extends Cubit<String?> {
  MessageCubit() : super(null);
  Timer? timer;

  void onShow(String message) {
    timer?.cancel();
    timer = Timer(const Duration(milliseconds: 500), () {
      emit(message);
      emit(null);
    });
  }
}
