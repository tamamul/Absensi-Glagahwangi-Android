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
      // Upload image to Firebase Storage if available
      String? imageUrl;
      if (imageFile != null) {
        imageUrl = await _uploadImage(user.id, imageFile);
      }

      // Preprocess the user's name to generate keywords
      List<String> keywords = preprocessName(user.name);

      // Convert the user model to a map and add the keywords
      Map<String, dynamic> userMap = user.toMap();
      userMap['keywords'] = keywords;

      // Update picture URL if image was uploaded
      if (imageUrl != null) {
        userMap['photoURL'] = imageUrl;
      }

      // Update Firebase Auth user profile
      User firebaseUser = _auth.currentUser!;
      if (firebaseUser.uid != user.id) {
        throw Exception('User ID does not match the currently authenticated user.');
      }

      // await firebaseUser.verifyBeforeUpdateEmail(user.email);
      await firebaseUser.updatePhotoURL(imageUrl);
      await firebaseUser.updateDisplayName(user.name);

      // userMap['email'] = firebaseUser.email;

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
      print(snapshot);
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      throw e;
    }
  }

  Future<UserModel> getUser(String userId) async {
    try {
      // Ensure the user is authenticated
      User? firebaseUser = _auth.currentUser;
      if (firebaseUser == null) {
        throw Exception('No user currently authenticated. Please log in again.');
      }

      // Check if the authenticated user matches the requested user ID
      if (firebaseUser.uid != userId) {
        throw Exception('User ID does not match the currently authenticated user.');
      }
      String email = firebaseUser.email!;

      // Fetch user document from Firestore
      DocumentSnapshot doc = await _db.collection('users').doc(userId).get();
      if (!doc.exists) {
        throw Exception('User document not found.');
      }
      UserModel user = UserModel.fromFirestore(doc);

      // Check if the email in Firestore is different from Firebase Auth email
      if (user.email != email) {
        // Update the email in Firestore
        await _db.collection('users').doc(userId).update({
          'email': email,
        });

        // Update the user model with the new email
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
