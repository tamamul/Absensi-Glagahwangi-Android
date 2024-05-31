import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:csv/csv.dart'; // Import the CSV package

class AttendanceRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<void> recordAttendanceIn(String uid, DateTime date, String location, String imagePath, [String? attendanceStatus]) async {
    String formattedDate = _formatDate(date);
    String documentId = '${uid}_$formattedDate';

    // Upload image to Firebase Storage
    String imageUrl = await _uploadImageAndGetUrl(uid, imagePath, 'in');

    // Determine status
    String status = date.hour < 8 ? 'Tepat Waktu' : 'Terlambat';

    Map<String, dynamic> inData = {
      'time': _formatTime(date),
      'location': location,
      'image': imageUrl,
      'in': true,
      'status': status,
    };

    await _firestore.collection('attendance').doc(documentId).set({
      'uid': uid,
      'date': formattedDate,
      'in': inData,
      'attendanceStatus': attendanceStatus ?? 'absen',
      'description': 'Normal Absent for today',
    }, SetOptions(merge: true));
  }

  Future<void> recordAttendanceOut(String uid, DateTime date, String location, String imagePath) async {
    String formattedDate = _formatDate(date);
    String documentId = '${uid}_$formattedDate';

    // Upload image to Firebase Storage
    String imageUrl = await _uploadImageAndGetUrl(uid, imagePath, 'out');

    Map<String, dynamic> outData = {
      'time': _formatTime(date),
      'location': location,
      'image': imageUrl,
      'out': true,
    };

    await _firestore.collection('attendance').doc(documentId).set({
      'out': outData,
    }, SetOptions(merge: true));
  }

  Future<String> _uploadImageAndGetUrl(String uid, String imagePath, String type) async {
    File file = File(imagePath);
    String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    Reference ref = _firebaseStorage.ref().child('attendance').child(uid).child(type).child(fileName);
    UploadTask uploadTask = ref.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour}:${date.minute}:${date.second}';
  }

  Future<bool> hasCheckedIn(String uid, DateTime date) async {
    String formattedDate = _formatDate(date);
    String documentId = '${uid}_$formattedDate';
    DocumentSnapshot snapshot = await _firestore.collection('attendance').doc(documentId).get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      return data.containsKey('in') && data['in']['in'] == true;
    }
    return false;
  }

  Future<bool> hasCheckedOut(String uid, DateTime date) async {
    String formattedDate = _formatDate(date);
    String documentId = '${uid}_$formattedDate';
    DocumentSnapshot snapshot = await _firestore.collection('attendance').doc(documentId).get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      return data.containsKey('out') && data['out']['out'] == true;
    }
    return false;
  }

  Future<bool> hasDinas(String uid, DateTime date) async {
    String formattedDate = _formatDate(date);
    String documentId = '${uid}_$formattedDate';
    DocumentSnapshot snapshot = await _firestore.collection('dinas').doc(documentId).get();
    return snapshot.exists;
  }

  Future<List<Map<String, dynamic>>> fetchAttendanceList(String uid) async {
    QuerySnapshot snapshot = await _firestore.collection('attendance')
        .where('uid', isEqualTo: uid)
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  Future<Map<String, dynamic>?> fetchAttendanceForDate(String uid, DateTime date) async {
    String formattedDate = _formatDate(date);
    String documentId = '${uid}_$formattedDate';
    DocumentSnapshot snapshot = await _firestore.collection('attendance').doc(documentId).get();

    if (snapshot.exists) {
      return snapshot.data() as Map<String, dynamic>?;
    }
    return null;
  }

  Future<void> exportAttendanceToCsv(String uid, String outputPath) async {
    List<Map<String, dynamic>> attendanceList = await fetchAttendanceList(uid);

    List<List<dynamic>> rows = [];
    rows.add([
      "UID",
      "Date",
      "Check-in Time",
      "Check-in Location",
      "Check-in Status",
      "Check-out Time",
      "Check-out Location",
      "Attendance Status",
    ]);

    for (var attendance in attendanceList) {
      String date = attendance['date'] ?? '';
      Map<String, dynamic> inData = attendance['in'] ?? {};
      Map<String, dynamic> outData = attendance['out'] ?? {};
      String attendanceStatus = attendance['attendanceStatus'] ?? 'absen';

      rows.add([
        uid,
        date,
        inData['time'] ?? '',
        inData['location'] ?? '',
        inData['status'] ?? '',
        outData['time'] ?? '',
        outData['location'] ?? '',
        attendanceStatus,
      ]);
    }

    String csvData = const ListToCsvConverter().convert(rows);

    File file = File(outputPath);
    await file.writeAsString(csvData);
  }

  Future<void> submitPermissionForm(String uid, DateTime date, String type, String description, String imagePath) async {
    String formattedDate = _formatDate(date);
    String documentId = '${uid}_$formattedDate';

    // Upload image to Firebase Storage with different path
    String imageUrl = await _uploadImageAndGetUrl(uid, imagePath, 'permissions');

    Map<String, dynamic> permissionData = {
      'uid': uid,
      'description': description,
      'type': type,
      'status': 'pending',
      'date': formattedDate,
      'image': imageUrl,
    };

    await _firestore.collection('permissions').doc(documentId).set(permissionData);
  }

  Future<bool> hasPermission(String uid, DateTime date) async {
    String formattedDate = _formatDate(date);
    String documentId = '${uid}_$formattedDate';
    DocumentSnapshot snapshot = await _firestore.collection('permissions').doc(documentId).get();
    return snapshot.exists;
  }

  Future<String?> checkPermissionStatus(String uid, DateTime date) async {
    String formattedDate = _formatDate(date);
    String documentId = '${uid}_$formattedDate';
    DocumentSnapshot snapshot = await _firestore.collection('permissions').doc(documentId).get();

    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      return data['status'] as String?;
    }
    return null;
  }

  Future<void> submitDinasForm(String uid, DateTime date, String description, String filePath) async {
    String formattedDate = _formatDate(date);
    String documentId = '${uid}_$formattedDate';

    // Upload file to Firebase Storage
    String fileUrl = await _uploadFileAndGetUrl(uid, filePath, 'dinas');

    Map<String, dynamic> dinasData = {
      'uid': uid,
      'description': description,
      'date': formattedDate,
      'file': fileUrl,
      'status': 'submitted',
    };

    await _firestore.collection('dinas').doc(documentId).set(dinasData);
  }

  Future<String> _uploadFileAndGetUrl(String uid, String filePath, String type) async {
    File file = File(filePath);
    String fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.uri.pathSegments.last}';
    Reference ref = _firebaseStorage.ref().child('dinas').child(uid).child(fileName);
    UploadTask uploadTask = ref.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  Future<void> autoRecordAttendanceOut(String uid, DateTime currentDateTime) async {
    String formattedDate = _formatDate(currentDateTime);
    String documentId = '${uid}_$formattedDate';
    DocumentSnapshot snapshot = await _firestore.collection('attendance').doc(documentId).get();
    String status = "";
    if(snapshot.exists){
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      status = data['attendanceStatus'];
    }

    if (currentDateTime.hour >= 12 && snapshot.exists && status == "absen") {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      String location = data['in']['location'];
      if (!data.containsKey('out')) {
        String imageUrl = 'Automatically Out';
        Map<String, dynamic> outData = {
          'time': _formatTime(currentDateTime),
          'location': location,
          'image': imageUrl,
          'out': true,
          'description': 'Marked as out automatically',
        };

        await _firestore.collection('attendance').doc(documentId).set({
          'out': outData,
        }, SetOptions(merge: true));
      }
    }
  }

  Future<void> autoMarkAbsent(String uid, DateTime currentDateTime) async {
    String formattedDate = _formatDate(currentDateTime);
    String documentId = '${uid}_$formattedDate';
    DocumentSnapshot snapshot = await _firestore.collection('attendance').doc(documentId).get();

    if (currentDateTime.hour >= 12 && !snapshot.exists) {
      Map<String, dynamic> absentData = {
        'uid': uid,
        'date': formattedDate,
        'attendanceStatus': 'alfa',
        'description': 'Marked as absent automatically',
      };

      await _firestore.collection('attendance').doc(documentId).set(absentData);
    }
  }
}
