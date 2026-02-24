class LoginState {
  final String username;
  final String password;
  final bool isLoading;
  final String? error;
  final bool isSuccess; // เพิ่มตรงนี้

  LoginState({
    required this.username,
    required this.password,
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
  });

  LoginState copyWith({
    String? username,
    String? password,
    bool? isLoading,
    String? error,
    bool? isSuccess,
  }) {
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
