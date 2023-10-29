import 'package:listar_flutter_pro/models/model.dart';

abstract class HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<String> banner;
  final List<CategoryModel> category;
  final List<CategoryModel> location;
  final List<ProductModel> recent;

  HomeSuccess({
    required this.banner,
    required this.category,
    required this.location,
    required this.recent,
  });
}
