import 'dart:convert';

import 'package:ai_chat_bot/bloc/profile_bloc.dart';
import 'package:ai_chat_bot/bloc/profile_event.dart';
import 'package:ai_chat_bot/bloc/profile_state.dart';
import 'package:ai_chat_bot/home.dart';
import 'package:ai_chat_bot/login.dart';
import 'package:ai_chat_bot/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:typed_data'; // สำหรับ Uint8List

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 16.0), // ขยับลง 16 px
          child: GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Home()),
              );
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
              onPressed: () {
                // Already on profile, maybe refresh data?
                final state = context.read<ProfileBloc>().state;
                if (state is ProfileLoaded) {
                  context.read<ProfileBloc>().add(
                    LoadProfile(state.user.id.toString()),
                  );
                }
              },
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
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) async {
          if (state is ProfileRemove) {
            final authRepo = AuthRepository();
            await authRepo.logout();
            if (context.mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Profile deleted successfully")),
              );
            }
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            Uint8List? imagebytes; // nullable
            if (state.user.image != null && state.user.image!.isNotEmpty) {
              imagebytes = base64Decode(state.user.image!);
            }
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey),
                        color: Colors.grey[200], // background ถ้า image null
                      ),
                      child: imagebytes != null
                          ? ClipOval(
                              child: Image.memory(
                                imagebytes,
                                width: 250,
                                height: 250,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Center(child: Icon(Icons.person, size: 80)),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      state.user.username,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (state.user.email != null)
                      Text(
                        state.user.email!,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    const SizedBox(height: 20),
                    if (state.user.phone != null)
                      Text(
                        state.user.phone!,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(200, 50),
                      ),
                      onPressed: () {},
                      child: const Text("UPDATE PROFILE"),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[50],
                        foregroundColor: Colors.red,
                        minimumSize: const Size(200, 50),
                      ),
                      onPressed: () {
                        final currentState = context.read<ProfileBloc>().state;
                        print(
                          "Delete button pressed. Current state: $currentState",
                        );
                        if (currentState is ProfileLoaded) {
                          showDialog(
                            context: context,
                            builder: (dialogContext) => AlertDialog(
                              title: const Text("Confirm Delete"),
                              content: const Text(
                                "Are you sure you want to delete your profile?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(dialogContext).pop(),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    context.read<ProfileBloc>().add(
                                      RemoveUser(
                                        currentState.user.id.toString(),
                                      ),
                                    );
                                    Navigator.of(dialogContext).pop();
                                  },
                                  child: const Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      child: const Text("DELETE PROFILE"),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            );
          } else if (state is ProfileError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Logout'),
        ],
        onTap: (index) async {
          if (index == 0) {
            // กด Home
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Home()),
            );
          } else if (index == 1) {
            // กด Logout
            final authRepo = AuthRepository();
            await authRepo.logout();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Login()),
            );
          }
        },
      ),
    );
  }
}
