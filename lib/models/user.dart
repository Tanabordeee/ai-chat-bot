// lib/models/user.dart
class User {
  final int id;
  final String username;

  User({required this.id, required this.username});
  /*
  factory ใน Dart คือ constructor แบบพิเศษที่ สามารถสร้าง instance ใหม่หรือคืนค่า object ที่มีอยู่แล้วได้
  ในที่นี้มันใช้เพื่อ สร้าง User object จาก JSON (เช่น response จาก API)
  final jsonData = {'id': 1, 'username': 'yokky'};
  final user = User.fromJson(jsonData);
  print(user.username); // output: yokky
  */
  factory User.fromJson(Map<String, dynamic> json) {
    return User(id: json['id'], username: json['username']);
  }
  /*
  toJson() เป็น method ที่ใช้แปลง object User ให้กลับไปเป็น Map
  ซึ่งมีประโยชน์เวลาที่เราต้องการส่งข้อมูล User ไปยัง API ในรูปแบบ JSON
  */
  Map<String, dynamic> toJson() => {'id': id, 'username': username};
  /*
  Map<String, dynamic> คือ โครงสร้างของ JSON 
  ที่ key เป็น string และ value อาจเป็นอะไรก็ได้ (dynamic)
  json['id'] และ json['username'] คือการดึงค่าจาก JSON เพื่อสร้าง object User
  */
}
