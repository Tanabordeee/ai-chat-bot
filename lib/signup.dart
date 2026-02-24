import 'package:ai_chat_bot/bloc/register_bloc.dart';
import 'package:ai_chat_bot/bloc/register_event.dart';
import 'package:ai_chat_bot/bloc/register_state.dart';
import 'package:ai_chat_bot/login.dart';
import 'package:ai_chat_bot/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterBloc(AuthRepository()),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.only(top: 20.0), // ขยับลง 16 px
            child: Image.asset(
              "assets/images/logo.png",
              width: 100,
              height: 100,
            ),
          ),
        ),
        body: BlocListener<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state.isSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const Login()),
              );
            }
          },
          child: BlocBuilder<RegisterBloc, RegisterState>(
            builder: (context, state) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () =>
                          context.read<RegisterBloc>().add(PickImage()),
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          shape: BoxShape.circle, // ทำให้กลม
                          border: Border.all(color: Colors.grey),
                        ),
                        child: state.selectedImage != null
                            ? ClipOval(
                                child: Image.file(
                                  state.selectedImage!,
                                  fit: BoxFit.cover,
                                  width: 150,
                                  height: 150,
                                ),
                              )
                            : const Center(child: Text("Tap to select image")),
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildInput(
                      label: "Username",
                      onChanged: (value) => context.read<RegisterBloc>().add(
                        UsernameChanged(value),
                      ),
                    ),

                    _buildInput(
                      label: "Password",
                      obscure: true,
                      onChanged: (value) => context.read<RegisterBloc>().add(
                        PasswordChanged(value),
                      ),
                    ),

                    _buildInput(
                      label: "Phone",
                      keyboardType: TextInputType.phone,
                      onChanged: (value) =>
                          context.read<RegisterBloc>().add(PhoneChanged(value)),
                    ),

                    _buildInput(
                      label: "Email",
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) =>
                          context.read<RegisterBloc>().add(EmailChanged(value)),
                    ),

                    const SizedBox(height: 20),

                    const SizedBox(height: 20),

                    if (state.isLoading)
                      const CircularProgressIndicator()
                    else
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF4CB6D),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            context.read<RegisterBloc>().add(
                              RegisterSubmitted(),
                            );
                          },
                          child: const Text(
                            "Sign up",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),

                    if (state.error != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        state.error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInput({
    required String label,
    required Function(String) onChanged,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          obscureText: obscure,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(15),
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
