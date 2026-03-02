import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ai_chat_bot/models/chat_message.dart';

class ChatRepository {
  final String baseurl =
      "http://10.0.2.2:8000"; // เปลี่ยนเป็น IP จริงถ้าใช้มือถือ

  Future<ChatResponse> sendChatMessage(int accountId, String prompt) async {
    final response = await http.post(
      Uri.parse("$baseurl/transaction/chat"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"account_id": accountId, "prompt": prompt}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ChatResponse.fromJson(data);
    } else {
      throw Exception("Failed to send chat message");
    }
  }

  Future<ChatResponse> sendOcrRequest(int accountId, File imageFile) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("$baseurl/transaction/ocr"),
    );

    request.fields['account_id'] = accountId.toString();
    request.files.add(
      await http.MultipartFile.fromPath('file', imageFile.path),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ChatResponse.fromJson(data);
    } else {
      throw Exception("Failed to process OCR");
    }
  }
}
