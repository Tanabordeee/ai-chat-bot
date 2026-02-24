import 'dart:convert';
import 'dart:io';

import 'package:ai_chat_bot/bloc/register_event.dart';
import 'package:ai_chat_bot/bloc/register_state.dart';
import 'package:ai_chat_bot/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// สร้าง bloc
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  // สร้าง authRepository เพื่อให้สามารถส่งค่าไปได้ทีละตัว ไม่ต้องแก้ทั้ง object
  final AuthRepository authRepository;
  RegisterBloc(this.authRepository)
    : super(
        RegisterState(
          username: "",
          password: "",
          phone: "",
          email: "",
          image: "",
        ),
      ) {
    // event เปลี่ยน username
    on<UsernameChanged>((event, emit) {
      emit(state.copyWith(username: event.username));
    });
    // event เปลี่ยน password
    on<PasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password));
    });
    // event เปลี่ยน phone
    on<PhoneChanged>((event, emit) {
      emit(state.copyWith(phone: event.phone));
    });
    // event เปลี่ยน email
    on<EmailChanged>((event, emit) {
      emit(state.copyWith(email: event.email));
    });
    // event เปลี่ยน image
    on<ImageChanged>((event, emit) {
      emit(state.copyWith(image: event.image));
    });

    on<PickImage>((event, emit) async {
      if (state.isPickingImage) return;

      emit(state.copyWith(isPickingImage: true));

      try {
        final File? imageFile = await authRepository.pickImage();
        if (imageFile != null) {
          final bytes = await imageFile.readAsBytes();
          final base64Image = base64Encode(bytes);
          emit(
            state.copyWith(
              selectedImage: imageFile,
              image: base64Image,
              isPickingImage: false,
            ),
          );
        } else {
          emit(state.copyWith(isPickingImage: false));
        }
      } catch (e) {
        emit(state.copyWith(isPickingImage: false, error: e.toString()));
      }
    });

    // event กดปุ่ม register
    on<RegisterSubmitted>((event, emit) async {
      emit(state.copyWith(isLoading: true, error: null)); // เปิด loading
      try {
        await authRepository.register(
          state.username,
          state.password,
          state.phone,
          state.email,
          state.image,
        );
        emit(state.copyWith(isLoading: false, isSuccess: true));
      } catch (e) {
        emit(
          state.copyWith(
            isLoading: false,
            error: e.toString(),
            isSuccess: false,
          ),
        );
      }
    });
  }
}
