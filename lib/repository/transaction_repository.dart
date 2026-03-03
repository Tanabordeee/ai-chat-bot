import 'dart:convert';
import 'package:ai_chat_bot/models/transaction.dart';
import 'package:ai_chat_bot/storage/token_storage.dart';
import 'package:http/http.dart' as http;

class TransactionRepository {
  final String baseUrl = "http://10.0.2.2:8000";
  final TokenStorage storage = TokenStorage();

  Future<List<Transaction>> getTransactionsByAccountId(int accountId) async {
    final token = await storage.getToken();
    if (token == null) throw Exception("Token not found");

    final response = await http.get(
      Uri.parse("$baseUrl/transaction/account/$accountId"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => Transaction.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load transactions: ${response.statusCode}");
    }
  }

  Future<List<Transaction>> getTransactionsByUserId() async {
    final token = await storage.getToken();
    if (token == null) throw Exception("Token not found");

    final response = await http.get(
      Uri.parse("$baseUrl/transaction/user"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => Transaction.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load transactions: ${response.statusCode}");
    }
  }

  Future<Map<String, dynamic>> Calculate_all_transactions() async {
    final token = await storage.getToken();
    if (token == null) throw Exception("Token not found");

    final response = await http.get(
      Uri.parse("$baseUrl/transaction/user"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      double income = 0;
      double expense = 0;
      List<Transaction> transactions = [];

      for (var json in data) {
        final tx = Transaction.fromJson(json);
        transactions.add(tx);
        if (tx.transactionType == "income") {
          income += tx.amount * tx.price;
        } else {
          expense += tx.amount * tx.price;
        }
      }
      double balance = income - expense;
      return {
        "summary": {"balance": balance, "income": income, "expense": expense},
        "raw": transactions,
      };
    } else {
      throw Exception("Failed to load transactions: ${response.statusCode}");
    }
  }
}
