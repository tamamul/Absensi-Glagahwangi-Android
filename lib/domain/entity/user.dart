import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String? id;
  final String? displayName;
  final String? email;
  final String? phone;
  final String? role;
  final String? picture;

  const User(
      {required this.id,
      this.email,
      this.displayName,
      this.phone,
      this.role,
      this.picture});

  static const empty = User(id: '');

  bool get isEmpty => this == User.empty;
  bool get isNotEmpty => this != User.empty;

  @override
  List<Object?> get props => [id, email, displayName, phone, role, picture];

  copyWith({required String displayName, required String email, required String phone}) {
    return User(
      id: this.id,
      displayName: displayName,
      email: email,
      phone: phone,
      role: this.role,
      picture: this.picture,
    );
  }
}
