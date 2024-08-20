part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  final UserEntity user;
  final File? imageFile;

  const UserState({this.user = UserEntity.empty, this.imageFile});

  @override
  List<Object?> get props => [user, imageFile];
}

class UserInitial extends UserState {
  const UserInitial() : super();
}

class UserLoading extends UserState {
  const UserLoading() : super();
}

class UserLoaded extends UserState {
  const UserLoaded(UserEntity user, {File? imageFile}) : super(user: user, imageFile: imageFile);
}

class UserError extends UserState {
  final String message;

  const UserError(this.message) : super();

  @override
  List<Object?> get props => [message, user, imageFile];
}

class UserUpdateLoading extends UserState {
  const UserUpdateLoading(UserEntity user) : super(user: user);
}

class UserUpdateSuccess extends UserState {
  const UserUpdateSuccess(UserEntity user) : super(user: user);
}

class UserUpdateFailure extends UserState {
  final String error;

  const UserUpdateFailure(this.error, UserEntity user) : super(user: user);

  @override
  List<Object?> get props => [error, user, imageFile];
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