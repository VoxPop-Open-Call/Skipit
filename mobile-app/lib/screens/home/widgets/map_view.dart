import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lisbon_travel/constants/constants.dart';
import 'package:lisbon_travel/logic/bloc/map/map_bloc.dart';
import 'package:lisbon_travel/logic/service/location_service.dart';
import 'package:lisbon_travel/utils/extensions/index.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: GetIt.I<LocationService>(),
      builder: (context, _) {
        return BlocBuilder<MapBloc, MapState>(
          builder: (context, state) {
            return GoogleMap(
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) {
                if (mounted) {
                  context
                      .read<MapBloc>()
                      .add(MapEvent.setController(controller));
                }
              },
              initialCameraPosition: CameraPosition(
                target: GetIt.I<LocationService>().position?.toLatLng() ??
                    kLisbonPosition,
                zoom: 12.0,
              ),
              markers: state.mapOrNull(
                    loaded: (s) => s.mapRoute?.markers,
                  ) ??
                  const <Marker>{},
              polylines: state.mapOrNull(
                    loaded: (s) => s.mapRoute?.polyLines,
                  ) ??
                  const <Polyline>{},
              mapToolbarEnabled: false,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              tiltGesturesEnabled: false,
              minMaxZoomPreference: const MinMaxZoomPreference(6.1, 19.5),
              myLocationEnabled: GetIt.I<LocationService>().permissionStatus ==
                  LocationPermissionStatus.granted,
              myLocationButtonEnabled: false,
            );
          },
        );
      },
    );
  }
}
