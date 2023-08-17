import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class CompassEvent {
  CompassEvent();
}

class InitializeCompassEvent extends CompassEvent {
  InitializeCompassEvent();
}

class CalculateBearingCompassEvent extends CompassEvent {
  final LatLng markerLatLng;

  CalculateBearingCompassEvent({
    required this.markerLatLng,
  });
}
