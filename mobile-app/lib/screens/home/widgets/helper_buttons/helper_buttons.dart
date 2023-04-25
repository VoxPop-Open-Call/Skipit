import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lisbon_travel/logic/bloc/trip/trip_bloc.dart';
import 'package:lisbon_travel/screens/home/widgets/helper_buttons/helper_expandable_buttons.dart';
import 'package:lisbon_travel/widgets/locate_me_button.dart';

class MapHelperButtons extends StatelessWidget {
  const MapHelperButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripBloc, TripState>(
      builder: (context, state) {
        return AnimatedPositioned(
          duration: const Duration(milliseconds: 200),
          bottom: state.maybeMap(
            navigation: (_) => MediaQuery.of(context).size.width * 0.32 + 12,
            orElse: () => MediaQuery.of(context).size.width * 0.05 + 90,
          ),
          right: MediaQuery.of(context).size.width * 0.05,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                HelperExpandableButtons(),
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: LocateMeButton(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
