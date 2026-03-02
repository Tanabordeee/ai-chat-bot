enum MessageSender { user, ai }

class ChatMessage {
  final String? text;
  final String? imageUrl;
  final MessageSender sender;
  final DateTime timestamp;
  final ChatResponse? aiResponse;

  ChatMessage({
    this.text,
    this.imageUrl,
    required this.sender,
    required this.timestamp,
    this.aiResponse,
  });
}

class ChatResponse {
  final String type;
  final String? aiAnswer;
  final bool? visualize;
  final String? graphType;
  final String? imageUrl;
  final List<dynamic>? items;
  final String? error;

  ChatResponse({
    required this.type,
    this.aiAnswer,
    this.visualize,
    this.graphType,
    this.imageUrl,
    this.items,
    this.error,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      type: json['type'] ?? 'error',
      aiAnswer: json['ai_answer'],
      visualize: json['visualize'],
      graphType: json['graph_type'],
      imageUrl: json['image_url'],
      items: json['items'],
      error: json['error'],
    );
  }
}
