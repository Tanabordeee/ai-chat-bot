import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ai_chat_bot/models/chat_message.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == MessageSender.user;
    final alignment = isUser
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;
    final color = isUser ? Colors.blueAccent : Colors.grey[200];
    final textColor = isUser ? Colors.white : Colors.black87;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          if (message.imageUrl != null && isUser)
            _buildUserImage(message.imageUrl!),
          if ((message.text != null && message.text!.isNotEmpty) ||
              (message.aiResponse != null &&
                  message.aiResponse!.type == 'add_transaction_result'))
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: Radius.circular(isUser ? 12 : 0),
                  bottomRight: Radius.circular(isUser ? 0 : 12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.text != null && message.text!.isNotEmpty)
                    Text(message.text!, style: TextStyle(color: textColor)),
                  if (message.aiResponse != null &&
                      message.aiResponse!.type == 'add_transaction_result' &&
                      message.aiResponse!.items != null)
                    _buildTransactionItems(
                      message.aiResponse!.items!,
                      textColor,
                    ),
                ],
              ),
            ),
          if (message.aiResponse != null &&
              message.aiResponse!.imageUrl != null)
            _buildAiGraph(message.aiResponse!.imageUrl!),
        ],
      ),
    );
  }

  Widget _buildTransactionItems(List<dynamic> items, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (items.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            "บันทึกรายการแล้ว:",
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const Divider(height: 12),
          ...items.map((item) {
            final name = item['name'] ?? 'ไม่ระบุ';
            final price = item['price'] ?? 0;
            final type = item['transaction_type'] ?? item['type'] ?? '';
            final typeIcon = type == 'income' ? '💰' : '💸';

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(typeIcon, style: const TextStyle(fontSize: 12)),
                  const SizedBox(width: 4),
                  Text(
                    "$name: ",
                    style: TextStyle(color: textColor, fontSize: 13),
                  ),
                  Text(
                    "$price บาท",
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ] else
          Text(
            "ไม่พบรายการที่จะบันทึก",
            style: TextStyle(color: textColor, fontStyle: FontStyle.italic),
          ),
      ],
    );
  }

  Widget _buildUserImage(String path) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(image: FileImage(File(path)), fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildAiGraph(String imageUrl) {
    // Assuming the backend returns a relative path like /static/graphs/...
    final fullUrl = "http://10.0.2.2:8000$imageUrl";
    return Container(
      margin: const EdgeInsets.only(top: 8),
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          fullUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              const Center(child: Text("Could not load graph")),
        ),
      ),
    );
  }
}
