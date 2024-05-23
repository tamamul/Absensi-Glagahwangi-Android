import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class EventModel extends Equatable {
  final String id;
  final String name;
  final String date;

  EventModel({required this.id, required this.name, required this.date});

  factory EventModel.fromFirestore(Map<String, dynamic> data, String documentId) {
    return EventModel(
      id: documentId,
      name: data['name'] ?? '',
      date: data['date'],
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
}
