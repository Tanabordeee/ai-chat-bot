import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ai_chat_bot/storage/token_storage.dart';

class AuthRepository {
  final String baseurl =
      "http://127.0.0.1:8000"; // เปลี่ยนเป็น IP จริงถ้าใช้มือถือ
  final TokenStorage storage = TokenStorage();

  Future<String> login(String username, String password) async {
    final response = await http.post(
      Uri.parse("$baseurl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data["access_token"];
      await storage.saveToken(token); // เก็บ token
      return token;
    } else {
      throw Exception("Failed to login");
    }
  }

  Future<bool> hasToken() async {
    final token = await storage.getToken();
    return token != null;
  }

  Future<void> logout() async {
    await storage.deleteToken();
  }
}
