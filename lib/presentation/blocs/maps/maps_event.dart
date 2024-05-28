part of 'maps_bloc.dart';

abstract class MapsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetCurrentLocationEvent extends MapsEvent {}

class CheckGeofenceEvent extends MapsEvent {}