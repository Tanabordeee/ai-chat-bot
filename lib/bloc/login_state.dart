// สร้าง state ตัวแปลขึ้นมาว่าจะมีอะไรบ้าง
class LoginState {
  final String username;
  final String password;
  final bool isLoading;
  final String? error;

  LoginState({
    required this.username,
    required this.password,
    this.isLoading = false,
    this.error,
  });
  // การใส่ copyWith เพื่อให้สามารถส่งค่าไปได้ทีละตัว ไม่ต้องแก้ทั้ง object
  LoginState copyWith({
    String? username,
    String? password,
    bool? isLoading,
    String? error,
  }) {
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
