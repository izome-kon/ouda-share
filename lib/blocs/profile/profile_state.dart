import 'package:listar_flutter_pro/models/model.dart';

abstract class ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final UserModel user;
  final List<ProductModel> listProduct;
  final List<ProductModel> listProductPending;
  final List<CommentModel> listComment;
  final bool canLoadMore;
  final bool loadingMore;

  ProfileSuccess({
    required this.user,
    required this.listProduct,
    required this.listProductPending,
    required this.listComment,
    required this.canLoadMore,
    this.loadingMore = false,
  });
}
