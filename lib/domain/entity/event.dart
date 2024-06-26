import 'package:equatable/equatable.dart';

class EventEntity extends Equatable {
  final String id;
  final String name;
  final String date;

  const EventEntity({required this.id, required this.name, required this.date});

  @override
  List<Object?> get props => [id, name, date];
}