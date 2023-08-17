import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MapEvent {
  MapEvent();
}

class InitializeMapEvent extends MapEvent {
  InitializeMapEvent();
}

class SelectMarkerMapEvent extends MapEvent {
  final Marker marker;

  SelectMarkerMapEvent({
    required this.marker,
  });
}
