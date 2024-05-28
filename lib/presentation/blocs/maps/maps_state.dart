part of 'maps_bloc.dart';

abstract class MapsState extends Equatable {
  @override
  List<Object> get props => [];
}

class MapsInitial extends MapsState {}

class MapsLoadInProgress extends MapsState {}

class MapsLoadSuccess extends MapsState {}

class MapsInsideGeofence extends MapsState {
  final LatLng currentLocation;
  final String locationName;
  final Set<Marker> markers;
  final Circle geofenceCircle;

  MapsInsideGeofence({
    required this.currentLocation,
    required this.locationName,
    required this.markers,
    required this.geofenceCircle,
  });

  @override
  List<Object> get props => [currentLocation, locationName, markers, geofenceCircle];
}

class MapsOutsideGeofence extends MapsState {
  final LatLng currentLocation;
  final String locationName;
  final Set<Marker> markers;
  final Circle geofenceCircle;

  MapsOutsideGeofence({
    required this.currentLocation,
    required this.locationName,
    required this.markers,
    required this.geofenceCircle,
  });

  @override
  List<Object> get props => [currentLocation, locationName, markers, geofenceCircle];
}