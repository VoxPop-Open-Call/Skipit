import 'dart:async';

import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lisbon_travel/utils/extensions/index.dart';

enum LocationPermissionStatus {
  serviceDisabled,
  denied,
  granted,
  deniedForever,
}

class LocationService extends ChangeNotifier {
  StreamSubscription? _locationSub;
  Position? _position;
  LocationPermissionStatus? _permissionStatus;
  Placemark? _placemark;
  Position? _placemarkPosition;

  Position? get position => _position;

  Placemark? get placemark => _placemark;

  LocationPermissionStatus? get permissionStatus => _permissionStatus;

  LocationService() {
    requestPermission().then((permission) {
      if (permission == LocationPermissionStatus.granted) {
        try {
          _locationSub = Geolocator.getPositionStream(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.best,
              distanceFilter: 3,
            ),
          ).listen((position) => _setPosition(position));
        } catch (_) {}
      }
    });
  }

  Future<Placemark?> getCurrentPlace() async {
    if (_placemark != null) {
      return _placemark;
    }
    if (position != null) {
      try {
        final placemarks = await placemarkFromCoordinates(
          position!.latitude,
          position!.longitude,
          localeIdentifier: 'en_US',
        );
        _placemarkPosition = position;
        _placemark = placemarks.elementAt(0);
        return placemark;
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    return null;
  }

  Future<Either<LocationPermissionStatus, Position?>>
      forceRequestLocation() async {
    final permission = await requestPermission();
    if (permission == LocationPermissionStatus.granted) {
      Position? currentPosition;
      try {
        currentPosition = await Geolocator.getCurrentPosition(
          timeLimit: const Duration(seconds: 4),
        );
      } catch (e) {
        currentPosition = await Geolocator.getLastKnownPosition();
      }
      if (currentPosition != null) {
        _setPosition(currentPosition);
        return Right(position);
      } else {
        return Left(permission);
      }
    } else {
      return Left(permission);
    }
  }

  Future<LocationPermissionStatus> requestPermission() async {
    final permission = await determinePermission();
    switch (permission) {
      case LocationPermissionStatus.deniedForever:
      case LocationPermissionStatus.granted:
        _permissionStatus = permission;
        return permission;
      case LocationPermissionStatus.serviceDisabled:
      case LocationPermissionStatus.denied:
        try {
          await Geolocator.requestPermission();
          notifyListeners();
          return await determinePermission();
        } catch (_) {
          return permission;
        }
    }
  }

  Future<LocationPermissionStatus> determinePermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationPermissionStatus.serviceDisabled;
    }

    final permission = await Geolocator.checkPermission();
    switch (permission) {
      case LocationPermission.denied:
        _permissionStatus = LocationPermissionStatus.denied;
        break;
      case LocationPermission.deniedForever:
        _permissionStatus = LocationPermissionStatus.deniedForever;
        break;
      case LocationPermission.always:
      case LocationPermission.whileInUse:
        _permissionStatus = LocationPermissionStatus.granted;
        break;
      default:
        _permissionStatus = LocationPermissionStatus.denied;
    }
    return _permissionStatus!;
  }

  void _setPosition(Position newPosition) {
    // invalidate the placemark if the position has changed more than 100 meters
    if (_placemarkPosition != null) {
      if (_placemarkPosition!.distanceTo(newPosition) > 100) {
        _placemarkPosition = null;
        _placemark = null;
      }
    }
    if (_position?.isNotSameLocation(newPosition) ?? true) {
      _position = newPosition;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _locationSub?.cancel();
  }
}
