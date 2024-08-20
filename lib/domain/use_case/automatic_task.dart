import 'dart:async';
import 'package:absensi_glagahwangi/data/repository/attendance_repository.dart';
import 'package:absensi_glagahwangi/data/repository/holiday_repository.dart';
import 'package:absensi_glagahwangi/data/repository/overtime_repository.dart';
import 'package:absensi_glagahwangi/domain/entity/holiday.dart';
import 'package:flutter/foundation.dart';

class AutomaticTask {
  final AttendanceRepository attendanceRepository;
  final HolidayRepository eventRepository;
  final OvertimeRepository overtimeRepository;
  List<DateTime> eventDates = [];

  AutomaticTask(this.attendanceRepository, this.eventRepository, this.overtimeRepository) {
    _fetchEventDates();
  }

  Future<void> _fetchEventDates() async {
    try {
      List<Holiday> events = await eventRepository.getHolidays();
      eventDates = events.map((event) {
        return DateTime.parse(event.date);
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching event dates: $e');
      }
    }
  }

  void scheduleAutomaticAttendanceCheck(String uid) {
    Timer.periodic(const Duration(hours: 1), (timer) async {
      DateTime now = DateTime.now();
      print("Checking for automatic attendance at $now...");
      print("Current event dates: $eventDates");

      if (now.weekday == DateTime.saturday || now.weekday == DateTime.sunday) {
        print("Skipping automatic attendance check on weekends.");
        return;
      }

      bool isEventDate = eventDates.any((date) =>
      date.year == now.year && date.month == now.month && date.day == now.day);

      if (isEventDate) {
        print("Skipping automatic attendance check on event date.");
        return;
      }

      if (now.hour >= 12 && now.minute >= 10) {
        print("Executing autoRecordAttendanceOut and autoMarkAbsent for UID: $uid");
        await attendanceRepository.autoRecordAttendanceOut(uid, now);
        await attendanceRepository.autoMarkAbsent(uid, now);
      }

      if(now.hour >= 18 && now.minute >= 10) {
        print("Executing autoRecordAttendanceOut and autoMarkAbsent for UID: $uid");
        await overtimeRepository.nullifyOvertime(uid, now);
    }
    });
  }
}
