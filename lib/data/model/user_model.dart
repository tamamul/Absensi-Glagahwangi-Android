import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entity/user.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String alamat;
  final String picture;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.alamat,
    required this.picture,
  });

  @override
  List<Object> get props => [id, name, email, phone, role, picture, alamat];

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      role: data['role'] ?? '',
      picture: data['photoURL'] ?? '',
      alamat: data['alamat'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'picture': picture,
      'alamat': alamat,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      phone: phone,
      role: role,
      picture: picture,
      alamat: alamat,
    );
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? role,
    String? picture,
    String? alamat,
  }) {
    return UserModel(
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
