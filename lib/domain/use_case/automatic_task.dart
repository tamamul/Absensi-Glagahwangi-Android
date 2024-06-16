import 'dart:async';
import 'package:absensi_glagahwangi/data/repository/attendance_repository.dart';
import 'package:absensi_glagahwangi/data/repository/event_repository.dart';
import 'package:absensi_glagahwangi/domain/entity/event.dart';

class AutomaticTask {
  final AttendanceRepository attendanceRepository;
  final EventRepository eventRepository;
  List<DateTime> eventDates = [];

  AutomaticTask(this.attendanceRepository, this.eventRepository) {
    _fetchEventDates();
  }

  Future<void> _fetchEventDates() async {
    try {
      List<EventEntity> events = await eventRepository.fetchEvents();
      eventDates = events.map((event) {
        return DateTime.parse(event.date);
      }).toList();
      print('Fetched event dates: $eventDates');
    } catch (e) {
      print('Error fetching event dates: $e');
    }
  }

  void scheduleAutomaticAttendanceCheck(String uid) {
    Timer.periodic(const Duration(hours: 1), (timer) async {
      DateTime now = DateTime.now();
      print("Checking for automatic attendance at $now...");
      print("Current event dates: $eventDates");

      // Check if today is Saturday (6) or Sunday (7)
      if (now.weekday == DateTime.saturday || now.weekday == DateTime.sunday) {
        print("Skipping automatic attendance check on weekends.");
        return;
      }

      // Check if today is an event date
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
    });
  }
}
