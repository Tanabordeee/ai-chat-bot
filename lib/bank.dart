import 'package:ai_chat_bot/bloc/account_bloc.dart';
import 'package:ai_chat_bot/bloc/account_event.dart';
import 'package:ai_chat_bot/bloc/account_state.dart';
import 'package:ai_chat_bot/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Bank extends StatefulWidget {
  const Bank({super.key});

  @override
  State<Bank> createState() => _BankState();
}

class _BankState extends State<Bank> {
  bool _isAdding = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        if (state is AccountLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AccountError) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is AccountLoaded) {
          final accounts = state.accounts;
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 16),
                  itemCount: accounts.length + (_isAdding ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Add new account card at the bottom of the list
                    if (index == accounts.length) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.blueAccent,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 3,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  "บัญชี",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  "จำนวนเงินเริ่มต้น",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _nameController,
                                    decoration: const InputDecoration(
                                      hintText: 'ชื่อบัญชี',
                                      isDense: true,
                                      border: UnderlineInputBorder(),
                                    ),
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextField(
                                    controller: _balanceController,
                                    decoration: const InputDecoration(
                                      hintText: 'จำนวนเงิน',
                                      isDense: true,
                                      suffixText: 'บาท',
                                      border: UnderlineInputBorder(),
                                    ),
                                    style: const TextStyle(fontSize: 18),
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _isAdding = false;
                                      _nameController.clear();
                                      _balanceController.clear();
                                    });
                                  },
                                  child: const Text(
                                    'ยกเลิก',
                                    style: TextStyle(color: Colors.redAccent),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () async {
                                    final name = _nameController.text.trim();
                                    final balanceText = _balanceController.text
                                        .trim();
                                    if (name.isNotEmpty &&
                                        balanceText.isNotEmpty) {
                                      final balance = double.tryParse(
                                        balanceText,
                                      );
                                      if (balance != null) {
                                        final authRepo = AuthRepository();
                                        final userInfo = await authRepo
                                            .getUserInfoFromToken();
                                        final userId = userInfo?['id'];

                                        if (userId != null && context.mounted) {
                                          context.read<AccountBloc>().add(
                                            CreateAccount(
                                              name: name,
                                              balance: balance,
                                              user_id: userId,
                                            ),
                                          );
                                          setState(() {
                                            _isAdding = false;
                                            _nameController.clear();
                                            _balanceController.clear();
                                          });
                                        } else {
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'ไม่พบข้อมูลผู้ใช้งาน กรุณาเข้าสู่ระบบใหม่',
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'กรุณากรอกจำนวนเงินให้ถูกต้อง',
                                            ),
                                          ),
                                        );
                                      }
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'กรุณากรอกข้อมูลให้ครบถ้วน',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text('ส่ง'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }

                    // Existing account cards
                    final account = accounts[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: index == 0
                              ? const Color.fromARGB(255, 180, 180, 180)
                              : Colors.grey[400]!,
                          width: index == 0 ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 3,
                            blurRadius: 6,
                            offset: const Offset(0, 3), // Bottom shadow
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                "บัญชี",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                "จำนวนเงินคงเหลือ",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                account.name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${account.balance.toInt()} บาท",
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              if (!_isAdding)
                Padding(
                  padding: const EdgeInsets.only(right: 16.0, bottom: 16.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: FloatingActionButton(
                      onPressed: () {
                        setState(() {
                          _isAdding = true;
                        });
                      },
                      child: const Icon(Icons.add),
                    ),
                  ),
                ),
            ],
          );
        }

        // Return empty or initial state
        return const Center(child: Text('กำลังโหลดข้อมูลบัญชี...'));
      },
    );
  }
}
