import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
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
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    await _speechToText.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          if (mounted) {
            setState(() => _isListening = false);
          }
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() => _isListening = false);
        }
      },
    );
    if (mounted) {
      setState(() {});
    }
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize(
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            if (mounted) {
              setState(() => _isListening = false);
            }
          }
        },
        onError: (error) {
          if (mounted) {
            setState(() => _isListening = false);
          }
        },
      );
      if (available) {
        setState(() => _isListening = true);
        
        String thLocaleId = 'th_TH';
        try {
          var locales = await _speechToText.locales();
          for (var loc in locales) {
            if (loc.localeId.toLowerCase().startsWith('th')) {
              thLocaleId = loc.localeId;
              break;
            }
          }
        } catch (e) {
          // Fallback if fetching locales fails
        }

        _speechToText.listen(
          onResult: (val) {
            if (mounted) {
              setState(() {
                _messageController.text = val.recognizedWords;
              });
            }
          },
          localeId: thLocaleId,
        );
      }
    } else {
      setState(() => _isListening = false);
      _speechToText.stop();
    }
  }

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
      child: Column(
        children: [
          _buildMinimalDropdown(),
          Expanded(child: _buildMessageList()),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMinimalDropdown() {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        if (state is AccountLoaded) {
          if (_selectedAccount == null && state.accounts.isNotEmpty) {
            _selectedAccount = state.accounts.first;
          }

          return Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(14),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Account>(
                isExpanded: true,
                value: _selectedAccount,
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
                items: state.accounts.map((account) {
                  return DropdownMenuItem<Account>(
                    value: account,
                    child: Text(account.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedAccount = value;
                  });
                },
              ),
            ),
          );
        }

        return const SizedBox(height: 70);
      },
    );
  }

  Widget _buildMessageList() {
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) => _scrollToBottom(),
      builder: (context, state) {
        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: state.messages.length + (state.isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == state.messages.length) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            return MessageBubble(message: state.messages[index]);
          },
        );
      },
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
              IconButton(
                icon: Icon(
                  _isListening ? Icons.mic : Icons.mic_none,
                  color: _isListening ? Colors.red : null,
                ),
                onPressed: _listen,
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
