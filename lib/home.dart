import 'package:ai_chat_bot/login.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 16.0), // ขยับลง 16 px
          child: Image.asset("assets/images/logo.png", width: 100, height: 100),
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
              onPressed: () {},
            ),
          ),
        ],
        leading: Padding(
          padding: const EdgeInsets.only(left: 10), // ระยะซ้ายสุด
          child: IconButton(
            onPressed: () {},
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
      body: Center(child: Text("HOME")),
    );
  }
}
