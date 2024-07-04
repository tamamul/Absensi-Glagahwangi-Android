import 'package:equatable/equatable.dart';

import '../../domain/entity/holiday.dart';

class HolidayModel extends Equatable {
  final String id;
  final String name;
  final String date;

  const HolidayModel({required this.id, required this.name, required this.date});

  factory HolidayModel.fromFirestore(Map<String, dynamic> data, String documentId) {
    return HolidayModel(
      id: documentId,
      name: data['name'] ?? '',
      date: data['date'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'date': date,
    };
  }

  @override
  List<Object?> get props => [id, name, date];

  Holiday toEntity() {
    return Holiday(id: id, name: name, date: date);
  }

  HolidayModel copyWith({
    String? name,
    String? date,
  }) {
    return HolidayModel(
      id: id,
      name: name ?? this.name,
      date: date ?? this.date,
    );
  }
}
