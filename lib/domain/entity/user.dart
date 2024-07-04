import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String picture;
  final String alamat;

  const UserEntity({
    required this.id,
    this.email = '',
    this.name = '',
    this.phone = '',
    this.role = '',
    this.picture = '',
    this.alamat = '',
  });

  static const empty = UserEntity(id: '');

  bool get isEmpty => this == UserEntity.empty;

  bool get isNotEmpty => this != UserEntity.empty;

  @override
  List<Object?> get props => [id, email, name, phone, role, picture, alamat];

  UserEntity copyWith({
    String? name,
    String? email,
    String? phone,
    String? role,
    String? picture,
    String? alamat,
  }) {
    return UserEntity(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      picture: picture ?? this.picture,
      alamat: alamat ?? this.alamat,
    );
  }
}
