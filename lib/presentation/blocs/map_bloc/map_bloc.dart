import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test_google_map/presentation/blocs/map_bloc/map_event.dart';
import 'package:test_google_map/presentation/blocs/map_bloc/map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(InitMapState()) {
    on<InitializeMapEvent>(_init);
    on<SelectMarkerMapEvent>(_selectMarker);
  }

  Future<void> _init(
    InitializeMapEvent event,
    Emitter<MapState> emit,
  ) async {
    try {
      emit(LoadingMapState());
      final currentPosition = await Geolocator.getCurrentPosition();

      final currentLatLng = LatLng(
        currentPosition.latitude,
        currentPosition.longitude,
      );

      emit(LoadedMapState(
        initialLatLng: currentLatLng,
        markers: {},
      ));
    } catch (exception) {
      log('error during map bloc initializing');
      emit(ErrorInitMapState());
    }
  }

  Future<void> _selectMarker(
    SelectMarkerMapEvent event,
    Emitter<MapState> emit,
  ) async {
    emit(LoadedMapState(
      initialLatLng: (state as LoadedMapState).initialLatLng,
      markers: {event.marker},
    ));
  }
}
