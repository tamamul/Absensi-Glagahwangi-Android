import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapEntity {
  final String id;
  final LatLng geofenceCenter;
  final double geofenceRadius;

  MapEntity({
    required this.id,
    required this.geofenceCenter,
    required this.geofenceRadius,
  });

  MapEntity copyWith({
    String? id,
    LatLng? geofenceCenter,
    double? geofenceRadius,
  }) {
    return MapEntity(
      id: id ?? this.id,
      geofenceCenter: geofenceCenter ?? this.geofenceCenter,
      geofenceRadius: geofenceRadius ?? this.geofenceRadius,
    );
  }
}
