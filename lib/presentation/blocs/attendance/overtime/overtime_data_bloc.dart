import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../data/repository/attendance_repository.dart';

part 'overtime_data_event.dart';
part 'overtime_data_state.dart';

class OvertimeDataBloc extends Bloc<OvertimeDataEvent, OvertimeDataState> {
  final AttendanceRepository attendanceRepository;

  OvertimeDataBloc(this.attendanceRepository) : super(OvertimeDataInitial()) {
    on<FetchOvertimeDurationForMonth>(_onFetchOvertimeDurationForMonth);
  }

  Future<void> _onFetchOvertimeDurationForMonth(FetchOvertimeDurationForMonth event, Emitter<OvertimeDataState> emit) async {
    emit(OvertimeDataLoading());
    try {
      final duration = await attendanceRepository.fetchOvertimeDurationForMonth(event.uid, event.month);
      emit(OvertimeDurationFetched(duration));
    } catch (e) {
      emit(OvertimeDataFailure(e.toString()));
    }
  }
}