import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lisbon_travel/constants/styles.dart';
import 'package:lisbon_travel/generated/locale_keys.g.dart';
import 'package:lisbon_travel/logic/bloc/map/map_bloc.dart';
import 'package:lisbon_travel/logic/service/location_service.dart';
import 'package:lisbon_travel/logic/service/toast_manager.dart';
import 'package:lisbon_travel/utils/extensions/index.dart';

class LocateMeButton extends StatefulWidget {
  const LocateMeButton({Key? key}) : super(key: key);

  @override
  State<LocateMeButton> createState() => _LocateMeButtonState();
}

class _LocateMeButtonState extends State<LocateMeButton> {
  bool clicked = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: MediaQuery.of(context).size.width * 0.1,
      child: ElevatedButton(
        onPressed: () => clicked ? {} : _requestLocation.call(),
        style: $styles.button.fabGrey,
        child: Icon(
          Icons.my_location_rounded,
          size: MediaQuery.of(context).size.width * 0.08 / 1.5,
        ),
      ),
    );
  }

  Future<void> _requestLocation() async {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    final locationService = GetIt.I<LocationService>();
    final toastManager = GetIt.I<ToastManager>();

    clicked = true;
    final location = await locationService.forceRequestLocation();
    if (location.isLeft) {
      switch (location.left) {
        case LocationPermissionStatus.denied:
        case LocationPermissionStatus.deniedForever:
          toastManager.error(LocaleKeys.cLocation_denied.tr());
          break;
        case LocationPermissionStatus.serviceDisabled:
          toastManager.error(LocaleKeys.cLocation_serviceIsDisabled.tr());
          break;
        case LocationPermissionStatus.granted:
          break;
      }
    } else {
      mapBloc.add(MapEvent.setLocation(location.right!.toLatLng()));
    }
    clicked = false;
  }
}
