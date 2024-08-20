import 'package:absensi_glagahwangi/data/repository/holiday_repository.dart';
import 'package:absensi_glagahwangi/domain/entity/holiday.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'holiday_event.dart';
part 'holiday_state.dart';

class HolidayBloc extends Bloc<HolidayEvent, HolidayState> {
  final HolidayRepository holidayRepository;

  HolidayBloc({required this.holidayRepository}) : super(HolidayInitial()) {
    on<getHoliday>(_onGetHolidays);
  }

  void _onGetHolidays(getHoliday holiday, Emitter<HolidayState> emit) async {
    emit(HolidayLoading());
    try {
      final holidays = await holidayRepository.getHolidays();
      emit(HolidayLoaded(holidays: holidays));
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      emit(HolidayError(message: e.toString()));
    }
  }
}
