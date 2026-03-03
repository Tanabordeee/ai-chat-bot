import 'package:ai_chat_bot/bloc/profile_bloc.dart';
import 'package:ai_chat_bot/bloc/profile_event.dart';
import 'package:ai_chat_bot/bloc/transaction_bloc.dart';
import 'package:ai_chat_bot/bloc/transaction_event.dart';
import 'package:ai_chat_bot/chat.dart';
import 'package:ai_chat_bot/bank.dart';
import 'package:ai_chat_bot/analysis.dart';
import 'package:ai_chat_bot/history.dart';
import 'package:ai_chat_bot/profile.dart';
import 'package:ai_chat_bot/repository/auth_repository.dart';
import 'package:ai_chat_bot/bloc/account_bloc.dart';
import 'package:ai_chat_bot/bloc/account_event.dart';
import 'package:ai_chat_bot/repository/account_repository.dart';
import 'package:ai_chat_bot/repository/transaction_repository.dart';
import 'package:ai_chat_bot/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  Widget? _customBody;

  List<Widget> _widgetOptions = <Widget>[
    Chat(),
    BlocProvider(
      create: (context) =>
          TransactionBloc(TransactionRepository())
            ..add(const CalculateAllTransactions()),
      child: const Analysis(),
    ),
    BlocProvider(
      create: (context) =>
          TransactionBloc(TransactionRepository())
            ..add(const LoadTransactionsByUserId()),
      child: const History(),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _customBody = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 16.0), // ขยับลง 16 px
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = 0;
                _customBody = null;
              });
            },
            child: Image.asset(
              "assets/images/logo.png",
              width: 100,
              height: 100,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              constraints: const BoxConstraints(), // ลบขนาดจำกัด
              icon: Image.asset(
                "assets/images/profile.png",
                width: 50,
                height: 50,
              ),
              onPressed: () async {
                final authRepo = AuthRepository();
                final userInfo = await authRepo.getUserInfoFromToken();
                if (userInfo != null && userInfo['id'] != null) {
                  final userId = userInfo['id'].toString();
                  if (context.mounted) {
                    setState(() {
                      _customBody = BlocProvider(
                        create: (context) =>
                            ProfileBloc(UserRepository())
                              ..add(LoadProfile(userId)),
                        child: const Profile(),
                      );
                    });
                  }
                } else {
                  // Handle case where user info is not found (e.g., token expired)
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, "/");
                  }
                }
              },
            ),
          ),
        ],
        leading: Padding(
          padding: const EdgeInsets.only(left: 10), // ระยะซ้ายสุด
          child: IconButton(
            onPressed: () async {
              final authRepo = AuthRepository();
              final userInfo = await authRepo.getUserInfoFromToken();
              if (userInfo != null && userInfo['id'] != null) {
                if (context.mounted) {
                  setState(() {
                    _customBody = BlocProvider(
                      create: (context) =>
                          AccountBloc(AccountRepository())..add(LoadAccounts()),
                      child: const Bank(),
                    );
                  });
                }
              } else {
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, "/");
                }
              }
            },
            padding: EdgeInsets.zero, // ลบ padding ภายใน
            constraints: const BoxConstraints(), // ลบข้อจำกัด
            icon: Image.asset(
              "assets/images/bank.png",
              width: 50, // ขนาดเต็มตามต้องการ
              height: 50,
            ),
          ),
        ),
      ),
      body:
          _customBody ??
          Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'แชท',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            label: 'สรุป',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'ประวัติ'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: _customBody == null ? Colors.blue : Colors.grey,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
