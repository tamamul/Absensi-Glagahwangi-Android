part of'admin_bloc.dart';

class AdminEvent extends Equatable {
  const AdminEvent();

  @override
  List<Object?> get props => [];
}

class AuthSignupRequested extends AdminEvent {
  final String email;
  final String password;
  final String name;
  final String role;

  const AuthSignupRequested({
    required this.email,
    required this.password,
    required this.name,
    required this.role,
  });

  @override
  List<Object> get props => [email, password, name, role];
}