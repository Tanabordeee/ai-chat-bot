import 'dart:io';

abstract class ChatEvent {
  const ChatEvent();
}

class SendMessage extends ChatEvent {
  final int accountId;
  final String text;
  const SendMessage({required this.accountId, required this.text});
}

class SendImage extends ChatEvent {
  final int accountId;
  final File image;
  const SendImage({required this.accountId, required this.image});
}
