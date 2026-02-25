import 'package:ai_chat_bot/repository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ai_chat_bot/bloc/profile_event.dart';
import 'package:ai_chat_bot/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository userRepository;
  ProfileBloc(this.userRepository) : super(ProfileInitial()) {
    on<LoadProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final user = await userRepository.getUserById(event.id);
        if (user != null) {
          emit(ProfileLoaded(user));
        } else {
          emit(ProfileError("User not found"));
        }
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });
    on<RemoveUser>((event, emit) async {
      try {
        final success = await userRepository.removeUser(event.id);
        if (success) {
          emit(ProfileRemove());
        } else {
          emit(ProfileError("Failed to remove user"));
        }
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });
  }
}
