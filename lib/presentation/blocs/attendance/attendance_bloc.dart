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
    on<SubmitPermissionForm>(_onSubmitPermissionForm);
    on<SubmitDinasForm>(_onSubmitDinasForm);
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
      await attendanceRepository.autoRecordAttendanceOut(event.uid, event.date);

      String? permissionStatus = "none";
      bool checkedIn = await attendanceRepository.hasCheckedIn(event.uid, event.date);
      bool checkedOut = await attendanceRepository.hasCheckedOut(event.uid, event.date);
      bool hasPermission = await attendanceRepository.hasPermission(event.uid, event.date);
      bool hasDinas = await attendanceRepository.hasDinas(event.uid, event.date);
      if (hasPermission) {
        permissionStatus = await attendanceRepository.checkPermissionStatus(event.uid, event.date);
      }

      emit(AttendanceStatusChecked(checkedIn, checkedOut, hasPermission, hasDinas, permissionStatus!));
    } catch (e) {
      emit(AttendanceFailure(e.toString()));
    }
  }

  Future<void> _onSubmitPermissionForm(SubmitPermissionForm event, Emitter<AttendanceState> emit) async {
    emit(AttendanceLoading());
    try {
      await attendanceRepository.submitPermissionForm(event.uid, event.date, event.type, event.description, event.imagePath);
      emit(AttendanceSuccess());
    } catch (e) {
      emit(AttendanceFailure(e.toString()));
    }
  }

  Future<void> _onSubmitDinasForm(SubmitDinasForm event, Emitter<AttendanceState> emit) async {
    emit(AttendanceLoading());
    try {
      await attendanceRepository.submitDinasForm(event.uid, event.date, event.description, event.filePath);
      emit(AttendanceSuccess());
    } catch (e) {
      emit(AttendanceFailure(e.toString()));
    }
  }
}
