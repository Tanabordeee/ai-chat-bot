abstract class LoginEvent {}

// สร้าง event ตัวแปรขึ้นมาว่าจะมีอะไรบ้าง
// เช่น event เปลี่ยน username
class UsernameChanged extends LoginEvent {
  final String username;
  UsernameChanged(this.username);
}

// event เปลี่ยน password
class PasswordChanged extends LoginEvent {
  final String password;
  PasswordChanged(this.password);
}

// event กดปุ่ม login
class LoginSubmitted extends LoginEvent {}
