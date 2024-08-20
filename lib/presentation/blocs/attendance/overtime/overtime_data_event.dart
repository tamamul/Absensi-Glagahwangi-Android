part of 'overtime_data_bloc.dart';

abstract class OvertimeDataEvent extends Equatable {
  const OvertimeDataEvent();

  @override
  List<Object> get props => [];
}

class GetOvertimeDurationForMonth extends OvertimeDataEvent {
  final String uid;
  final String month;

  const GetOvertimeDurationForMonth(this.uid, this.month);

  @override
  List<Object> get props => [uid, month];
}