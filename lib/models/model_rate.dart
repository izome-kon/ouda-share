class RateModel {
  final double one;
  final double two;
  final double three;
  final double four;
  final double five;
  final double avg;
  final int total;

  RateModel({
    required this.one,
    required this.two,
    required this.three,
    required this.four,
    required this.five,
    required this.avg,
    required this.total,
  });

  factory RateModel.fromJson(Map<String, dynamic> json) {
    return RateModel(
      one: json['rating_meta']['1'] / json['rating_count'] ?? 0.0,
      two: json['rating_meta']['2'] / json['rating_count'] ?? 0.0,
      three: json['rating_meta']['3'] / json['rating_count'] ?? 0.0,
      four: json['rating_meta']['4'] / json['rating_count'] ?? 0.0,
      five: json['rating_meta']['5'] / json['rating_count'] ?? 0.0,
      avg: double.tryParse(json['rating_avg'].toString()) ?? 0.0,
      total: json['rating_count'] ?? 0,
    );
  }
}
