import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../data/repository/attendance_repository.dart';

part 'attendance_data_event.dart';
part 'attendance_data_state.dart';

class AttendanceDataBloc extends Bloc<AttendanceDataEvent, AttendanceDataState> {
  final AttendanceRepository attendanceRepository;

  AttendanceDataBloc(this.attendanceRepository) : super(AttendanceDataInitial()) {
    on<FetchAttendanceForDate>(_onFetchAttendanceForDate);
    on<FetchAttendanceList>(_onFetchAttendanceList);
    on<FetchAttendanceForMonth>(_onFetchAttendanceForMonth);
  }

  Future<void> _onFetchAttendanceForDate(FetchAttendanceForDate event, Emitter<AttendanceDataState> emit) async {
    emit(AttendanceDataLoading());
    try {
      final attendanceData = await attendanceRepository.fetchAttendanceForDate(event.uid, event.date);
      emit(attendanceData != null ? AttendanceDataLoaded(attendanceData) : AttendanceDataEmpty());
    } catch (e) {
      emit(AttendanceDataFailure(e.toString()));
    }
  }

  Future<void> _onFetchAttendanceList(FetchAttendanceList event, Emitter<AttendanceDataState> emit) async {
    emit(AttendanceDataLoading());
    try {
      final attendanceList = await attendanceRepository.fetchAttendanceList(event.uid);
      emit(AttendanceListFetched(attendanceList));
    } catch (e) {
      emit(AttendanceDataFailure(e.toString()));
    }
  }

  Future<void> _onFetchAttendanceForMonth(FetchAttendanceForMonth event, Emitter<AttendanceDataState> emit) async {
    emit(AttendanceDataLoading());
    try {
      final attendanceList = await attendanceRepository.fetchAttendanceListForMonth(event.uid, event.month);
      emit(AttendanceListFetched(attendanceList));
    } catch (e) {
      emit(AttendanceDataFailure(e.toString()));
    }
  }
}
