import 'dart:ui';

import 'package:flutter_polyline_points/flutter_polyline_points.dart' as poly;
import 'package:google_directions_api/google_directions_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lisbon_travel/constants/colors.dart';
import 'package:lisbon_travel/generated/assets.gen.dart';
import 'package:lisbon_travel/models/map_route.dart';
import 'package:lisbon_travel/utils/extensions/index.dart';
import 'package:lisbon_travel/utils/utils.dart';
import 'package:uuid/v4.dart';

class RouteCreator {
  final ployLinePoints = poly.PolylinePoints();

  late BitmapDescriptor _startLocationPin;
  late BitmapDescriptor _endLocationPin;
  late BitmapDescriptor _walkingPin;
  late BitmapDescriptor _bikePin;
  late BitmapDescriptor _busPin;
  late BitmapDescriptor _subwayPin;
  late BitmapDescriptor _trainPin;
  late BitmapDescriptor _boatPin;

  RouteCreator() {
    _initialize();
  }

  Future<void> _initialize() async {
    const startEndIconsSize = 65;
    const otherIconsSize = 70;

    _startLocationPin = BitmapDescriptor.fromBytes(await getBytesFromAsset(
      Assets.mapIcons.startMarker.path,
      startEndIconsSize,
    ));
    _endLocationPin = BitmapDescriptor.fromBytes(await getBytesFromAsset(
      Assets.mapIcons.endMarker.path,
      startEndIconsSize,
    ));

    _walkingPin = BitmapDescriptor.fromBytes(await getBytesFromAsset(
      Assets.mapIcons.walkIcon.path,
      otherIconsSize,
    ));
    _bikePin = BitmapDescriptor.fromBytes(await getBytesFromAsset(
      Assets.mapIcons.bikeIcon.path,
      otherIconsSize,
    ));
    _busPin = BitmapDescriptor.fromBytes(await getBytesFromAsset(
      Assets.mapIcons.busIcon.path,
      otherIconsSize,
    ));
    _subwayPin = BitmapDescriptor.fromBytes(await getBytesFromAsset(
      Assets.mapIcons.subwayIcon.path,
      otherIconsSize,
    ));
    _trainPin = BitmapDescriptor.fromBytes(await getBytesFromAsset(
      Assets.mapIcons.train.path,
      otherIconsSize,
    ));
    _boatPin = BitmapDescriptor.fromBytes(await getBytesFromAsset(
      Assets.mapIcons.boatIcon.path,
      otherIconsSize,
    ));
  }

