import 'package:ai_chat_bot/bloc/login_bloc.dart';
import 'package:ai_chat_bot/home.dart';
import 'package:ai_chat_bot/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_chat_bot/bloc/login_event.dart';
import 'package:ai_chat_bot/bloc/login_state.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    /*
    create: (_) => LoginBloc(),  
    หมายความว่า
    ตอน widget ถูก build
    มันจะสร้าง LoginBloc 1 ตัว
    แล้วเก็บไว้ใน tree
    */
    return BlocProvider(
      // ← เปิด BlocProvider
      create: (_) => LoginBloc(AuthRepository()),
      child: Scaffold(
        // ← เปิด Scaffold
        body: Center(
          // ← เปิด Center
          child: BlocListener<LoginBloc, LoginState>(
            // ← เปิด BlocListener
            listener: (context, state) {
              if (state.isSuccess) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              }
            },
            child: BlocBuilder<LoginBloc, LoginState>(
              // ← เปิด BlocBuilder
              builder: (context, state) {
                return Column(
                  // ← เปิด Column หลัก
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                      width: 300,
                      height: 300,
                    ),
                    Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 350),
                        child: Column(
                          // ← Column สำหรับ form
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  decoration: InputDecoration(
                                    labelText: "Username",
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(10),
                                  ),
                                  onChanged: (value) {
                                    context.read<LoginBloc>().add(
                                      UsernameChanged(value),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(30),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  decoration: InputDecoration(
                                    labelText: "Password",
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(10),
                                  ),
                                  onChanged: (value) {
                                    context.read<LoginBloc>().add(
                                      PasswordChanged(value),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (state.isLoading)
                      CircularProgressIndicator()
                    else
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 300,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF4CB6D),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              context.read<LoginBloc>().add(LoginSubmitted());
                            },
                            child: Text(
                              "Log in",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    if (state.error != null)
                      Text(state.error!, style: TextStyle(color: Colors.red)),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Don't have an account? Sign up",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ], // ← ปิด children ของ Column หลัก
                ); // ← ปิด Column หลัก
              }, // ← ปิด builder ของ BlocBuilder
            ), // ← ปิด BlocBuilder
          ), // ← ปิด BlocListener
        ), // ← ปิด Center
      ), // ← ปิด Scaffold
    ); // ← ปิด BlocProvider
  }
}
