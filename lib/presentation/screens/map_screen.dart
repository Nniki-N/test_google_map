import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test_google_map/common/navigation/main_navigation.dart';
import 'package:test_google_map/presentation/blocs/compass_bloc/compass_bloc.dart';
import 'package:test_google_map/presentation/blocs/compass_bloc/compass_event.dart';
import 'package:test_google_map/presentation/blocs/map_bloc/map_bloc.dart';
import 'package:test_google_map/presentation/blocs/map_bloc/map_event.dart';
import 'package:test_google_map/presentation/blocs/map_bloc/map_state.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MapBloc, MapState>(
        builder: (context, mapState) {
          if (mapState is! LoadedMapState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: mapState.initialLatLng,
                  zoom: 16,
                ),
                compassEnabled: false,
                zoomControlsEnabled: false,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                markers: mapState.markers,
                onTap: (latlng) {
                  final marker = Marker(
                    markerId: MarkerId(latlng.toString()),
                    position: latlng,
                    draggable: true,
                    onDrag: (latlng) {
                      // Calculates a new bearing.
                      context.read<CompassBloc>().add(
                            CalculateBearingCompassEvent(markerLatLng: latlng),
                          );
                    },
                  );

                  // Puts a marker on the map.
                  context.read<MapBloc>().add(
                        SelectMarkerMapEvent(marker: marker),
                      );

                  // Calculates a bearing.
                  context.read<CompassBloc>().add(
                        CalculateBearingCompassEvent(
                            markerLatLng: marker.position),
                      );
                },
              ),
              Positioned(
                top: 20,
                left: 15,
                child: FloatingActionButton(
                  heroTag: null,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  backgroundColor: Colors.green,
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                top: 20,
                right: 15,
                child: FloatingActionButton(
                  heroTag: null,
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      MainNavigationRouteNames.compassScreen,
                    );
                  },
                  backgroundColor: Colors.red,
                  child: const Icon(
                    Icons.compass_calibration,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
