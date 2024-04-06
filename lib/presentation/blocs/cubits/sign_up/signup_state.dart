part of 'signup_cubit.dart';

enum SignupStatus { initial, submitting, success, error }

class SignupState extends Equatable {
  final String name;
  final String role;
  final String email;
  final String password;
  final String confirmPassword;
  final SignupStatus status;

  const SignupState({
    required this.name,
    required this.role,
    required this.confirmPassword,
    required this.email,
    required this.password,
    required this.status,
  });

  factory SignupState.initial() {
    return const SignupState(
        email: '',
        password: '',
        status: SignupStatus.initial,
        name: '',
        role: '',
        confirmPassword: '');
  }

  SignupState copyWith({
    String? email,
    String? password,
    SignupStatus? status,
    String? name,
    String? role,
    String? confirmPassword,
  }) {
    return SignupState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      name: name ?? this.name,
      role: role ?? this.role,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }

  @override
  List<Object> get props => [email, password, status, name, role, confirmPassword];
}
