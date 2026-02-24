import "dart:convert";

import "package:http/http.dart" as http;

class AuthRepository {
  final String baseurl = "http://127.0.0.1:8000";

  Future<String> login(String username, String password) async {
    final response = await http.post(
      Uri.parse("$baseurl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["token"];
    } else {
      throw Exception("Failed to login");
    }
  }
}
