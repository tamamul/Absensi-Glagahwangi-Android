import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? role;
  final String? picture;
  final String? alamat;
  final String? password;

  const User(
      {required this.id,
      this.email,
      this.name,
      this.phone,
      this.role,
      this.alamat,
      this.password,
      this.picture});

  static const empty = User(id: '');

  bool get isEmpty => this == User.empty;

  bool get isNotEmpty => this != User.empty;

  @override
  List<Object?> get props => [id, email, name, phone, role, picture, alamat, password];

  copyWith(
      {required String displayName,
      required String email,
      required String phone}) {
    return User(
      id: this.id,
      name: displayName,
      email: email,
      phone: phone,
      role: this.role,
      picture: this.picture,
      alamat: this.alamat,
      password: this.password,
    );
  }
}
