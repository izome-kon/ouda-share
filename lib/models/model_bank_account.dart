class BankAccountModel {
  final String name;
  final String number;
  final String bankName;
  final String bankCode;
  final String bankIban;
  final String bankSwift;

  BankAccountModel({
    required this.name,
    required this.number,
    required this.bankName,
    required this.bankCode,
    required this.bankIban,
    required this.bankSwift,
  });

  factory BankAccountModel.fromJson(Map<String, dynamic> json) {
    return BankAccountModel(
      name: json['acc_name'] ?? '',
      number: json['acc_number'] ?? '',
      bankName: json['bank_name'] ?? '',
      bankCode: json['bank_sort_code'] ?? '',
      bankIban: json['bank_iban'] ?? '',
      bankSwift: json['bank_swift'] ?? '',
    );
  }
}
