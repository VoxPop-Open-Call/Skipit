import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:lisbon_travel/constants/styles.dart';
import 'package:lisbon_travel/generated/locale_keys.g.dart';
import 'package:lisbon_travel/logic/bloc/trip/trip_bloc.dart';
import 'package:lisbon_travel/screens/home/widgets/trip_details/trip_details_slider_panel.dart';
import 'package:lisbon_travel/utils/extensions/index.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class TripDetails extends StatefulWidget {
  const TripDetails({super.key});

  @override
  State<TripDetails> createState() => _TripDetailsState();
}

class _TripDetailsState extends State<TripDetails> {
  bool shouldShowBuyButton = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripBloc, TripState>(
      builder: (context, state) {
        return state.maybeMap<Widget>(
          navigation: (state) {
            // don't show anything if we don't have any steps
            if (state.route.legs?.firstOrNull?.steps?.isNotEmpty != true) {
              return const SizedBox();
            }

            return Stack(
              children: [
                Positioned(
                  bottom: MediaQuery.of(context).size.width * 0.32 + 8,
                  right: 0,
                  left: 0,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: shouldShowBuyButton &&
                            state.travelMode == TravelMode.transit
                        ? SizedBox(
                            width: 160,
                            key: const ValueKey('buyButton'),
                            child: TextButton(
                              style: $styles.button.primaryTextButtonStyle,
                              onPressed: () {
                                // todo: redirect to buying
                              },
                              child: Text(LocaleKeys.buyTicket.tr()),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: SlidingUpPanel(
                    minHeight: MediaQuery.of(context).size.width * 0.32,
                    maxHeight: MediaQuery.of(context).size.height * 0.9 -
                        MediaQuery.of(context).padding.top,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(0, -1),
                        blurRadius: 5,
                        spreadRadius: 2,
                      ),
                    ],
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    panel: TripDetailsSliderPanel(
                      route: state.route,
                      travelMode: state.travelMode,
                      transitOptions: state.transitOption,
                      onPageChanged: (index) {
                        setState(() {
                          shouldShowBuyButton = index == 0;
                        });
                      },
                    ),
                  ),
                ),
              ],
            );
          },
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }
}
