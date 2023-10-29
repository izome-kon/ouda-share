import 'package:listar_flutter_pro/models/model.dart';

abstract class ProfileEvent {}

class OnLoad extends ProfileEvent {
  final FilterModel filter;
  final String keyword;
  final int userID;
  final bool listing;

  OnLoad({
    required this.filter,
    required this.keyword,
    required this.userID,
    required this.listing,
  });
}

class OnLoadMore extends ProfileEvent {
  final FilterModel filter;
  final String keyword;
  final int userID;
  final bool listing;

  OnLoadMore({
    required this.filter,
    required this.keyword,
    required this.userID,
    required this.listing,
  });
}

class OnProfileSearch extends ProfileEvent {
  final FilterModel filter;
  final String keyword;
  final int userID;
  final bool listing;

  OnProfileSearch({
    required this.filter,
    required this.keyword,
    required this.userID,
    required this.listing,
  });
}
