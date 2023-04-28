import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:lisbon_travel/constants/colors.dart';
import 'package:lisbon_travel/generated/assets.gen.dart';
import 'package:lisbon_travel/utils/extensions/index.dart';
import 'package:lisbon_travel/utils/utils.dart';

class TripOverview extends StatelessWidget {
  const TripOverview({
    required this.route,
    required this.tripType,
    required this.showGoButton,
    this.showWalkingTime = false,
    this.compactMode = false,
    this.onTap,
    super.key,
  });

  final DirectionsRoute route;
  final TravelMode tripType;
  final bool showWalkingTime;
  final bool compactMode;
  final bool showGoButton;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final routeLeg = route.legs?.firstOrNull;
    if (routeLeg == null) {
      return const SizedBox();
    }

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(right: showGoButton ? 18 : 0),
          child: tripType == TravelMode.transit
              ? compactMode
                  ? multiStepOptionCompact(routeLeg)
                  : multiStepOption(routeLeg)
              : singleStepOption(routeLeg),
        ),
        if (showGoButton) _goButton(),
      ],
    );
  }

  Widget multiStepOption(DirectionsLeg routeLeg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10) +
          EdgeInsets.only(right: showGoButton ? 16 : 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.primary,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (routeLeg.departureTime != null &&
                  routeLeg.arrivalTime != null)
                _startEndTime(routeLeg),
              const Spacer(),
              _estimatedHorizontalTime(routeLeg),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(right: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: getTripStepIcon(routeLeg),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget multiStepOptionCompact(DirectionsLeg routeLeg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.primary,
          width: 2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(right: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: getTripStepIcon(routeLeg),
              ),
            ),
          ),
          const SizedBox(width: 3),
          _estimatedVerticalTime(routeLeg),
        ],
      ),
    );
  }

  Widget singleStepOption(DirectionsLeg routeLeg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16) +
          EdgeInsets.only(right: showGoButton ? 16 : 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.primary,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 8),
          Center(
            child: Image.asset(
              tripType == TravelMode.bicycling
                  ? Assets.mapIcons.bikeIcon.path
                  : Assets.mapIcons.walkIcon.path,
              width: 36,
              height: 36,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      '${routeLeg.distance?.text} via ${route.summary}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _estimatedVerticalTime(routeLeg),
        ],
      ),
    );
  }

  Widget _goButton() {
    return Positioned(
      right: 0,
      top: 0,
      bottom: 0,
      child: Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
          width: 40,
          height: 40,
          child: TextButton(
            style: TextButton.styleFrom(
              elevation: 1,
              backgroundColor: AppColors.primary,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(0),
            ),
            onPressed: onTap,
            child: const Text(
              'GO',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> getTripStepIcon(DirectionsLeg leg) {
    const double iconSize = 24;
    var icons = <Widget>[];

    final steps = leg.steps ?? [];
    for (final step in steps) {
      if (step.travelMode == TravelMode.driving) {
        icons.add(const Icon(
          Icons.directions_car,
          size: iconSize,
          color: Colors.black,
        ));
      } else if (step.travelMode == TravelMode.bicycling) {
        icons.add(Image.asset(
          Assets.mapIcons.walkIcon.path,
          width: iconSize,
          height: iconSize,
        ));
      } else if (step.travelMode == TravelMode.walking) {
        icons.add(Image.asset(
          Assets.mapIcons.walkIcon.path,
          width: iconSize,
          height: iconSize,
        ));
        if (showWalkingTime && step.duration?.value != null) {
          icons.add(
            Padding(
              padding: const EdgeInsets.only(left: 3),
              child: Text(
                secondsToMinuteText(step.duration!.value!),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          );
        }
      } else if (step.travelMode == TravelMode.transit) {
        if (step.transit?.line?.vehicle?.type == null) {
          continue;
        }
        final vehicleType = step.transit!.line!.vehicle!.type!;
        final line = step.transit!.line;

        icons.add(Image.asset(
          vehicleType.pngIcon,
          width: iconSize,
          height: iconSize,
        ));

        if (line?.lineName != null) {
          final color = line?.color == null || line?.color == ''
              ? Colors.black
              : hexToColor(line!.color!);
          final textColor =
              color.computeLuminance() > 0.5 ? Colors.black : Colors.white;

          icons.add(
            Container(
              margin: const EdgeInsets.only(left: 3),
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 1, left: 2, right: 2),
                child: Text(
                  line!.lineName,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 10,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ),
          );
        }
      }

      icons.add(
        Text(
          ' > ',
          style: TextStyle(
            fontFamily: 'Roboto',
            color: AppColors.primary.withOpacity(0.6),
            fontSize: 16,
          ),
        ),
      );
    }

    if (icons.isNotEmpty) icons.removeLast();

    return icons;
  }

  Widget _startEndTime(DirectionsLeg trip) {
    if (trip.arrivalTime?.text == null) {
      return const SizedBox();
    }

    return Row(
      children: [
        if (trip.departureTime?.text != null)
          Center(
            child: Text(
              convert12To24hours(trip.departureTime!.text!),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: FaIcon(
            FontAwesomeIcons.arrowRight,
            size: 18,
            color: AppColors.textGrey,
          ),
        ),
        Center(
          child: Text(
            convert12To24hours(trip.arrivalTime!.text!),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _estimatedHorizontalTime(DirectionsLeg trip) {
    if (trip.duration?.value == null) {
      return const SizedBox();
    }

    return Text(
      secondsToMinuteText(trip.duration!.value!, showMinText: true),
      style: const TextStyle(
        color: Colors.black,
        fontSize: 15,
      ),
    );
  }

  Widget _estimatedVerticalTime(DirectionsLeg trip) {
    if (trip.duration?.value == null) {
      return const SizedBox();
    }

    final text = secondsToMinuteText(trip.duration!.value!, showMinText: true);
    return Column(
      children: [
        Text(
          text.split(' ')[0],
          style: const TextStyle(
            color: Colors.black,
            fontSize: 15,
          ),
        ),
        Text(
          text.split(' ')[1],
          style: const TextStyle(
            color: Colors.black,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
