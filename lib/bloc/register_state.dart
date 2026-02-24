import 'dart:io';

class RegisterState {
  final String username;
  final String password;
  final String phone;
  final String email;
  final String image;
  final File? selectedImage;
  final bool isPickingImage;
  final bool isLoading;
  final String? error;
  final bool isSuccess; // เพิ่มตรงนี้

  RegisterState({
    required this.username,
    required this.password,
    required this.phone,
    required this.email,
    required this.image,
    this.selectedImage,
    this.isPickingImage = false,
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
  });

  RegisterState copyWith({
    String? username,
    String? password,
    String? phone,
    String? email,
    String? image,
    File? selectedImage,
    bool? isPickingImage,
    bool? isLoading,
    String? error,
    bool? isSuccess,
  }) {
    return RegisterState(
      username: username ?? this.username,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      image: image ?? this.image,
      selectedImage: selectedImage ?? this.selectedImage,
      isPickingImage: isPickingImage ?? this.isPickingImage,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
