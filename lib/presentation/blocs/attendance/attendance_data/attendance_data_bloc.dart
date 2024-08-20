import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../domain/entity/attendance.dart';
import '../../../../data/repository/attendance_repository.dart';

part 'attendance_data_event.dart';
part 'attendance_data_state.dart';

class AttendanceDataBloc extends Bloc<AttendanceDataEvent, AttendanceDataState> {
  final AttendanceRepository attendanceRepository;

  AttendanceDataBloc(this.attendanceRepository) : super(AttendanceDataInitial()) {
    on<GetAttendanceForDate>(_onFetchAttendanceForDate);
    on<GetAttendanceList>(_onFetchAttendanceList);
    on<GetAttendanceForMonth>(_onFetchAttendanceForMonth);
    on<ExportAttendanceToExcel>(_onExportAttendanceToExcel);
  }

  Future<void> _onFetchAttendanceForDate(GetAttendanceForDate event, Emitter<AttendanceDataState> emit) async {
    emit(AttendanceDataLoading());
    try {
      final attendanceData = await attendanceRepository.getAttendanceForDate(event.uid, event.date);
      emit(attendanceData != null ? AttendanceDataLoaded(attendanceData) : AttendanceDataEmpty());
    } catch (e) {
      emit(AttendanceDataFailure(e.toString()));
    }
  }

  Future<void> _onFetchAttendanceList(GetAttendanceList event, Emitter<AttendanceDataState> emit) async {
    emit(AttendanceDataLoading());
    try {
      final attendanceList = await attendanceRepository.getAttendanceList(event.uid);
      emit(AttendanceListFetched(attendanceList));
    } catch (e) {
      emit(AttendanceDataFailure(e.toString()));
    }
  }

  Future<void> _onFetchAttendanceForMonth(GetAttendanceForMonth event, Emitter<AttendanceDataState> emit) async {
    emit(AttendanceDataLoading());
    try {
      final attendanceList = await attendanceRepository.getAttendanceListForMonth(event.uid, event.month);
      emit(AttendanceListFetched(attendanceList));
    } catch (e) {
      emit(AttendanceDataFailure(e.toString()));
    }
  }

  Future<void> _onExportAttendanceToExcel(ExportAttendanceToExcel event, Emitter<AttendanceDataState> emit) async {
    emit(AttendanceExportLoading());
    try {
      await attendanceRepository.exportAttendanceToExcel(event.uid, event.outputPath);
      emit(AttendanceExportSuccess(event.outputPath));
      await _onFetchAttendanceForDate(GetAttendanceForDate(event.uid, event.date), emit);
    } catch (e) {
      emit(AttendanceExportFailure(e.toString()));
      await _onFetchAttendanceForDate(GetAttendanceForDate(event.uid, event.date), emit);
    }
  }
}

