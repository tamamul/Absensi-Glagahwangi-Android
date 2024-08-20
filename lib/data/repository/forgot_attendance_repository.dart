import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../model/dinas_model.dart';
import '../model/forget_attendance_model.dart';
class ForgotAttendanceRepository {
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

  Future<void> recordForgetAttendance(
      String uid, DateTime date, String filePath, String description) async {
    String formattedDate = _formatDate(date);
    String documentId = '${uid}_$formattedDate';

    String fileUrl =
    await _uploadFileAndGetUrl(uid, filePath, 'forgot_attendance');

    ForgetAttendanceModel model = ForgetAttendanceModel(
      id: documentId,
      uid: uid,
      date: formattedDate,
      fileUrl: fileUrl,
      description: description,
      checkedByAdmin: false,
      status: 'pending',
      createdTimestamp: Timestamp.now(),
    );

    CollectionReference attendanceCollection =
    _firestore.collection('forgot_attendance');
    await attendanceCollection.doc(documentId).set(model.toMap());
  }
}
