part of 'holiday_bloc.dart';

abstract class HolidayState extends Equatable {
  const HolidayState();

  @override
  List<Object> get props => [];
}

class HolidayInitial extends HolidayState {}

class HolidayLoading extends HolidayState {}

class HolidayLoaded extends HolidayState {
  final List<Holiday> holidays;

  const HolidayLoaded({required this.holidays});

  @override
  List<Object> get props => [holidays];
}

class HolidayError extends HolidayState {
  final String message;

  const HolidayError({required this.message});

  @override
  List<Object> get props => [message];
}