class Transaction {
  final int id;
  final int accountId;
  final String name;
  final String transactionType;
  final double amount;
  final double price;
  final String date;

  Transaction({
    required this.id,
    required this.accountId,
    required this.name,
    required this.transactionType,
    required this.amount,
    required this.price,
    required this.date,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      accountId: json['account_id'],
      name: json['name'] ?? '',
      transactionType: json['transaction_type'] ?? 'expense',
      amount: _parseDouble(json['amount']),
      price: _parseDouble(json['price']),
      date: json['date'] ?? '',
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}
