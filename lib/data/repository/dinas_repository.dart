import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../model/dinas_model.dart';
class DinasRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<String> _uploadFileAndGetUrl(String uid, String filePath, String type) async {
    File file = File(filePath);
    String fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.uri.pathSegments.last}';
    Reference ref = _firebaseStorage.ref().child('dinas').child(uid).child(fileName);
    UploadTask uploadTask = ref.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  Future<void> insertDinasForm(String uid, DateTime date, String description, String filePath) async {
    String formattedDate = _formatDate(date);
    String documentId = '${uid}_$formattedDate';

    String fileUrl = await _uploadFileAndGetUrl(uid, filePath, 'dinas');

    DinasModel dinasData = DinasModel(
      id: documentId,
      uid: uid,
      description: description,
      date: formattedDate,
      type: "Izin Dinas",
      file: fileUrl,
      status: 'pending',
      checkedByAdmin: false,
      createdTimestamp: FieldValue.serverTimestamp() as Timestamp,
    );

    await _firestore.collection('dinas').doc(documentId).set(dinasData.toMap());
  }

  Future<bool> hasDinas(String uid, DateTime date) async {
    String formattedDate = _formatDate(date);
    String documentId = '${uid}_$formattedDate';
    DocumentSnapshot snapshot = await _firestore.collection('dinas').doc(documentId).get();
    return snapshot.exists;
  }

  Future<String?> checkDinasStatus(String uid, DateTime date) async {
    String formattedDate = _formatDate(date);
    String documentId = '${uid}_$formattedDate';
    DocumentSnapshot snapshot = await _firestore.collection('dinas').doc(documentId).get();

    if (snapshot.exists) {
      DinasModel dinasModel = DinasModel.fromFirestore(snapshot);
      return dinasModel.status;
    }
    return null;
  }
}
