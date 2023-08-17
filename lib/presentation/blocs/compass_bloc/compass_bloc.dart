import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_compass/flutter_compass.dart' hide CompassEvent;
import 'package:geolocator/geolocator.dart';
import 'package:test_google_map/domain/services/compass_service.dart';
import 'package:test_google_map/presentation/blocs/compass_bloc/compass_event.dart';
import 'package:test_google_map/presentation/blocs/compass_bloc/compass_state.dart';

class CompassBloc extends Bloc<CompassEvent, CompassState> {
  final CompassService _compassService = CompassService();
  late StreamSubscription _streamSubscription;

  CompassBloc() : super(InitCompassState()) {
    on<InitializeCompassEvent>(_init);
    on<CalculateBearingCompassEvent>(_calculateBearing);
  }

  Future<void> _init(
    InitializeCompassEvent event,
    Emitter<CompassState> emit,
  ) async {
    try {
      final flutterCompassStream = FlutterCompass.events?.asBroadcastStream();

      if (flutterCompassStream == null) return;

      await _listenStream(
        flutterCompassStream,
        onData: (compassEvent) async {
          if (state.markerLatLng == null) return;

          final currentPosition = await Geolocator.getCurrentPosition();

          double bearing = _compassService.calculateBearingBetweenTwoLocations(
            lat1: currentPosition.latitude,
            lng1: currentPosition.longitude,
            lat2: state.markerLatLng!.latitude,
            lng2: state.markerLatLng!.longitude,
          );

          final heading = compassEvent.heading ?? 0;

          bearing -= heading;

          emit(CalculatedMarketState(
            markerLatLng: state.markerLatLng!,
            bearing: bearing,
          ));
        },
        onError: (error, stackTrace) {
          log('error inside stream subscription');
          emit(InitCompassState());
        },
      );
    } catch (exceprion) {
      log('error during compass bloc initializing');
      emit(ErrorInitCompassState());
    }
  }

  Future<void> _listenStream<T>(
    Stream<T> stream, {
    required void Function(T data) onData,
    required void Function(Object error, StackTrace stackTrace) onError,
  }) {
    final completer = Completer<void>();

    _streamSubscription = stream.listen(
      onData,
      onDone: completer.complete,
      onError: onError,
      cancelOnError: false,
    );

    return completer.future.whenComplete(() {
      _streamSubscription.cancel();
    });
  }

  Future<void> _calculateBearing(
    CalculateBearingCompassEvent event,
    Emitter<CompassState> emit,
  ) async {
    try {
      final currentPosition = await Geolocator.getCurrentPosition();

      final compassEvent = await FlutterCompass.events?.first;

      double bearing = _compassService.calculateBearingBetweenTwoLocations(
        lat1: currentPosition.latitude,
        lng1: currentPosition.longitude,
        lat2: event.markerLatLng.latitude,
        lng2: event.markerLatLng.longitude,
      );

      final heading = compassEvent?.heading ?? 0;

      bearing -= heading;

      emit(CalculatedMarketState(
        markerLatLng: event.markerLatLng,
        bearing: bearing,
      ));
    } catch (exception) {
      emit(ErrorInitCompassState());
    }
  }

  @override
  Future<void> close() async {
    await _streamSubscription.cancel();
    super.close();
  }
}
