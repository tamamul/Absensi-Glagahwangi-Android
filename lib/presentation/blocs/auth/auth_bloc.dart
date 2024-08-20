import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../../data/repository/auth_repository.dart';
import '../../../data/repository/user_repository.dart';
import '../../../domain/entity/user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  StreamSubscription<firebase_auth.User?>? _userSubscription;

  AuthBloc({required AuthRepository authRepository, required UserRepository userRepository})
      : _authRepository = authRepository,
        _userRepository = userRepository,
        super(const AuthState.loading()) {
    on<AuthLogin>(_onUserChanged);
    on<AuthLogout>(_onLogoutRequested);

    _userSubscription = _authRepository.user.listen(
          (firebaseUser) async {
        if (firebaseUser != null) {
          final user = await _userRepository.getUserData();
          add(AuthLogin(user));
        } else {
          add(const AuthLogin(UserEntity.empty));
        }
      },
    );
  }

  void _onUserChanged(AuthLogin event, Emitter<AuthState> emit) {
    emit(event.user.isNotEmpty
        ? AuthState.authenticated(event.user)
        : const AuthState.unauthenticated());
  }

  void _onLogoutRequested(AuthLogout event, Emitter<AuthState> emit) async {
    await _authRepository.logOut();
    emit(const AuthState.unauthenticated());
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}