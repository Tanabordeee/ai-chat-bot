import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ai_chat_bot/bloc/chat_bloc.dart';
import 'package:ai_chat_bot/bloc/chat_event.dart';
import 'package:ai_chat_bot/bloc/chat_state.dart';
import 'package:ai_chat_bot/bloc/account_bloc.dart';
import 'package:ai_chat_bot/bloc/account_event.dart';
import 'package:ai_chat_bot/bloc/account_state.dart';
import 'package:ai_chat_bot/repository/chat_repository.dart';
import 'package:ai_chat_bot/repository/account_repository.dart';
import 'package:ai_chat_bot/models/account.dart';
import 'package:ai_chat_bot/widgets/message_bubble.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  Account? _selectedAccount;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _pickImage(ImageSource source, ChatBloc chatBloc) async {
    if (_selectedAccount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณาเลือกบัญชีก่อนส่งรูป')),
      );
      return;
    }

    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      chatBloc.add(
        SendImage(
          accountId: _selectedAccount!.id as int,
          image: File(image.path),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              AccountBloc(AccountRepository())..add(LoadAccounts()),
        ),
        BlocProvider(
          create: (context) => ChatBloc(chatRepository: ChatRepository()),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: BlocBuilder<AccountBloc, AccountState>(
              builder: (context, state) {
                if (state is AccountLoaded) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: DropdownButtonFormField<Account>(
                      isExpanded: true,
                      value: _selectedAccount,
                      decoration: const InputDecoration(
                        labelText: "เลือกบัญชี",
                        border: InputBorder.none,
                      ),
                      items: state.accounts.map((account) {
                        return DropdownMenuItem<Account>(
                          value: account,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                account.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedAccount = newValue;
                        });
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocConsumer<ChatBloc, ChatState>(
                listener: (context, state) {
                  _scrollToBottom();
                },
                builder: (context, state) {
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount:
                        state.messages.length + (state.isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == state.messages.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      return MessageBubble(message: state.messages[index]);
                    },
                  );
                },
              ),
            ),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.camera_alt_outlined),
                onPressed: () =>
                    _pickImage(ImageSource.camera, context.read<ChatBloc>()),
              ),
              IconButton(
                icon: const Icon(Icons.photo_library_outlined),
                onPressed: () =>
                    _pickImage(ImageSource.gallery, context.read<ChatBloc>()),
              ),
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'พิมพ์ข้อความ...',
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.text, // รองรับตัวอักษรไทย
                  textInputAction: TextInputAction.send, // กด Enter เพื่อส่ง
                  autocorrect: true, // ช่วยให้พิมพ์ไทยง่ายขึ้น
                  enableSuggestions: true,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.blueAccent),
                onPressed: () {
                  final text = _messageController.text.trim();
                  if (text.isNotEmpty && _selectedAccount != null) {
                    context.read<ChatBloc>().add(
                      SendMessage(
                        accountId: _selectedAccount!.id as int,
                        text: text,
                      ),
                    );
                    _messageController.clear();
                  } else if (_selectedAccount == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('กรุณาเลือกบัญชีก่อนส่งข้อความ'),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
