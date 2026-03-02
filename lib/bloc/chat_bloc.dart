import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_chat_bot/models/chat_message.dart';
import 'chat_event.dart';
import 'chat_state.dart';
import 'package:ai_chat_bot/repository/chat_repository.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;

  ChatBloc({required this.chatRepository}) : super(const ChatState()) {
    on<SendMessage>(_onSendMessage);
    on<SendImage>(_onSendImage);
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ChatState> emit,
  ) async {
    final userMessage = ChatMessage(
      text: event.text,
      sender: MessageSender.user,
      timestamp: DateTime.now(),
    );

    final updatedMessages = List<ChatMessage>.from(state.messages)
      ..add(userMessage);
    emit(state.copyWith(messages: updatedMessages, isLoading: true));

    try {
      final response = await chatRepository.sendChatMessage(
        event.accountId,
        event.text,
      );
      final aiMessage = ChatMessage(
        text: response.aiAnswer,
        sender: MessageSender.ai,
        timestamp: DateTime.now(),
        aiResponse: response,
      );
      final finalMessages = List<ChatMessage>.from(state.messages)
        ..add(aiMessage);
      emit(state.copyWith(messages: finalMessages, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onSendImage(SendImage event, Emitter<ChatState> emit) async {
    final userMessage = ChatMessage(
      imageUrl: event.image.path,
      sender: MessageSender.user,
      timestamp: DateTime.now(),
    );

    final updatedMessages = List<ChatMessage>.from(state.messages)
      ..add(userMessage);
    emit(state.copyWith(messages: updatedMessages, isLoading: true));

    try {
      final response = await chatRepository.sendOcrRequest(
        event.accountId,
        event.image,
      );
      final aiMessage = ChatMessage(
        text: response.aiAnswer,
        sender: MessageSender.ai,
        timestamp: DateTime.now(),
        aiResponse: response,
      );
      final finalMessages = List<ChatMessage>.from(state.messages)
        ..add(aiMessage);
      emit(state.copyWith(messages: finalMessages, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
