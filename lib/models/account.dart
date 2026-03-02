class Account {
  final dynamic id;
  final String name;
  final double balance;
  final dynamic user_id;

  Account({
    required this.id,
    required this.name,
    required this.balance,
    required this.user_id,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      name: json['name'] ?? json['account_name'] ?? json['title'] ?? '',
      balance: _parseDouble(json['balance'] ?? json['amount']),
      user_id: json['user_id'],
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
