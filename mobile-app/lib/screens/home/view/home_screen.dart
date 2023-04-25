import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lisbon_travel/logic/bloc/map/map_bloc.dart';
import 'package:lisbon_travel/logic/bloc/trip/trip_bloc.dart';
import 'package:lisbon_travel/logic/service/location_service.dart';
import 'package:lisbon_travel/screens/home/widgets/helper_buttons/helper_buttons.dart';
import 'package:lisbon_travel/screens/home/widgets/map_back_button.dart';
import 'package:lisbon_travel/screens/home/widgets/map_view.dart';
import 'package:lisbon_travel/screens/home/widgets/search/search_slider.dart';
import 'package:lisbon_travel/screens/home/widgets/settings_button.dart';
import 'package:lisbon_travel/screens/home/widgets/trip_details/trip_details.dart';
import 'package:lisbon_travel/utils/extensions/index.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const HomeView();
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // check if currentStepIndex changed
        // and if so, move map camera to the user location
        BlocListener<TripBloc, TripState>(
          listenWhen: (previous, current) => current.maybeMap(
            navigation: (currentState) => previous.maybeMap(
              navigation: (prevState) =>
                  prevState.currentStepIndex != currentState.currentStepIndex,
              orElse: () => false,
            ),
            orElse: () => false,
          ),
          listener: (context, state) {
            state.mapOrNull(
              navigation: (state) {
                final mapBloc = context.read<MapBloc>();
                final locationService = GetIt.I<LocationService>();
                if (locationService.position != null) {
                  mapBloc.add(
                    MapEvent.setLocation(
                      locationService.position!.toLatLng(),
                      zoom: 17,
                    ),
                  );
                }
              },
            );
          },
        ),
      ],
      child: WillPopScope(
        onWillPop: () async {
          final mapBloc = context.read<MapBloc>();
          final tripBloc = context.read<TripBloc>();

          final hasStartedTrip = tripBloc.state.maybeMap(
            navigation: (_) => true,
            orElse: () => false,
          );
          if (hasStartedTrip) {
            mapBloc.add(const MapEvent.clearRoute());
            tripBloc.add(const TripEvent.endTrip());
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          extendBody: false,
          body: Stack(
            children: const [
              MapView(),
              MapHelperButtons(),
              SearchSlider(),
              TripDetails(),
              MapBackButton(),
              SettingsButton(),
            ],
          ),
        ),
      ),
    );
  }
}
