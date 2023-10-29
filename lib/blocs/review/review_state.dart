import 'package:listar_flutter_pro/models/model.dart';

abstract class ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewSuccess extends ReviewState {
  final int? id;
  final List<CommentModel> list;
  final RateModel rate;

  ReviewSuccess({
    this.id,
    required this.list,
    required this.rate,
  });
}
