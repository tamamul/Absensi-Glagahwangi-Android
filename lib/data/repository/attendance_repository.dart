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

  // New function to fetch the list of attendance records for the current user
  Future<List<Map<String, dynamic>>> fetchAttendanceList(String uid) async {
    QuerySnapshot snapshot = await _firestore.collection('attendance')
        .where('uid', isEqualTo: uid)
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  // New function to fetch the attendance data for the current date
  Future<Map<String, dynamic>?> fetchAttendanceForDate(String uid, DateTime date) async {
    String formattedDate = _formatDate(date);
    String documentId = '${uid}_$formattedDate';
    DocumentSnapshot snapshot = await _firestore.collection('attendance').doc(documentId).get();

    if (snapshot.exists) {
      return snapshot.data() as Map<String, dynamic>?;
    }
    return null;
  }

  // Function to export attendance data to a CSV file
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
}
