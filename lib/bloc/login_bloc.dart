import 'package:ai_chat_bot/bloc/login_event.dart';
import 'package:ai_chat_bot/bloc/login_state.dart';
import 'package:ai_chat_bot/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// สร้าง bloc
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  // สร้าง authRepository เพื่อให้สามารถส่งค่าไปได้ทีละตัว ไม่ต้องแก้ทั้ง object
  final AuthRepository authRepository;
  LoginBloc(this.authRepository)
    : super(LoginState(username: "", password: "")) {
    // event เปลี่ยน username
    on<UsernameChanged>((event, emit) {
      emit(state.copyWith(username: event.username));
    });
    // event เปลี่ยน password
    on<PasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password));
    });
    // event กดปุ่ม login
    on<LoginSubmitted>((event, emit) async {
      emit(state.copyWith(isLoading: true, error: null)); // เปิด loading
      try {
        final token = await authRepository.login(
          state.username,
          state.password,
        );
        emit(state.copyWith(isLoading: false, error: null));
        print("TOKEN : $token");
      } catch (e) {
        emit(
          state.copyWith(
            isLoading: false,
            error: "ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง",
          ),
        );
      }
    });
  }
}
