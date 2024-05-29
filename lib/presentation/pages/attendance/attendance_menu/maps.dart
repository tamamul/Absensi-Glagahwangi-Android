import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../data/repository/map_repository.dart';
import '../../../blocs/maps/maps_bloc.dart';

class Maps extends StatelessWidget {
  const Maps({super.key});

  @override
  Widget build(BuildContext context) {
    final mapRepository = MapRepository();

    return BlocProvider(
      create: (_) => MapsBloc(mapRepository)..add(GetCurrentLocationEvent()),
      child: Scaffold(
        body: Stack(
          children: [
            BlocListener<MapsBloc, MapsState>(
              listener: (context, state) {
                print("current state: $state");
                if (state is MapsOutsideGeofence) {
                  final snackBar = SnackBar(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    behavior: SnackBarBehavior.floating,
                    elevation: 4,
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 4),
                    content: const Text(
                      'Diluar Lokasi Absen!',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Manrope",
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else if (state is MapsInsideGeofence) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                }
              },
              child: BlocBuilder<MapsBloc, MapsState>(
                builder: (context, state) {
                  if (state is MapsLoadInProgress) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is MapsOutsideGeofence) {
                    return builtInMaps(
                      context,
                      currentLocation: state.currentLocation,
                      markers: state.markers,
                      geofenceCircle: state.geofenceCircle,
                    );
                  } else if (state is MapsInsideGeofence) {
                    return builtInMaps(
                      context,
                      currentLocation: state.currentLocation,
                      markers: state.markers,
                      geofenceCircle: state.geofenceCircle,
                    );
                  } else {
                    return Center(child: Text('Please enable location services'));
                  }
                },
              ),
            ),
            Positioned(
              bottom: 50.0,
              left: 16.0,
              child: FloatingActionButton(
                onPressed: () => context.read<MapsBloc>().add(GetCurrentLocationEvent()),
                child: Icon(Icons.my_location),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget builtInMaps(BuildContext context, {required LatLng currentLocation, required Set<Marker> markers, required Circle geofenceCircle}) {
  return GoogleMap(
    mapType: MapType.normal,
    initialCameraPosition: CameraPosition(
      target: currentLocation,
      zoom: 25,
    ),
    markers: markers,
    circles: {geofenceCircle},
    onMapCreated: (GoogleMapController controller) {
      context.read<MapsBloc>().controller.complete(controller);
    },
  );
}