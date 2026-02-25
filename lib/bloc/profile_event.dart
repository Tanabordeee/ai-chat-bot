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
