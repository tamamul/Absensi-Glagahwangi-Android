import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../data/repository/map_repository.dart';

part 'maps_event.dart';
part 'maps_state.dart';

class MapsBloc extends Bloc<MapsEvent, MapsState> {
  final MapRepository _mapRepository;
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  Completer<GoogleMapController> get controller => _controller;

  MapsBloc(this._mapRepository) : super(MapsInitial()) {
    on<GetCurrentLocationEvent>(_onGetCurrentLocationEvent);
  }

  Future<void> _onGetCurrentLocationEvent(GetCurrentLocationEvent event, Emitter<MapsState> emit) async {
    emit(MapsLoadInProgress());
    try {
      await _mapRepository.initializeGeofenceRadius();

      Position position = await _mapRepository.getCurrentLocation();
      LatLng currentLatLng = LatLng(position.latitude, position.longitude);
      String locationName = await _mapRepository.getLocationName(position);

      Set<Marker> markers = {
        _mapRepository.getCurrentLocationMarker(currentLatLng, locationName),
      };

      Circle geofenceCircle = _mapRepository.getGeofenceCircle();

      emit(MapsLoadSuccess());

      while (true) {
        if (state is MapsLoadSuccess) {
          Position position = await _mapRepository.getCurrentLocation();
          double distance = await _mapRepository.getDistanceFromGeofence(position);
          if (distance <= _mapRepository.geofenceRadius) {
            emit(MapsInsideGeofence(
              currentLocation: currentLatLng,
              locationName: locationName,
              markers: markers,
              geofenceCircle: geofenceCircle,
            ));
          } else {
            emit(MapsOutsideGeofence(
              currentLocation: currentLatLng,
              locationName: locationName,
              markers: markers,
              geofenceCircle: geofenceCircle,
            ));
          }
        }
        // ignore: prefer_const_constructors
        await Future.delayed(Duration(seconds: 5));
      }
    } catch (e) {
      emit(MapsInitial());
    }
  }
}