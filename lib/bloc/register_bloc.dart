import 'package:ai_chat_bot/bloc/register_event.dart';
import 'package:ai_chat_bot/bloc/register_state.dart';
import 'package:ai_chat_bot/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// สร้าง bloc
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  // สร้าง authRepository เพื่อให้สามารถส่งค่าไปได้ทีละตัว ไม่ต้องแก้ทั้ง object
  final AuthRepository authRepository;
  RegisterBloc(this.authRepository)
    : super(RegisterState(username: "", password: "")) {
    // event เปลี่ยน username
    on<UsernameChanged>((event, emit) {
      emit(state.copyWith(username: event.username));
    });
    // event เปลี่ยน password
    on<PasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password));
    });
    // event กดปุ่ม register
    on<RegisterSubmitted>((event, emit) async {
      emit(state.copyWith(isLoading: true, error: null)); // เปิด loading
      try {
        await authRepository.register(state.username, state.password);
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
