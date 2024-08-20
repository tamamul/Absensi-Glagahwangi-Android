import 'dart:async';
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repository/user_repository.dart';
import '../../../domain/entity/user.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;
  StreamSubscription<UserEntity>? _userSubscription;

  UserBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(const UserInitial()) {
    on<getUser>(_onGetUser);
    on<UpdateUser>(_onUpdateUser);
    on<UpdateUserImage>(_onUpdateUserImage);
    on<ChangePasswordEvent>(_onChangePassword);
    on<resetPasswordEvent>(_onResetPassword);
    on<ReloadUser>(_onReloadUser);

    _userSubscription = _userRepository.user.listen((user) {
      add(getUser(user.id));
    });

    _initializeUser();
  }

  void _initializeUser() async {
    final user = await _userRepository.getUserData();
    add(getUser(user.id));
  }

  Future<void> _onGetUser(getUser event, Emitter<UserState> emit) async {
    emit(const UserLoading());
    try {
      final user = await _userRepository.getUser(event.userId);
      emit(UserLoaded(user));
    } catch (e) {
      emit(const UserError('Failed to fetch user'));
    }
  }

  Future<void> _onReloadUser(ReloadUser event, Emitter<UserState> emit) async {
    try {
      final user = await _userRepository.getUserData();
      emit(UserLoaded(user));
    } catch (e) {
      emit(const UserError('Failed to reload user'));
    }
  }

  Future<void> _onUpdateUser(UpdateUser event, Emitter<UserState> emit) async {
    emit(UserUpdateLoading(state.user));
    try {
      await _userRepository.updateUser(event.user, event.imageFile);
      final updatedUser = await _userRepository.getUser(event.user.id);
      emit(UserUpdateSuccess(updatedUser));
    } catch (e) {
      emit(UserUpdateFailure('Failed to update user', state.user));
    }
  }

  void _onUpdateUserImage(UpdateUserImage event, Emitter<UserState> emit) {
    emit(UserLoaded(state.user, imageFile: event.imageFile));
  }

  Future<void> _onChangePassword(ChangePasswordEvent event, Emitter<UserState> emit) async {
    emit(UserUpdateLoading(state.user));
    try {
      await _userRepository.reauthenticateUser(event.email, event.oldPassword);
      await _userRepository.updatePassword(event.newPassword);
      final updatedUser = await _userRepository.getUser(state.user.id);
      emit(UserUpdateSuccess(updatedUser));
    } catch (e) {
      emit(UserUpdateFailure('Failed to change password: ${e.toString()}', state.user));
    }
  }

  Future<void> _onResetPassword(resetPasswordEvent event, Emitter<UserState> emit) async {
    emit(UserForgetPasswordLoading());
    try {
      await _userRepository.resetPassword(event.email);
      emit(UserForgetPasswordSuccess());
    } catch (e) {
      if (e is FirebaseAuthException && e.code == 'user-not-found') {
        emit(const UserForgetPasswordFailure('Email tidak terdaftar'));
      } else {
        print('Error resetting password: $e');
        emit(const UserForgetPasswordFailure('Failed to send reset password email'));
      }
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}

class ReloadUser extends UserEvent {
  const ReloadUser();
}