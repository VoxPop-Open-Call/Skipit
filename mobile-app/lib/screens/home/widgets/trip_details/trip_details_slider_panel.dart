import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:lisbon_travel/constants/colors.dart';
import 'package:lisbon_travel/generated/assets.gen.dart';
import 'package:lisbon_travel/generated/locale_keys.g.dart';
import 'package:lisbon_travel/logic/bloc/trip/trip_bloc.dart';
import 'package:lisbon_travel/logic/service/settings_service.dart';
import 'package:lisbon_travel/models/responses/transit_option.dart';
import 'package:lisbon_travel/screens/home/widgets/trip_details/step_details_list.dart';
import 'package:lisbon_travel/utils/extensions/index.dart';
import 'package:lisbon_travel/widgets/accessibility_report_button.dart';
import 'package:lisbon_travel/widgets/step_accessibility.dart';
import 'package:lisbon_travel/widgets/step_line_info.dart';
import 'package:lisbon_travel/widgets/sub_step_instructions.dart';
import 'package:lisbon_travel/widgets/trip_overview.dart';

class TripDetailsSliderPanel extends StatefulWidget {
  final DirectionsRoute route;
  final TravelMode travelMode;
  final List<TransitOption>? transitOptions;
  final Function(int pageIndex)? onPageChanged;

  const TripDetailsSliderPanel({
    Key? key,
    required this.route,
    required this.travelMode,
    this.transitOptions,
    this.onPageChanged,
  }) : super(key: key);

  @override
  State<TripDetailsSliderPanel> createState() => _TripDetailsSliderPanelState();
}

class _TripDetailsSliderPanelState extends State<TripDetailsSliderPanel> {
  final CarouselController _carouselController = CarouselController();
  final setting = GetIt.I<SettingsService>().options;
  int carouselIndex = 0;

  @override
  Widget build(BuildContext context) {
    final heightBar = MediaQuery.of(context).size.width * 0.32;
    final leg = widget.route.legs!.first;
    final steps = widget.route.steps!;

    return BlocListener<TripBloc, TripState>(
      listener: (context, state) {
        state.mapOrNull(
          navigation: (state) {
            // move to the next travel index if
            // - we find the navigation step
            // - it's not the current step
            if (state.currentStepIndex > 0 &&
                state.currentStepIndex + 1 > carouselIndex) {
              _carouselController.animateToPage(state.currentStepIndex + 1);
            }
          },
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade600,
              borderRadius: BorderRadius.circular(10),
            ),
            width: 20,
            height: 2.5,
          ),
          const SizedBox(height: 8),
          Text(
            LocaleKeys.journeyOverview.tr(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          Container(
            height: heightBar - 18 - 2.5 - 16,
            padding: const EdgeInsets.only(bottom: 10),
            width: MediaQuery.of(context).size.width,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CarouselSlider.builder(
                  carouselController: _carouselController,
                  options: CarouselOptions(
                    enableInfiniteScroll: false,
                    enlargeCenterPage: false,
                    viewportFraction: 1,
                    onPageChanged: (index, reason) {
                      setState(() {
                        carouselIndex = index;
                      });
                      widget.onPageChanged?.call(index);
                    },
                  ),
                  itemCount: 1 + steps.length + 1,
                  itemBuilder: (context, index, realIndex) {
                    Widget child;
                    if (index == 0) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.11,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TripOverview(
                              route: widget.route,
                              tripType: widget.travelMode,
                              showWalkingTime: true,
                              compactMode: true,
                              showGoButton: false,
                            ),
                          ],
                        ),
                      );
                    } else if (index >= 1 && index < steps.length + 1) {
                      child = _stepHeader(steps[index - 1]);
                    } else {
                      child = _locationHeader(
                        leg.endAddress ?? '',
                        leg.arrivalTime?.text?.toUpperCase() ?? '',
                        false,
                      );
                    }

                    return _addPadding(child: child);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => carouselIndex == 0
                            ? null
                            : _carouselController.previousPage(),
                        child: Icon(
                          Icons.arrow_back_ios_outlined,
                          color: carouselIndex == 0
                              ? AppColors.disabledIcon
                              : AppColors.primary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => carouselIndex == steps.length - 1 + 2
                            ? null
                            : _carouselController.nextPage(),
                        child: Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: carouselIndex == steps.length - 1 + 2
                              ? AppColors.disabledIcon
                              : AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.width * 0.07,
                right: MediaQuery.of(context).size.width * 0.05,
                left: MediaQuery.of(context).size.width * 0.05,
              ),
              child: ClipRect(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  child: _stepDetails(leg, steps),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _locationHeader(String address, String departureTime, bool isStart) {
    return Row(
      children: [
        Center(
          child: Image.asset(
            isStart
                ? Assets.mapIcons.startMarker.path
                : Assets.mapIcons.endMarker.path,
            width: MediaQuery.of(context).size.width * 0.1,
            height: MediaQuery.of(context).size.width * 0.1,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                address,
                style: const TextStyle(color: Colors.black),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              if (departureTime.isNotEmpty)
                Text(
                  departureTime,
                  style: const TextStyle(
                    color: Colors.black45,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _stepHeader(DirectionsStep step) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (step.travelPngIcon != null) ...{
          Center(
            child: Image.asset(
              step.travelPngIcon!,
              width: MediaQuery.of(context).size.width * 0.1,
              height: MediaQuery.of(context).size.width * 0.1,
            ),
          ),
          const SizedBox(width: 16),
        },
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                Bidi.stripHtmlIfNeeded(step.instructions ?? ''),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                step.transit?.numStops != null
                    ? LocaleKeys.getOfAfter.plural(step.transit!.numStops!) +
                        (step.duration?.text != null
                            ? ' - ${step.duration!.text}'
                            : '')
                    : step.duration?.text ?? '',
                style: const TextStyle(
                  color: Colors.black45,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _stepDetails(DirectionsLeg leg, List<DirectionsStep> steps) {
    if (carouselIndex == 0) {
      return StepDetailsList(leg: leg);
    }

    if ((carouselIndex - 1) >= steps.length) {
      return const SizedBox.shrink();
    }

    final step = steps[carouselIndex - 1];
    final station = step.station;
    TransitOption? stepAccessibility;
    if (setting.showAccessibility && station != null) {
      stepAccessibility =
          widget.transitOptions!.findByTransitTypeTuple(station);
    }
    final transitType =
        stepAccessibility?.transportTypes.firstOrNull ?? station?.type;
    return Column(
      children: [
        if (step.steps != null) SubStepInstructions(steps: step.steps!),
        if (step.transit?.line != null) StepLineInfo(line: step.transit!.line!),
        if (setting.showAccessibility && station != null) ...{
          const SizedBox(height: 14),
          if (stepAccessibility != null) ...{
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${LocaleKeys.accessibilityAtStation.tr()}:',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: StepAccessibility(transitOption: stepAccessibility),
            ),
          } else ...{
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                LocaleKeys.cError_noAccessibilityStation.tr(),
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 8),
          },
          if (transitType != null) ...{
            const SizedBox(height: 8),
            AccessibilityReportButton(transportType: transitType),
          }
        },
      ],
    );
  }

  Widget _addPadding({required Widget child}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.11,
        vertical: 10,
      ),
      child: child,
    );
  }
}
