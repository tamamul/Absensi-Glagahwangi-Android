import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entity/user.dart';

class AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  late final StreamController<User> _userController;

  AuthRepository({
    firebase_auth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })   : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance {
    _userController = StreamController<User>.broadcast(
      onListen: _onListen,
    );
  }

  User currentUser = User.empty;

  Stream<User> get user => _userController.stream;

  void _onListen() {
    _firebaseAuth.authStateChanges().listen((firebaseUser) async {
      final user = firebaseUser == null ? User.empty : await firebaseUser.toUser(_firestore);
      currentUser = user;
      _userController.add(user);
    });
  }

  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<void> logOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }
}

extension FirebaseUserExtension on firebase_auth.User {
  Future<User> toUser(FirebaseFirestore firestore) async {
    final userDoc = await firestore.collection('users').doc(uid).get();
    if (userDoc.exists) {
      final userData = userDoc.data();
      return User(
        id: uid,
        email: email,
        displayName: userData?['name'] ?? '',
        phone: userData?['phone'] ?? '',
        picture: userData?['photoURL'] ?? '',
        role: userData?['role'] ?? '',
      );
    } else {
      throw Exception('User not found in Firestore');
    }
  }
}
