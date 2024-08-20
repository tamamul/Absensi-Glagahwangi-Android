import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../domain/entity/permission.dart';
import '../model/permission_model.dart';

class PermissionsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  String formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> recordPermission(String uid, DateTime date, String type, String description, String filePath) async {
    String formattedDate = formatDate(date);
    String documentId = '${uid}_$formattedDate';

    String fileUrl = await _uploadFileAndGetUrl(uid, filePath, 'permissions');

    PermissionsModel permissionData = PermissionsModel(
      id: documentId,
      uid: uid,
      description: description,
      type: type,
      status: 'pending',
      date: formattedDate,
      file: fileUrl,
      checkedByAdmin: false,
      createdTimestamp: FieldValue.serverTimestamp(),
    );

    await _firestore.collection('permissions').doc(documentId).set(permissionData.toMap());
  }

  Future<String> _uploadFileAndGetUrl(String uid, String filePath, String type) async {
    File file = File(filePath);
    String fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.uri.pathSegments.last}';
    Reference ref = _firebaseStorage.ref().child('dinas').child(uid).child(fileName);
    UploadTask uploadTask = ref.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  Future<bool> hasPermission(String uid, DateTime date) async {
    String formattedDate = formatDate(date);
    String documentId = '${uid}_$formattedDate';
    DocumentSnapshot snapshot = await _firestore.collection('permissions').doc(documentId).get();
    return snapshot.exists;
  }

  Future<String?> checkPermissionStatus(String uid, DateTime date) async {
    String formattedDate = formatDate(date);
    String documentId = '${uid}_$formattedDate';
    DocumentSnapshot snapshot = await _firestore.collection('permissions').doc(documentId).get();

    if (snapshot.exists) {
      PermissionsModel permissionModel = PermissionsModel.fromFirestore(snapshot);
      return permissionModel.status;
    }
    return null;
  }

  Future<Permissions?> getPermission(String uid, DateTime date) async {
    String formattedDate = formatDate(date);
    String documentId = '${uid}_$formattedDate';
    DocumentSnapshot snapshot = await _firestore.collection('permissions').doc(documentId).get();

    if (snapshot.exists) {
      PermissionsModel permissionModel = PermissionsModel.fromFirestore(snapshot);
      return Permissions.fromModel(permissionModel);
    }
    return null;
  }
}
