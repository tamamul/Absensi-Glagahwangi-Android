import 'package:equatable/equatable.dart';

class Holiday extends Equatable {
  final String id;
  final String name;
  final String date;

  const Holiday({required this.id, required this.name, required this.date});

  @override
  List<Object?> get props => [id, name, date];

  Holiday copyWith({
    String? name,
    String? date,
  }) {
    return Holiday(
      id: id,
      name: name ?? this.name,
      date: date ?? this.date,
    );
  }
}
