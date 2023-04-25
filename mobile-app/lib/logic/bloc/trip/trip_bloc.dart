import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:lisbon_travel/logic/repository/google_direction_repository.dart';
import 'package:lisbon_travel/logic/repository/transit_option_repository.dart';
import 'package:lisbon_travel/logic/service/location_service.dart';
import 'package:lisbon_travel/logic/service/settings_service.dart';
import 'package:lisbon_travel/models/responses/place_autocomplete_prediction.dart';
import 'package:lisbon_travel/models/responses/transit_option.dart';
import 'package:lisbon_travel/models/trip_routes_model.dart';
import 'package:lisbon_travel/screens/home/models/trip_date_type.dart';
import 'package:lisbon_travel/utils/extensions/index.dart';
import 'package:queue/queue.dart';

part 'trip_bloc.freezed.dart';

part 'trip_event.dart';

part 'trip_state.dart';

class TripBloc extends Bloc<TripEvent, TripState> {
  final GoogleDirectionRepository _directionRepository;
  final LocationService _locationService;
  final TransitOptionRepository _transitOptionRepository;
  final SettingsService _settings = GetIt.I<SettingsService>();
  final jobs = Queue();

  TripBloc({
    required GoogleDirectionRepository directionRepository,
    required LocationService locationService,
    required TransitOptionRepository transitOptionsRepository,
  })  : _directionRepository = directionRepository,
        _locationService = locationService,
        _transitOptionRepository = transitOptionsRepository,
        super(const TripState.initial()) {
    on<_ClearPoints>((event, emit) => _clearPoints(event, emit));
    on<_SetPoint>((event, emit) => _setPoint(event, emit));
    on<_StartTrip>((event, emit) => _startTrip(event, emit));
    on<_EndTrip>((event, emit) => _endTrip(event, emit));
    on<_NavigationNextStep>((event, emit) => _navigationNextStep(event, emit));
  }

  _clearPoints(_ClearPoints event, Emitter<TripState> emit) async {
    if (event.origin && event.destination) {
      emit(const TripState.initial());
    } else if (event.origin) {
      emit(state.maybeMap(
        pointUpdated: (state) => state.copyWith(origin: null),
        orElse: () => state,
      ));
    } else if (event.destination) {
      emit(state.maybeMap(
        pointUpdated: (state) => state.copyWith(destination: null),
        orElse: () => state,
      ));
    }
  }

  _setPoint(_SetPoint event, Emitter<TripState> emit) async {
    PlaceAutocompletePrediction? origin;
    PlaceAutocompletePrediction? destination;

    final cState = state;
    if (cState is _PointUpdated) {
      origin = event.origin ?? cState.origin;
      destination = event.destination ?? cState.destination;
    } else {
      origin = event.origin;
      destination = event.destination;
    }

    // only get the route when destination is specified
    if (destination != null) {
      TripRouteModel? routes;
      // avoid duplicate route request
      final isSameQuery = cState is _PointUpdated &&
          cState.origin == origin &&
          cState.destination == destination;
      final isRouteLoaded = isSameQuery && cState.routes != null;
      if (!isRouteLoaded) {
        // start sending request to get routes
        emit(const TripState.loading());
        routes = await _directionRepository.getAllModeRoutes(
          origin: origin,
          destination: destination,
          arrivalTime:
              event.tripDateType == TripDateType.arrive ? event.dateTime : null,
          departureTime:
              event.tripDateType == TripDateType.leave ? event.dateTime : null,
        );
      } else {
        routes = cState.routes;
      }

      // avoid duplicate accessibility request
      final isAccessibilityLoaded =
          isSameQuery && cState.routes?.transitOption != null;
      final shouldRequestAccessibility = _settings.options.showAccessibility ||
          _settings.options.filterBasedOnAccessibility;
      // check if settings is active
      if (!isAccessibilityLoaded &&
          shouldRequestAccessibility &&
          routes?.transitRoutes?.isNotEmpty == true) {
        emit(const TripState.loading());
        final stations = <String>{
          for (final subSet in routes!.transitRoutes!.map((e) => e.stations))
            ...subSet.map((e) => e.name)
        }.toList();
        debugPrint(stations.toString());

        if (stations.isNotEmpty) {
          final response = await _transitOptionRepository.getList(
            nameIn: stations,
            nameCaseInsensitive: true,
            take: 50,
          );
          if (response.isRight && response.right.data?.isNotEmpty == true) {
            routes = routes.copyWith(transitOption: response.right.data);
          }
        }
      }

      // emit the new state
      emit(TripState.pointUpdated(
        origin: origin,
        destination: destination,
        routes: routes,
      ));
    } else {
      emit(TripState.pointUpdated(origin: origin, destination: destination));
    }
  }

  _startTrip(_StartTrip event, Emitter<TripState> emit) async {
    _locationService.addListener(_locationCheck);

    List<TransitOption>? transitOption = event.transitOption;
    if (transitOption == null && state is _PointUpdated) {
      transitOption = (state as _PointUpdated).routes?.transitOption;
    }

    emit(
      TripState.navigation(
        route: event.route,
        travelMode: event.travelMode,
        transitOption: transitOption,
      ),
    );
  }

  _endTrip(_EndTrip event, Emitter<TripState> emit) async {
    _locationService.removeListener(_locationCheck);
    emit(const TripState.initial());
  }

  _navigationNextStep(
    _NavigationNextStep event,
    Emitter<TripState> emit,
  ) async {
    if (state is _Navigation) {
      final _Navigation navigation = state as _Navigation;
      final int nextStepIndex = navigation.currentStepIndex + 1;
      if (nextStepIndex < navigation.steps!.length) {
        emit(navigation.copyWith(currentStepIndex: nextStepIndex));
      }
    }
  }

  _locationCheck() async {
    if (state is! _Navigation) return;
    final cState = state as _Navigation;

    if (_locationService.position == null) return;
    if (cState.steps == null || cState.steps!.isEmpty) return;
    if (cState.currentStepIndex >= cState.steps!.length - 1) return;

    // check user location from [_currentPos - lastPos]
    for (int i = cState.currentStepIndex + 1; i < cState.steps!.length; i++) {
      final compareStep = cState.steps![i];
      if (compareStep.startLocation == null) continue;

      final distance = _locationService.position!.distanceToCoordinates(
        compareStep.startLocation!.latitude,
        compareStep.startLocation!.longitude,
      );

      // if it's closer that x meter, send update for navigation
      if (distance < 30) {
        add(const TripEvent.navigationNextStep());
        return; // stop
      }
    }
  }
}
