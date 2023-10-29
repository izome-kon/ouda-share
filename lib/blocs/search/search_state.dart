import 'package:listar_flutter_pro/models/model.dart';

abstract class SearchState {}

class InitialSearchState extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<ProductModel> list;
  SearchSuccess({required this.list});
}
