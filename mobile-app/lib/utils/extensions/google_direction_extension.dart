import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lisbon_travel/generated/assets.gen.dart';
import 'package:lisbon_travel/models/enums/transport_type_enum.dart';
import 'package:lisbon_travel/models/responses/transit_option.dart';
import 'package:lisbon_travel/utils/utils.dart';

extension DirectionRouteExtension on DirectionsRoute {
  List<DirectionsStep>? get steps => legs?.firstOrNull?.steps;

  Set<TransitTypeTuple> get stations {
    return (steps ?? <DirectionsStep>[])
        .map<TransitTypeTuple?>((step) => step.station)
        .where((station) => station != null)
        .cast<TransitTypeTuple>()
        .toSet();
  }
}

extension GeoCoordExtension on GeoCoord {
  LatLng toLatLng() => LatLng(latitude, longitude);
}

extension TransitLineExtension on TransitLine {
  Color get lineColor =>
      color == '' || color == null ? Colors.black : hexToColor(color!);

  String get lineName => shortName ?? name ?? '';
}

extension DirectionsStepExtension on DirectionsStep {
  TransitTypeTuple? get station {
    if (travelMode == TravelMode.transit) {
      final transitType = transit?.line?.vehicle?.type;
      // if it's a bus, then we need the line number
      // else, we need the departure stop
      if (transitType == TransitVehicleType.bus ||
          transitType == TransitVehicleType.intercityBus ||
          transitType == TransitVehicleType.trolleybus) {
        if (transit?.line?.shortName?.isNotEmpty == true) {
          return TransitTypeTuple(
            name: transit!.line!.shortName!,
            type: TransportTypeEnum.bus,
          );
        }
      } else {
        if (transit?.departureStop?.name?.isNotEmpty == true) {
          return TransitTypeTuple(
            name: transit!.departureStop!.name!,
            type: transitType?.transportTypeEqual,
          );
        } else if (transit?.arrivalStop?.name?.isNotEmpty == true) {
          return TransitTypeTuple(
            name: transit!.arrivalStop!.name!,
            type: transitType?.transportTypeEqual,
          );
        }
      }
    }
    return null;
  }

  // MANEUVER_UNSPECIFIED -> Not used.
  // TURN_SLIGHT_LEFT -> Turn slightly to the left.
  // TURN_SHARP_LEFT -> Turn sharply to the left.
  // UTURN_LEFT -> Make a left u-turn.
  // TURN_LEFT -> Turn left.
  // TURN_SLIGHT_RIGHT -> Turn slightly to the right.
  // TURN_SHARP_RIGHT -> Turn sharply to the right.
  // UTURN_RIGHT -> Make a right u-turn.
  // TURN_RIGHT -> Turn right.
  // STRAIGHT -> Go straight.
  // RAMP_LEFT -> Take the left ramp.
  // RAMP_RIGHT -> Take the right ramp.
  // MERGE -> Merge into traffic.
  // FORK_LEFT -> Take the left fork.
  // FORK_RIGHT -> Take the right fork.
  // FERRY -> Take the ferry.
  // FERRY_TRAIN -> Take the train leading onto the ferry.
  // ROUNDABOUT_LEFT -> Turn left at the roundabout.
  // ROUNDABOUT_RIGHT -> Turn right at the roundabout.
  IconData? get actionIcon {
    if (maneuver == null) return null;

    if (maneuver!.contains('left')) {
      return FontAwesomeIcons.arrowLeft;
    } else if (maneuver!.contains('right')) {
      return FontAwesomeIcons.arrowRight;
    }
    switch (maneuver) {
      case 'straight':
        return FontAwesomeIcons.arrowUp;
      case 'merge':
        return Icons.merge_type_outlined;
      case 'ferry':
      case 'ferry-train':
        return FontAwesomeIcons.ferry;
      default:
        return Icons.error_outline;
    }
  }

