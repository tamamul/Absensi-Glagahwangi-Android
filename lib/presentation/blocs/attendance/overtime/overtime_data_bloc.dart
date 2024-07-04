import 'package:absensi_glagahwangi/data/repository/overtime_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'overtime_data_event.dart';
part 'overtime_data_state.dart';

class OvertimeDataBloc extends Bloc<OvertimeDataEvent, OvertimeDataState> {
  final OvertimeRepository overtimeRepository;

  OvertimeDataBloc(this.overtimeRepository) : super(OvertimeDataInitial()) {
    on<FetchOvertimeDurationForMonth>(_onFetchOvertimeDurationForMonth);
  }

  Future<void> _onFetchOvertimeDurationForMonth(FetchOvertimeDurationForMonth event, Emitter<OvertimeDataState> emit) async {
    emit(OvertimeDataLoading());
    try {
      final duration = await overtimeRepository.getOvertimeDurationForMonth(event.uid, event.month);
      emit(OvertimeDurationFetched(duration));
    } catch (e) {
      emit(OvertimeDataFailure(e.toString()));
    }
  }
}