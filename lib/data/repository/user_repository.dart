import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/user_model.dart';

class UserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> updateUser(UserModel user, File? imageFile) async {
    try {
      String? imageUrl;
      if (imageFile != null) {
        imageUrl = await _uploadImage(user.id, imageFile);
      }

      List<String> keywords = preprocessName(user.name);

      Map<String, dynamic> userMap = user.toMap();
      userMap['keywords'] = keywords;

      if (imageUrl != null) {
        userMap['photoURL'] = imageUrl;
      }

      User firebaseUser = _auth.currentUser!;
      if (firebaseUser.uid != user.id) {
        throw Exception('User ID does not match the currently authenticated user.');
      }

      await firebaseUser.updatePhotoURL(imageUrl);
      await firebaseUser.updateDisplayName(user.name);

      await _db.collection('users').doc(user.id).update(userMap);
    } catch (e) {
      print('Error updating user: $e');
      throw e;
    }
  }

  Future<String> _uploadImage(String userId, File imageFile) async {
    try {
      Reference storageReference = _storage.ref().child('user_profiles/$userId');
      UploadTask uploadTask = storageReference.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      throw e;
    }
  }

  Future<UserModel> getUser(String userId) async {
    try {
      User? firebaseUser = _auth.currentUser;
      if (firebaseUser == null) {
        throw Exception('No user currently authenticated. Please log in again.');
      }

      if (firebaseUser.uid != userId) {
        throw Exception('User ID does not match the currently authenticated user.');
      }
      String email = firebaseUser.email!;

      DocumentSnapshot doc = await _db.collection('users').doc(userId).get();
      if (!doc.exists) {
        throw Exception('User document not found.');
      }
      UserModel user = UserModel.fromFirestore(doc);

      if (user.email != email) {
        await _db.collection('users').doc(userId).update({
          'email': email,
        });
        user = user.copyWith(email: email, name: user.name, phone: user.phone, alamat: user.alamat);
      }

      return user;
    } catch (e) {
      print('Error fetching user: $e');
      rethrow;
    }
  }

  Future<void> updatePassword(String newPassword) async {
    User? firebaseUser = _auth.currentUser;
    if (firebaseUser == null) {
      throw Exception('No user currently authenticated. Please log in again.');
    }

    await firebaseUser.updatePassword(newPassword);
  }

  Future<void> reauthenticateUser(String email, String password) async {
    User? firebaseUser = _auth.currentUser;
    if (firebaseUser == null) {
      throw Exception('No user currently authenticated. Please log in again.');
    }

    AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);
    await firebaseUser.reauthenticateWithCredential(credential);
  }


  List<String> preprocessName(String name) {
    return name.toLowerCase().split(" ");
  }

  Future<void> forgetPasswordEvent(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Error resetting password: $e');
      throw e;
    }
  }
}
