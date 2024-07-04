part of 'holiday_bloc.dart';

abstract class HolidayEvent extends Equatable {
  const HolidayEvent();

  @override
  List<Object> get props => [];
}

class FetchHoliday extends HolidayEvent {}