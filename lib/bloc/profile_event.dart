// lib/bloc/profile/profile_event.dart
abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {
  final String id;
  LoadProfile(this.id);
}

class RemoveUser extends ProfileEvent {
  final String id;
  RemoveUser(this.id);
}

class UpdateProfile extends ProfileEvent {
  final String id;
  final String username;
  final String email;
  final String phone;
  UpdateProfile({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
  });
}
