import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../domain/entity/attendance.dart';
import '../model/attendance_model.dart';
import 'package:excel/excel.dart' as exc;
import "package:path/path.dart" as p;

import '../model/forget_attendance_model.dart';
import '../model/overtime_model.dart';

class AttendanceRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  String defaultImageUrl = 'http://picsum.photos/200/300';

  Future<String> _uploadImageAndGetUrl(String uid, String imagePath, String type) async {
    File file = File(imagePath);
    String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    Reference ref = _firebaseStorage.ref().child('attendance').child(uid).child(type).child(fileName);
    UploadTask uploadTask = ref.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  Future<String> _uploadFileAndGetUrl(String uid, String filePath, String type) async {
    File file = File(filePath);
    String fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.uri.pathSegments.last}';
    Reference ref = _firebaseStorage.ref().child('dinas').child(uid).child(fileName);
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

  Future<void> recordAttendanceIn(String uid, DateTime date, String location, String imagePath, [String? attendanceStatus]) async {
    String formattedDate = _formatDate(date);
    String documentId = '${uid}_$formattedDate';

    String imageUrl = await _uploadImageAndGetUrl(uid, imagePath, 'in');

    String status = date.hour < 9 ? 'Tepat Waktu' : 'Terlambat';

    Map<String, dynamic> inData = {
      'time': _formatTime(date),
      'location': location,
      'image': imageUrl,
      'in': true,
      'status': status,
    };

    AttendanceModel attendanceModel = AttendanceModel(
      id: documentId,
      uid: uid,
      date: formattedDate,
      inData: inData,
      outData: {},
      attendanceStatus: attendanceStatus ?? 'absen',
      description: 'Melakukan Absen Normal',
      timestamp: Timestamp.now(),
      status: "diterima",
    );

    await _firestore.collection('attendance').doc(documentId).set(attendanceModel.toMap(), SetOptions(merge: true));
  }

  Future<void> recordAttendanceOut(String uid, DateTime date, String location, String imagePath) async {
    String formattedDate = _formatDate(date);
    String documentId = '${uid}_$formattedDate';

    String imageUrl = await _uploadImageAndGetUrl(uid, imagePath, 'out');

    Map<String, dynamic> outData = {
      'time': _formatTime(date),
      'location': location,
      'status': "Pulang",
      'image': imageUrl,
      'out': true,
    };

    await _firestore.collection('attendance').doc(documentId).set({'out': outData}, SetOptions(merge: true));

    DocumentSnapshot snapshot = await _firestore.collection('attendance').doc(documentId).get();
    if (snapshot.exists && snapshot.data() != null) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      if (data['attendanceStatus'] == "lembur") {
        DateTime overtimeStart = DateTime(date.year, date.month, date.day, 11, 50);
        int durationHours = date.difference(overtimeStart).inHours;
        int duration = durationHours.abs();

        await _firestore.collection('attendance').doc(documentId).set({'out': {'status': "Pulang Lembur"}}, SetOptions(merge: true));

        OvertimeModel overtimeModel = OvertimeModel(
          id: documentId,
          uid: uid,
          date: formattedDate,
          status: "Lembur",
          finish: _formatTime(date),
          duration: duration,
        );

        await _firestore.collection('overtime').doc(documentId).set(overtimeModel.toMap(), SetOptions(merge: true));
      }
    }
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

  Future<List<AttendanceEntity>> getAttendanceList(String uid) async {
    QuerySnapshot snapshot = await _firestore.collection('attendance')
        .where('uid', isEqualTo: uid)
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      AttendanceModel model = AttendanceModel.fromFirestore(doc);
      return model.toEntity();
    }).toList();
  }

  Future<List<AttendanceEntity>> getAttendanceListForMonth(String uid, String month) async {
    String startDate = '$month-01';
    String endDate = '$month-31';

    QuerySnapshot snapshot = await _firestore.collection('attendance')
        .where('uid', isEqualTo: uid)
        .where('date', isGreaterThanOrEqualTo: startDate)
        .where('date', isLessThanOrEqualTo: endDate)
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      AttendanceModel model = AttendanceModel.fromFirestore(doc);
      return model.toEntity();
    }).toList();
  }

  Future<AttendanceEntity?> getAttendanceForDate(String uid, DateTime date) async {
    String formattedDate = _formatDate(date);
    String documentId = '${uid}_$formattedDate';
    DocumentSnapshot snapshot = await _firestore.collection('attendance').doc(documentId).get();

    if (snapshot.exists) {
      AttendanceModel model = AttendanceModel.fromFirestore(snapshot);
      return model.toEntity();
    }
    return null;
  }

  Future<void> exportAttendanceToExcel(String uid, String outputPath) async {
    List<AttendanceEntity> attendanceList = await getAttendanceList(uid);

    String userName = await getUserNameByUid(uid);

    var excel = exc.Excel.createExcel();

    var sheet = excel['Attendance'];
    var headerStyle = exc.CellStyle(
      backgroundColorHex: exc.ExcelColor.amber,
      fontColorHex: exc.ExcelColor.white,
      bold: true,
      horizontalAlign: exc.HorizontalAlign.Center,
      verticalAlign: exc.VerticalAlign.Center,
    );

    List<String> headers = [
      'Name',
      'Date',
      'Check-in Time',
      'Check-in Location',
      'Check-in Status',
      'Check-out Time',
      'Check-out Location',
      'Attendance Status',
    ];

    for (int i = 0; i < headers.length; i++) {
      var cell = sheet.cell(exc.CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
      cell.value = exc.TextCellValue(headers[i]);
      cell.cellStyle = headerStyle;
    }

    for (var attendance in attendanceList) {
      String date = attendance.date;
      Map<String, dynamic> inData = attendance.inData;
      Map<String, dynamic> outData = attendance.outData;
      String attendanceStatus = attendance.attendanceStatus;

      List<dynamic> row = [
        userName,
        date,
        inData['time'] ?? '',
        inData['location'] ?? '',
        inData['status'] ?? '',
        outData['time'] ?? '',
        outData['location'] ?? '',
        attendanceStatus,
      ];

      int currentRow = sheet.maxRows;

      for (int i = 0; i < row.length; i++) {
        var cell = sheet.cell(exc.CellIndex.indexByColumnRow(columnIndex: i, rowIndex: currentRow));
        cell.value =  exc.TextCellValue(row[i]);
        cell.cellStyle = exc.CellStyle(
          bottomBorder: exc.Border(
            borderStyle: exc.BorderStyle.Medium,
            borderColorHex: exc.ExcelColor.black,
          ),
          topBorder: exc.Border(
            borderStyle: exc.BorderStyle.Medium,
            borderColorHex: exc.ExcelColor.black,
          ),
          leftBorder: exc.Border(
            borderStyle: exc.BorderStyle.Medium,
            borderColorHex: exc.ExcelColor.black,
          ),
          rightBorder: exc.Border(
            borderStyle: exc.BorderStyle.Medium,
            borderColorHex: exc.ExcelColor.black,
          ),
        );
      }
    }

    var fileBytes = excel.save();
    File(p.join(outputPath, 'attendance.xlsx'))
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes!);
  }

  Future<String> getUserNameByUid(String uid) async {
    var userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (userDoc.exists) {
      var userData = userDoc.data();
      return userData?['name'] ?? 'Unknown User';
    }

    return 'Unknown User';
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
      AttendanceModel absentModel = AttendanceModel(
        id: documentId,
        uid: uid,
        date: formattedDate,
        inData: {
          'image': 'https://picsum.photos/200/300',
          'in': false,
          'location': '---',
          'status': 'ALFA',
          'time': '--:--:--',
        },
        outData: {
          'image': 'https://picsum.photos/200/300',
          'in': false,
          'location': '---',
          'status': 'ALFA',
          'time': '--:--:--',
        },
        attendanceStatus: 'alfa',
        description: 'Absen Otomatis',
        status: 'diterima',
        timestamp: Timestamp.now(),
      );

      await _firestore.collection('attendance').doc(documentId).set(absentModel.toMap());
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

  Future<bool> isHoliday(DateTime date) async{
    String formattedDate = _formatDate(date);
    DocumentSnapshot snapshot = await _firestore.collection('events').doc(formattedDate).get();
    if(snapshot.exists){
      return true;
    }
    return false;
  }

  Future<void> insertForgetAttendance(String uid, DateTime date, String filePath, String description) async {
    String formattedDate = _formatDate(date);
    String documentId = '${uid}_$formattedDate';

    String fileUrl = await _uploadFileAndGetUrl(uid, filePath, 'forgot_attendance');

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

    CollectionReference attendanceCollection = _firestore.collection('forgot_attendance');
    await attendanceCollection.doc(documentId).set(model.toMap());
  }
}
