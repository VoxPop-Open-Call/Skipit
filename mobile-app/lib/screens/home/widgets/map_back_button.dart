import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lisbon_travel/logic/bloc/trip/trip_bloc.dart';

class MapBackButton extends StatelessWidget {
  const MapBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<TripBloc, TripState>(
        builder: (context, state) {
          return state.maybeMap(
            navigation: (_) => const Material(
              color: Colors.transparent,
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: BackButton(),
            ),
            orElse: () => const SizedBox(),
          );
        },
      ),
    );
  }
}
