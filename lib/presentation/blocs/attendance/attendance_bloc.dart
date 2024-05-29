import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/repository/attendance_repository.dart';

part 'attendance_event.dart';
part 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final AttendanceRepository attendanceRepository;

  AttendanceBloc(this.attendanceRepository) : super(AttendanceInitial()) {
    on<RecordAttendanceIn>(_onRecordAttendanceIn);
    on<RecordAttendanceOut>(_onRecordAttendanceOut);
    on<CheckAttendanceStatus>(_onCheckAttendanceStatus);
    on<FetchAttendanceList>(_onFetchAttendanceList);
  }

  Future<void> _onRecordAttendanceIn(RecordAttendanceIn event, Emitter<AttendanceState> emit) async {
    emit(AttendanceLoading());
    try {
      await attendanceRepository.recordAttendanceIn(event.uid, event.date, event.location, event.imagePath);
      emit(AttendanceSuccess());
    } catch (e) {
      emit(AttendanceFailure(e.toString()));
    }
  }

  Future<void> _onRecordAttendanceOut(RecordAttendanceOut event, Emitter<AttendanceState> emit) async {
    emit(AttendanceLoading());
    try {
      await attendanceRepository.recordAttendanceOut(event.uid, event.date, event.location, event.imagePath);
      emit(AttendanceSuccess());
    } catch (e) {
      emit(AttendanceFailure(e.toString()));
    }
  }

  Future<void> _onCheckAttendanceStatus(CheckAttendanceStatus event, Emitter<AttendanceState> emit) async {
    emit(AttendanceLoading());
    try {
      bool checkedIn = await attendanceRepository.hasCheckedIn(event.uid, event.date);
      bool checkedOut = await attendanceRepository.hasCheckedOut(event.uid, event.date);
      emit(AttendanceStatusChecked(checkedIn, checkedOut));
    } catch (e) {
      emit(AttendanceFailure(e.toString()));
    }
  }

  Future<void> _onFetchAttendanceList(FetchAttendanceList event, Emitter<AttendanceState> emit) async {
    emit(AttendanceLoading());
    try {
      List<Map<String, dynamic>> attendanceList = await attendanceRepository.fetchAttendanceList(event.uid);
      emit(AttendanceListFetched(attendanceList));
    } catch (e) {
      emit(AttendanceFailure(e.toString()));
    }
  }
}
