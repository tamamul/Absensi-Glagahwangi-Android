import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entity/user.dart';
import '../model/user_model.dart';

class AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  late final StreamController<UserEntity> _userController;

  AuthRepository({
    firebase_auth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })   : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance {
    _userController = StreamController<UserEntity>.broadcast(
      onListen: _onListen,
    );
  }

  UserEntity currentUser = UserEntity.empty;

  Stream<UserEntity> get user => _userController.stream;

  void _onListen() {
    _firebaseAuth.authStateChanges().listen((firebaseUser) async {
      final user = firebaseUser == null ? UserEntity.empty : await _getUserData(firebaseUser);
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

  Future<UserEntity> getUserData() async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) {
      return UserEntity.empty;
    } else {
      final user = await _getUserData(firebaseUser);
      _userController.add(user);
      return user;
    }
  }

  Future<UserEntity> _getUserData(firebase_auth.User firebaseUser) async {
    final userDoc = await _firestore.collection('users').doc(firebaseUser.uid).get();
    if (userDoc.exists) {
      final userModel = UserModel.fromFirestore(userDoc);
      return userModel.toEntity();
    } else {
      return UserEntity.empty;
    }
  }
}
