import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:csv/csv.dart';

class AttendanceRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  String defaultImageUrl = 'http://picsum.photos/200/300';

  Future<void> recordAttendanceIn(String uid, DateTime date, String location, String imagePath, [String? attendanceStatus]) async {
    String formattedDate = _formatDate(date);
    String documentId = '${uid}_$formattedDate';

    // Upload image to Firebase Storage
    String imageUrl = await _uploadImageAndGetUrl(uid, imagePath, 'in');

    // Determine status
    String status = date.hour < 9 ? 'Tepat Waktu' : 'Terlambat';

    Map<String, dynamic> inData = {
      'time': _formatTime(date),
      'location': location,
      'image': imageUrl,
      'in': true,
      'status': status,
    };

    await _firestore.collection('attendance').doc(documentId).set({
      'id': documentId,
      'uid': uid,
      'date': formattedDate,
      'in': inData,
      'attendanceStatus': attendanceStatus ?? 'absen',
      'description': 'Melakukan Absen Normal',
      'timestamp': FieldValue.serverTimestamp(),
      'status': "diterima"
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
      'status': "Pulang",
      'image': imageUrl,
      'out': true,
    };


    await _firestore.collection('attendance').doc(documentId).set({
      'out': outData,
    }, SetOptions(merge: true));

    DocumentSnapshot snapshot = await _firestore.collection('attendance').doc(documentId).get();
    if (snapshot.exists && snapshot.data() != null) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      if (data['attendanceStatus'] == "lembur") {
        DateTime overtimeStart = DateTime(date.year, date.month, date.day, 11, 50);
        int durationHours = date.difference(overtimeStart).inHours;
        int duration = durationHours.abs();

        await _firestore.collection('attendance').doc(documentId).set({
          'out': {
            'status':"Pulang Lembur"
          },
        }, SetOptions(merge: true));

        Map<String, dynamic> overtimeData = {
          'id': documentId,
          'date': formattedDate,
          'uid': uid,
          'status': "Lembur",
          'finish': _formatTime(date),
          'duration': duration,
        };

        await _firestore.collection('overtime').doc(documentId).set(overtimeData, SetOptions(merge: true));
      }
    }
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
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}';
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

  Future<List<Map<String, dynamic>>> fetchAttendanceListForMonth(String uid, String month) async {
    String startDate = '$month-01';
    String endDate = '$month-31'; // Adjust this to handle month end correctly if necessary

    QuerySnapshot snapshot = await _firestore.collection('attendance')
        .where('uid', isEqualTo: uid)
        .where('date', isGreaterThanOrEqualTo: startDate)
        .where('date', isLessThanOrEqualTo: endDate)
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

    String imageUrl = await _uploadImageAndGetUrl(uid, imagePath, 'permissions');

    Map<String, dynamic> permissionData = {
      'id': documentId,
      'uid': uid,
      'description': description,
      'type': type,
      'status': 'pending',
      'date': formattedDate,
      'image': imageUrl,
      'checked_by_admin': false,
      'createdTimestamp': FieldValue.serverTimestamp(),
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

  Future<String?> checkDinasStatus(String uid, DateTime date) async {
    String formattedDate = _formatDate(date);
    String documentId = '${uid}_$formattedDate';
    DocumentSnapshot snapshot = await _firestore.collection('dinas').doc(documentId).get();

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
      'id': documentId,
      'uid': uid,
      'description': description,
      'date': formattedDate,
      'type': "Izin Dinas",
      'file': fileUrl,
      'status': 'pending',
      'checked_by_admin': false,
      'createdTimestamp': FieldValue.serverTimestamp(),
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

    if (currentDateTime.hour >= 12 && currentDateTime.minute >= 15 && snapshot.exists && status == "absen") {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      String location = data['in']['location'];
      if (!data.containsKey('out')) {
        Map<String, dynamic> outData = {
          'time': _formatTime(currentDateTime),
          'location': location,
          'image': 'https://picsum.photos/200/300',
          'out': true,
          'status': 'Absen Otomatis',
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

    if (currentDateTime.hour >= 12 && currentDateTime.minute >= 15 && !snapshot.exists) {
      Map<String, dynamic> absentData = {
        'id': documentId,
        'uid': uid,
        'date': formattedDate,
        'attendanceStatus': 'alfa',
        'description': 'Absen Otomatis',
        'status': 'diterima',
        'timestamp': FieldValue.serverTimestamp(),
        'in': {
          'image': 'https://picsum.photos/200/300',
          'in': false,
          'location': '---',
          'status': 'ALFA',
          'time': '--:--:--',
        },
        'out': {
          'image': 'https://picsum.photos/200/300',
          'in': false,
          'location': '---',
          'status': 'ALFA',
          'time': '--:--:--',
        },
      };

      await _firestore.collection('attendance').doc(documentId).set(absentData);
    }
  }

  Future<bool> isAlfa(String uid, DateTime date) async {
    String formattedDate = _formatDate(date);
    String documentId = '${uid}_$formattedDate';
    DocumentSnapshot snapshot = await _firestore.collection('attendance').doc(documentId).get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      return data['attendanceStatus'] == 'alfa';
    }
    return false;
  }

  Future<void> recordOvertime(String uid, DateTime date) async {
    String formattedDate = _formatDate(date);
    String documentId = '${uid}_$formattedDate';

    if (date.hour >= 11 && date.minute >= 50 && await hasCheckedIn(uid, date) && !await hasCheckedOut(uid,date)) {
      await _firestore.collection('attendance').doc(documentId).set({
        'out': {
          'status':"Pulang Lembur"
        },
        'attendanceStatus':'lembur',
        'description': 'Melakukan Lembur',
      }, SetOptions(merge: true));
    } else {
      throw Exception("Overtime caan only be recorded after 11:50 and if the user has checked in and haven't checkout.");
    }
  }

  Future<bool> hasOvertime(String uid, DateTime date) async {
    String formattedDate = _formatDate(date);
    String documentId = '${uid}_$formattedDate';
    DocumentSnapshot snapshot = await _firestore.collection('attendance').doc(documentId).get();

    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      return data['attendanceStatus'] == 'lembur';
    } else {
      return false;
    }
  }

  Future<void> forgetAttendance(String uid, DateTime date, String filePath, String description) async {
    String formattedDate = _formatDate(date);
    String documentId = '${uid}_$formattedDate';

    // Upload file to Firebase Storage with the new path and file name
    String fileUrl = await _uploadFileAndGetUrl(uid, filePath, 'forgot_attendance');

    // Save the data to Firestore
    CollectionReference attendanceCollection = FirebaseFirestore.instance.collection('forgot_attendance');
    await attendanceCollection.doc(documentId).set({
      'id': documentId,
      'uid': uid,
      'date': formattedDate,
      'file_url': fileUrl,
      'description': description,
      'checked_by_admin': false,
      'status': 'pending',
      'createdTimestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<int> fetchOvertimeDurationForMonth(String uid, String month) async {
    String startDate = '$month-01';
    String endDate = '$month-31';

    QuerySnapshot snapshot = await _firestore.collection('overtime')
        .where('uid', isEqualTo: uid)
        .where('date', isGreaterThanOrEqualTo: startDate)
        .where('date', isLessThanOrEqualTo: endDate)
        .orderBy('date', descending: true)
        .get();

    int totalDuration = snapshot.docs.fold(0, (sum, doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return sum + (data["duration"] ?? 0) as int;
    });

    return totalDuration;
  }
}
