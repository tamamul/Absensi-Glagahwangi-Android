part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class getUser extends UserEvent {
  final String userId;

  const getUser(this.userId);

  @override
  List<Object> get props => [userId];
}

class UpdateUser extends UserEvent {
  final UserEntity user;
  final File? imageFile;

  const UpdateUser(this.user, {this.imageFile});

  @override
  List<Object> get props => [user, imageFile ?? ''];
}

class UpdateUserImage extends UserEvent {
  final File imageFile;

  const UpdateUserImage(this.imageFile);

  @override
  List<Object> get props => [imageFile];
}

class resetPasswordEvent extends UserEvent {
  final String email;

  const resetPasswordEvent(this.email);

  @override
  List<Object> get props => [email];
}

class ChangePasswordEvent extends UserEvent {
  final String email;
  final String oldPassword;
  final String newPassword;

  const ChangePasswordEvent(this.email, this.oldPassword, this.newPassword);

  @override
  List<Object> get props => [email, oldPassword, newPassword];
}