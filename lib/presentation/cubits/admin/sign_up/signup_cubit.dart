import 'package:absensi_glagahwangi/data/repository/admin_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'signup_state.dart';

class SignUpCubit extends Cubit<SignupState> {
  final AdminRepository _adminRepository;

  SignUpCubit(this._adminRepository) : super(SignupState.initial());

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
      await _adminRepository.signup(
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
