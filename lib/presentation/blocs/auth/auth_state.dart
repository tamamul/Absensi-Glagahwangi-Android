part of 'auth_bloc.dart';

enum AuthStatus { authenticated, unauthenticated, loading }

class AuthState extends Equatable {
  final AuthStatus status;
  final UserEntity user;

  const AuthState._({
    this.status = AuthStatus.loading,
    this.user = UserEntity.empty,
  });

  const AuthState.authenticated(UserEntity user)
      : this._(status: AuthStatus.authenticated, user: user);

  const AuthState.unauthenticated() : this._(status: AuthStatus.unauthenticated);

  const AuthState.loading() : this._(status: AuthStatus.loading);

  @override
  List<Object?> get props => [status, user];
}