  Future<MapRoute> createMapRouteFromSteps(List<DirectionsStep> gSteps) async {
    List<String> steps = [];
    List<String> stepDurations = [];
    Set<Marker> markers = {};
    Set<Polyline> polyLines = {};

    for (var i = 0; i < gSteps.length; i++) {
      BitmapDescriptor? firstPin;
      BitmapDescriptor? lastPin;

      final step = gSteps[i];

      TravelMode? previousTravelMode;
      if (gSteps.length == 1) {
        firstPin = _startLocationPin;
        lastPin = _endLocationPin;
      } else {
        if (i == 0) {
          // adding the start pin for beginning of the route
          firstPin = _startLocationPin;
        } else if (i == gSteps.length - 1) {
          if (step.travelMode == TravelMode.walking ||
              step.travelMode == TravelMode.bicycling) {
            // avoid duplicating walking/bicycling icon
            if (step.travelMode != previousTravelMode) {
              firstPin = _getIconBasedOnTravelMode(step.travelMode);
            }
          } else {
            firstPin = _getIconBasedOnTravelMode(
              step.travelMode,
              vehicleType: step.transit?.line?.vehicle?.type,
            );
          }

          lastPin = _endLocationPin;
        } else {
          if (step.travelMode == TravelMode.walking ||
              step.travelMode == TravelMode.bicycling) {
            // avoid duplicating walking/bicycling icon
            if (step.travelMode != previousTravelMode) {
              firstPin = _getIconBasedOnTravelMode(step.travelMode);
            }
          } else {
            firstPin = _getIconBasedOnTravelMode(
              step.travelMode,
              vehicleType: step.transit?.line?.vehicle?.type,
            );
          }
        }
      }
      if (step.polyline?.points != null) {
        polyLines.add(
          _createPolyFromString(
            encodedPoly: step.polyline!.points!,
            type: step.travelMode ?? TravelMode.transit,
            id: const UuidV4().generate(),
            color: AppColors.primary,
          ),
        );
      }
      if (i < gSteps.length - 1) {
        final nextStep = gSteps[i + 1];
        if (step.endLocation != null && nextStep.startLocation != null) {
          polyLines.add(
            Polyline(
              polylineId: PolylineId(const UuidV4().generate()),
              patterns: const [PatternItem.dot],
              jointType: JointType.round,
              width: 4,
              zIndex: 2,
              points: [
                step.endLocation!.toLatLng(),
                nextStep.startLocation!.toLatLng(),
              ],
              color: AppColors.primary,
            ),
          );
        }
      }

      if (firstPin != null && step.startLocation != null) {
        markers.add(
          Marker(
            markerId: MarkerId(step.startLocation.toString()),
            position: step.startLocation!.toLatLng(),
            infoWindow: InfoWindow(
              title: step.startLocation.toString(),
              snippet: 'go here',
            ),
            icon: firstPin,
          ),
        );
      }

      steps.add(step.instructions ?? '');
      stepDurations.add(step.duration?.text ?? '');

      if (lastPin != null && step.endLocation != null) {
        markers.add(
          Marker(
            markerId: MarkerId(step.endLocation.toString()),
            position: step.endLocation!.toLatLng(),
            infoWindow: InfoWindow(
              title: step.endLocation.toString(),
              snippet: 'go here',
            ),
            icon: lastPin,
          ),
        );
      }

      previousTravelMode = step.travelMode;
    }

    return MapRoute(
      steps: steps,
      stepDurations: stepDurations,
      markers: markers,
      polyLines: polyLines,
    );
  }

  BitmapDescriptor? _getIconBasedOnTravelMode(
    TravelMode? travelMode, {
    TransitVehicleType? vehicleType,
  }) {
    switch (travelMode) {
      case TravelMode.walking:
        return _walkingPin;
      case TravelMode.bicycling:
        return _bikePin;
      case TravelMode.transit:
        switch (vehicleType) {
          case TransitVehicleType.commuterTrain:
          case TransitVehicleType.highSpeedTrain:
          case TransitVehicleType.longDistanceTrain:
          case TransitVehicleType.rail:
          case TransitVehicleType.heavyRail:
          case TransitVehicleType.metroRail:
          case TransitVehicleType.monorail:
          case TransitVehicleType.funicular:
          case TransitVehicleType.cableCar:
          case TransitVehicleType.gondolaLift:
            return _trainPin;

          case TransitVehicleType.subway:
          case TransitVehicleType.tram:
            return _subwayPin;

          case TransitVehicleType.ferry:
            return _boatPin;

          case TransitVehicleType.trolleybus:
          case TransitVehicleType.bus:
          case TransitVehicleType.intercityBus:
            return _busPin;

          case TransitVehicleType.other:
          case TransitVehicleType.shareTaxi:
          default:
            return null;
        }
      default:
        return null;
    }
  }

  Polyline _createPolyFromString({
    required String encodedPoly,
    required String id,
    required Color color,
    TravelMode? type,
  }) {
    if (type == TravelMode.walking) {
      return Polyline(
        polylineId: PolylineId(id),
        patterns: const [PatternItem.dot],
        jointType: JointType.round,
        width: 4,
        zIndex: 2,
        points: _convertToLatLng(ployLinePoints.decodePolyline(encodedPoly)),
        color: color,
      );
    } else {
      return Polyline(
        polylineId: PolylineId(id),
        width: 4,
        zIndex: 1,
        points: _convertToLatLng(ployLinePoints.decodePolyline(encodedPoly)),
        color: color,
      );
    }
  }

  List<LatLng> _convertToLatLng(List<poly.PointLatLng> points) {
    var result = <LatLng>[];
    for (var i = 0; i < points.length; i++) {
      result.add(LatLng(points[i].latitude, points[i].longitude));
    }
    return result;
  }
}
