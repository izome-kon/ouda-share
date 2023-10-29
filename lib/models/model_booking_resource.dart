class BookingResourceModel {
  final String id;
  final String name;
  final int quantity;
  final num total;

  BookingResourceModel({
    required this.id,
    required this.name,
    required this.quantity,
    required this.total,
  });

  factory BookingResourceModel.fromJson(Map<String, dynamic> json) {
    return BookingResourceModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      quantity: json['qty'] ?? '',
      total: json['total'] ?? '',
    );
  }
}
