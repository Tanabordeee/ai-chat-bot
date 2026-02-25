import 'dart:convert';
import 'package:ai_chat_bot/models/user.dart';
import 'package:ai_chat_bot/storage/token_storage.dart';
import 'package:http/http.dart' as http;

class UserRepository {
  final String baseUrl = "http://10.0.2.2:8000";
  final TokenStorage storage = TokenStorage();

  Future<User?> getUserById(String id) async {
    final token = await storage.getToken();
    if (token == null) return null;

    final response = await http.get(
      Uri.parse("$baseUrl/users/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data);
    }
    return null;
  }

  Future<bool> removeUser(String id) async {
    final token = await storage.getToken();
    if (token == null) return false;

    final response = await http.delete(
      Uri.parse("$baseUrl/users/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print("Delete user response: ${response.statusCode} - ${response.body}");

    // รองรับทั้ง 200 และ 204
    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    }
    return false;
  }
}
