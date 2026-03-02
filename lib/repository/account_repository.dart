import 'dart:convert';
import 'package:ai_chat_bot/models/account.dart';
import 'package:ai_chat_bot/storage/token_storage.dart';
import 'package:http/http.dart' as http;

class AccountRepository {
  final String baseUrl = "http://10.0.2.2:8000";
  final TokenStorage storage = TokenStorage();

  Future<List<Account>> getAccounts() async {
    final token = await storage.getToken();
    if (token == null) throw Exception("Token not found");

    final response = await http.get(
      Uri.parse("$baseUrl/accounts/"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Account.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load accounts: ${response.statusCode}");
    }
  }

  Future<void> createAccount(
    String name,
    double balance,
    dynamic user_id,
  ) async {
    final token = await storage.getToken();
    if (token == null) throw Exception("Token not found");

    final response = await http.post(
      Uri.parse("$baseUrl/accounts/"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "account_name": name,
        "balance": balance,
        "user_id": user_id,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
        "Failed to create account: ${response.statusCode}\nDetails: ${response.body}",
      );
    }
  }
}
