import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String picture;
  final String password;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.picture,
    this.password = '',
  });

  @override
  List<Object> get props => [id, name, email, phone, role, picture];

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      role: data['role'] ?? '',
      picture: data['photoURL'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'picture': picture,
    };
  }

  copyWith({required String name, required String email, required String phone}) {
    return UserModel(
      id: this.id,
      name: name,
      email: email,
      phone: phone,
      role: this.role,
      picture: this.picture,
    );
  }
}