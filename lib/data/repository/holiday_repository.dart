import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entity/holiday.dart';
import '../model/holiday_model.dart';

class HolidayRepository {
  final CollectionReference _eventsCollection = FirebaseFirestore.instance.collection('holidays');

  Future<List<Holiday>> getHolidays() async {
    try {
      QuerySnapshot querySnapshot = await _eventsCollection
          .orderBy('date', descending: true)
          .get();
      return querySnapshot.docs.map((doc) {
        return HolidayModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id).toEntity();
      }).toList();
    } catch (e) {
      throw Exception('Error fetching holidays: $e');
    }
  }
}
