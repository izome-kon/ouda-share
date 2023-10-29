import 'package:bloc/bloc.dart';
import 'package:listar_flutter_pro/blocs/bloc.dart';
import 'package:listar_flutter_pro/repository/repository.dart';

import 'cubit.dart';

class ReviewCubit extends Cubit<ReviewState> {
  ReviewCubit() : super(ReviewLoading());

  Future<void> onLoad(int id) async {
    ///Notify
    emit(ReviewLoading());

    ///Fetch API
    final result = await ReviewRepository.loadReview(id);
    if (result != null) {
      ///Notify
      emit(
        ReviewSuccess(
          list: result[0],
          rate: result[1],
        ),
      );
    }
  }

  Future<bool> onSave({
    required int id,
    required String content,
    required double rate,
  }) async {
    ///Fetch API
    final result = await ReviewRepository.saveReview(
      id: id,
      content: content,
      rate: rate,
    );
    if (result) {
      final result = await ReviewRepository.loadReview(id);
      if (result != null) {
        ///Notify
        emit(
          ReviewSuccess(
            id: id,
            list: result[0],
            rate: result[1],
          ),
        );
      }
    }
    return result;
  }
}
