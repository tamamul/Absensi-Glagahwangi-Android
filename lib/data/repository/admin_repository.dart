import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class AdminRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AdminRepository({
    firebase_auth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> signup({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      final uid = credential.user!.uid;
      await _firestore.collection('users').doc(uid).set({
        'email': email,
        'phone': '',
        'picture': '',
        'name': name,
        'role': role,
      });
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }
}
