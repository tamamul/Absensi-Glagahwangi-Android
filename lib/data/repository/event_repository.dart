
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entity/event.dart';
import '../model/event_model.dart';

class EventRepository {
  final CollectionReference _eventsCollection =
  FirebaseFirestore.instance.collection('events');

  Future<List<EventEntity>> fetchEvents() async {
    try {
      QuerySnapshot querySnapshot = await _eventsCollection.get();
      return querySnapshot.docs.map((doc) {
        return EventModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id).toEntity();
      }).toList();
    } catch (e) {
      throw Exception('Error fetching events: $e');
    }
  }
}

extension on EventModel {
  EventEntity toEntity() {
    return EventEntity(id: id, name: name, date: date);
  }
}