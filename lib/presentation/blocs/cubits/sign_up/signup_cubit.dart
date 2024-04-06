import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/repository/auth_repository.dart';

part 'signup_state.dart';

class SignUpCubit extends Cubit<SignupState> {
  final AuthRepository _authRepository;

  SignUpCubit(this._authRepository) : super(SignupState.initial());

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: SignupStatus.initial));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, status: SignupStatus.initial));
  }

  void confirmPasswordChanged(String value) {
    emit(state.copyWith(confirmPassword: value, status: SignupStatus.initial));
  }

  void nameChanged(String value) {
    emit(state.copyWith(name: value, status: SignupStatus.initial));
  }

  void roleChanged(String value) {
    emit(state.copyWith(role: value, status: SignupStatus.initial));
  }

  Future<void> signupFormSubmitted() async {
    if (state.status == SignupStatus.submitting) return;
    emit(state.copyWith(status: SignupStatus.submitting));
    try {
      await _authRepository.signup(
          email: state.email,
          password: state.password,
          name: state.name,
          role: state.role);
      emit(state.copyWith(status: SignupStatus.success));
    } on Exception {
      emit(state.copyWith(status: SignupStatus.error));
    }
  }
}
