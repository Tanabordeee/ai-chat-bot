import 'dart:convert';
import 'dart:io';
import 'package:ai_chat_bot/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:ai_chat_bot/storage/token_storage.dart';
import 'package:image_picker/image_picker.dart';

class AuthRepository {
  final String baseurl =
      "http://10.0.2.2:8000"; // เปลี่ยนเป็น IP จริงถ้าใช้มือถือ
  final TokenStorage storage = TokenStorage();
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  Future<String> login(String username, String password) async {
    final response = await http.post(
      Uri.parse("$baseurl/auth/login"),
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

  Future<User> register(
    String username,
    String password,
    String phone,
    String email,
    String image,
  ) async {
    final response = await http.post(
      Uri.parse("$baseurl/users/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "password": password,
        "phone": phone,
        "email": email,
        "image": image,
      }),
    );
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return User.fromJson(data);
    } else {
      throw Exception("Failed to register");
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
