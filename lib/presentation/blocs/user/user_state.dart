part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final UserEntity user;
  final File? imageFile;

  const UserLoaded(this.user, {this.imageFile});

  @override
  List<Object?> get props => [user, imageFile];
}

class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object?> get props => [message];
}

class UserUpdateInitial extends UserState {}

class UserUpdateLoading extends UserState {}

class UserUpdateSuccess extends UserState {}

class UserUpdateFailure extends UserState {
  final String error;

  const UserUpdateFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class UserForgetPasswordInitial extends UserState {}

class UserForgetPasswordLoading extends UserState {}

class UserForgetPasswordSuccess extends UserState {}

class UserForgetPasswordFailure extends UserState {
  final String error;

  const UserForgetPasswordFailure(this.error);

  @override
  List<Object?> get props => [error];
}
