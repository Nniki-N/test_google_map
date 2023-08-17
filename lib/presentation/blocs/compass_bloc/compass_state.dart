

import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class CompassState {
  final LatLng? markerLatLng;
  final double bearing;

  CompassState({
    this.markerLatLng,
    this.bearing = 0,
  });
}

class InitCompassState extends CompassState {
  InitCompassState() : super();
}

class CalculatedMarketState extends CompassState {
  CalculatedMarketState({
    required LatLng markerLatLng,
    required double bearing,
  }) : super(
          markerLatLng: markerLatLng,
          bearing: bearing,
        );
}

class ErrorInitCompassState extends CompassState {
  ErrorInitCompassState() : super();
}
