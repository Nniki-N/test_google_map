import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MapState {
  final Set<Marker> markers;
  MapState({this.markers = const {}});
}

class InitMapState extends MapState {
  InitMapState() : super();
}

class LoadingMapState extends MapState {
  LoadingMapState() : super();
}

class LoadedMapState extends MapState {
  final LatLng initialLatLng;

  LoadedMapState({
    required this.initialLatLng,
    required Set<Marker> markers,
  }) : super(markers: markers);
}

class ErrorInitMapState extends MapState {
  ErrorInitMapState() : super();
}
