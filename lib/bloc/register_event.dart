abstract class RegisterEvent {}

// สร้าง event ตัวแปรขึ้นมาว่าจะมีอะไรบ้าง
// เช่น event เปลี่ยน username
class UsernameChanged extends RegisterEvent {
  final String username;
  UsernameChanged(this.username);
}

// event เปลี่ยน password
class PasswordChanged extends RegisterEvent {
  final String password;
  PasswordChanged(this.password);
}

class PhoneChanged extends RegisterEvent {
  final String phone;
  PhoneChanged(this.phone);
}

class EmailChanged extends RegisterEvent {
  final String email;
  EmailChanged(this.email);
}

class ImageChanged extends RegisterEvent {
  final String image;
  ImageChanged(this.image);
}

class PickImage extends RegisterEvent {}

// event กดปุ่ม register
class RegisterSubmitted extends RegisterEvent {}
