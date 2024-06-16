part of 'overtime_data_bloc.dart';

abstract class OvertimeDataState extends Equatable {
  const OvertimeDataState();

  @override
  List<Object> get props => [];
}

class OvertimeDataInitial extends OvertimeDataState {}

class OvertimeDataLoading extends OvertimeDataState {}

class OvertimeDurationFetched extends OvertimeDataState {
  final int duration;

  const OvertimeDurationFetched(this.duration);

  @override
  List<Object> get props => [duration];
}

class OvertimeDataFailure extends OvertimeDataState {
  final String error;

  const OvertimeDataFailure(this.error);

  @override
  List<Object> get props => [error];
}