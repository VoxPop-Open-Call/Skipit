import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lisbon_travel/logic/service/route_creator.dart';
import 'package:lisbon_travel/models/map_route.dart';
import 'package:lisbon_travel/utils/extensions/index.dart';

part 'map_bloc.freezed.dart';

part 'map_event.dart';

part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(const MapState.loading()) {
    on<_SetController>((event, emit) {
      emit(MapState.loaded(controller: event.controller));
    });
    on<_SetLocation>((event, emit) async {
      state.mapOrNull(
        loaded: (value) async {
          await value.controller.animateCamera(CameraUpdate.newLatLngZoom(
            event.location,
            event.zoom ?? 16,
          ));
        },
      );
    });
    on<_ShowRoute>(_showRoute);
    on<_ClearRoute>(_clearRoute);
  }

  Future<void> _showRoute(_ShowRoute event, Emitter<MapState> emit) async {
    if (event.route.steps?.isNotEmpty == true) {
      final mapRoute = await GetIt.I<RouteCreator>()
          .createMapRouteFromSteps(event.route.steps!);
      emit(state.map(
        loaded: (state) => state.copyWith(mapRoute: mapRoute),
        loading: (state) => state,
      ));
    }
  }

  FutureOr<void> _clearRoute(_ClearRoute event, Emitter<MapState> emit) {
    emit(state.map(
      loaded: (state) => state.copyWith(mapRoute: null),
      loading: (state) => state,
    ));
  }
}
