class PaginationModel {
  final int page;
  final int perPage;
  final int maxPage;
  final int total;

  PaginationModel({
    required this.page,
    required this.perPage,
    required this.maxPage,
    required this.total,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      page: json['page'] ?? 0,
      perPage: json['per_page'] ?? 0,
      maxPage: json['max_page'] ?? 0,
      total: json['total'] ?? 0,
    );
  }
}
