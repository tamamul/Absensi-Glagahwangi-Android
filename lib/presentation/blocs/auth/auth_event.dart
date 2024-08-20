part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthLogin extends AuthEvent {
  final UserEntity user;

  const AuthLogin(this.user);

  @override
  List<Object> get props => [user];
}

class AuthLogout extends AuthEvent {
  const AuthLogout();
}