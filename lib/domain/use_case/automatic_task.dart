import 'dart:async';

import 'package:absensi_glagahwangi/data/repository/attendance_repository.dart';

class AutomaticTask {
  final AttendanceRepository attendanceRepository;

  AutomaticTask(this.attendanceRepository);

  void scheduleAutomaticAttendanceCheck(String uid) {
    Timer.periodic(const Duration(seconds: 10), (timer) async {
      DateTime now = DateTime.now();
      print("is it called over and over again??");
      if (now.hour >= 12) {
        await attendanceRepository.autoRecordAttendanceOut(uid, now);
        await attendanceRepository.autoMarkAbsent(uid, now);
      }
    });
  }
}
