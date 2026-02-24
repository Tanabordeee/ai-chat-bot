class RegisterState {
  final String username;
  final String password;
  final bool isLoading;
  final String? error;
  final bool isSuccess; // เพิ่มตรงนี้

  RegisterState({
    required this.username,
    required this.password,
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
  });

  RegisterState copyWith({
    String? username,
    String? password,
    bool? isLoading,
    String? error,
    bool? isSuccess,
  }) {
    return RegisterState(
      username: username ?? this.username,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
