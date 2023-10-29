import 'package:listar_flutter_pro/api/api.dart';
import 'package:listar_flutter_pro/blocs/bloc.dart';
import 'package:listar_flutter_pro/models/model.dart';

class ReviewRepository {
  ///Fetch api getReview
  static Future<List?> loadReview(id) async {
    final response = await Api.requestReview({"post_id": id});
    if (response.success) {
      final listComment = List.from(response.data ?? []).map((item) {
        return CommentModel.fromJson(item);
      }).toList();
      final rate = RateModel.fromJson(response.attr['rating']);
      return [listComment, rate];
    }
    AppBloc.messageCubit.onShow(response.message);
    return null;
  }

  ///Fetch save review
  static Future<bool> saveReview({
    required int id,
    required String content,
    required double rate,
  }) async {
    final params = {
      "post": id,
      "content": content,
      "rating": rate,
    };
    final response = await Api.requestSaveReview(params);
    AppBloc.messageCubit.onShow(response.message);
    if (response.success) {
      return true;
    }
    return false;
  }

  ///Fetch author review
  static Future<ResultApiModel> loadAuthorReview({
    required int page,
    required int perPage,
    required String keyword,
    required int userID,
  }) async {
    Map<String, dynamic> params = {
      "page": page,
      "per_page": perPage,
      "s": keyword,
      "user_id": userID,
    };
    return await Api.requestAuthorReview(params);
  }
}
