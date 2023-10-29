class SortModel {
  final String title;
  final String value;
  final String field;

  SortModel({
    required this.title,
    required this.value,
    required this.field,
  });

  factory SortModel.fromJson(Map<String, dynamic> json) {
    return SortModel(
      title: json['lang_key'] ?? "Unknown",
      value: json['value'] ?? "Unknown",
      field: json['field'] ?? "Unknown",
    );
  }
}