  IconData? get travelIcon {
    switch (travelMode) {
      case TravelMode.driving:
        return FontAwesomeIcons.car;
      case TravelMode.walking:
        return FontAwesomeIcons.personWalking;
      case TravelMode.bicycling:
        return FontAwesomeIcons.personBiking;
      case TravelMode.transit:
        return transit?.line?.vehicle?.type?.icon;
      default:
        return null;
    }
  }

  String? get travelPngIcon {
    switch (travelMode) {
      case TravelMode.walking:
        return Assets.mapIcons.walkIcon.path;
      case TravelMode.bicycling:
        return Assets.mapIcons.bikeIcon.path;
      case TravelMode.transit:
        return transit?.line?.vehicle?.type?.pngIcon;
      case TravelMode.driving:
      default:
        return null;
    }
  }
}

extension TransitVehicleTypeExtension on TransitVehicleType {
  IconData get icon {
    switch (this) {
      case TransitVehicleType.commuterTrain:
      case TransitVehicleType.highSpeedTrain:
      case TransitVehicleType.longDistanceTrain:
      case TransitVehicleType.rail:
      case TransitVehicleType.heavyRail:
      case TransitVehicleType.metroRail:
      case TransitVehicleType.monorail:
      case TransitVehicleType.funicular:
        return FontAwesomeIcons.train;

      case TransitVehicleType.subway:
        return FontAwesomeIcons.trainSubway;

      case TransitVehicleType.tram:
        return FontAwesomeIcons.trainTram;

      case TransitVehicleType.ferry:
        return FontAwesomeIcons.ferry;

      case TransitVehicleType.cableCar:
      case TransitVehicleType.gondolaLift:
        return FontAwesomeIcons.cableCar;

      case TransitVehicleType.shareTaxi:
        return FontAwesomeIcons.taxi;

      case TransitVehicleType.trolleybus:
      case TransitVehicleType.bus:
      case TransitVehicleType.intercityBus:
        return FontAwesomeIcons.bus;

      case TransitVehicleType.other:
        return FontAwesomeIcons.car;
    }
  }

  String get pngIcon {
    switch (this) {
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
        return Assets.mapIcons.train.path;

      case TransitVehicleType.subway:
      case TransitVehicleType.tram:
        return Assets.mapIcons.subwayIcon.path;

      case TransitVehicleType.ferry:
        return Assets.mapIcons.boatIcon.path;

      case TransitVehicleType.trolleybus:
      case TransitVehicleType.bus:
      case TransitVehicleType.intercityBus:
        return Assets.mapIcons.busIcon.path;

      case TransitVehicleType.shareTaxi:
      case TransitVehicleType.other:
        return Assets.mapIcons.walkIcon.path;
    }
  }

  TransportTypeEnum? get transportTypeEqual {
    switch (this) {
      case TransitVehicleType.commuterTrain:
      case TransitVehicleType.highSpeedTrain: // todo check
      case TransitVehicleType.longDistanceTrain: // todo check
      case TransitVehicleType.rail: // todo check
      case TransitVehicleType.heavyRail:
      case TransitVehicleType.metroRail: // todo check
      case TransitVehicleType.monorail: // todo check
      case TransitVehicleType.funicular: // todo check
        return TransportTypeEnum.train;

      case TransitVehicleType.subway:
        return TransportTypeEnum.metro;

      case TransitVehicleType.tram:
        return TransportTypeEnum.tram;

      case TransitVehicleType.ferry:
        return TransportTypeEnum.ferry;

      case TransitVehicleType.trolleybus:
      case TransitVehicleType.bus:
      case TransitVehicleType.intercityBus:
        return TransportTypeEnum.bus;

      case TransitVehicleType.cableCar:
      case TransitVehicleType.gondolaLift:
      case TransitVehicleType.shareTaxi:
      case TransitVehicleType.other:
      default:
        return null;
    }
  }
}
