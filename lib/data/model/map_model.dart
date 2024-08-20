import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/entity/map.dart';

class MapModel {
  final String id;
  final double latitude;
  final double longitude;
  final double radius;

  MapModel({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.radius,
  });

  factory MapModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return MapModel(
      id: doc.id,
      latitude: double.parse(data['lat'] ?? '-7.6481967'),
      longitude: double.parse(data['long'] ?? '110.6633733'),
      radius: double.parse(data['radius'] ?? '100.0'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lat': latitude.toString(),
      'long': longitude.toString(),
      'radius': radius.toString(),
    };
  }

  MapEntity toEntity() {
    return MapEntity(
      id: id,
      geofenceCenter: LatLng(latitude, longitude),
      geofenceRadius: radius,
    );
  }
}
