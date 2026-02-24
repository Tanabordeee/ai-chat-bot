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

// event กดปุ่ม register
class RegisterSubmitted extends RegisterEvent {}
