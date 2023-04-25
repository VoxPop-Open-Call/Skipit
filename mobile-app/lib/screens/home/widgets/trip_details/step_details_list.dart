import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:lisbon_travel/generated/assets.gen.dart';
import 'package:lisbon_travel/generated/locale_keys.g.dart';
import 'package:lisbon_travel/utils/extensions/index.dart';
import 'package:lisbon_travel/widgets/step_line_info.dart';
import 'package:lisbon_travel/widgets/sub_step_instructions.dart';

class StepDetailsList extends StatelessWidget {
  final DirectionsLeg leg;

  const StepDetailsList({super.key, required this.leg});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _edgeStepTile(
          context,
          leg.startAddress ?? '',
          leg.departureTime?.text?.toUpperCase() ?? '',
          true,
        ),
        ...List.generate(
          leg.steps!.length,
          (index) => _stepTile(context, leg.steps![index]),
        ),
        _edgeStepTile(
          context,
          leg.endAddress ?? '',
          leg.arrivalTime?.text?.toUpperCase() ?? '',
          false,
        )
      ],
    );
  }

  Widget _edgeStepTile(
    BuildContext context,
    String address,
    String departureTime,
    bool isStart,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Image.asset(
              isStart
                  ? Assets.mapIcons.startMarker.path
                  : Assets.mapIcons.endMarker.path,
              width: MediaQuery.of(context).size.width * 0.08,
              height: MediaQuery.of(context).size.width * 0.08,
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.05),
            Expanded(
              child: Text(
                address,
                style: const TextStyle(color: Colors.black),
              ),
            ),
            if (departureTime.isNotEmpty)
              Text(
                departureTime,
                style: const TextStyle(color: Colors.black54, fontSize: 14),
              )
          ],
        ),
        if (isStart) const Divider(),
      ],
    );
  }

  Widget _stepTile(BuildContext context, DirectionsStep step) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.02),
      child: Column(
        children: [
          Row(
            children: [
              if (step.travelPngIcon != null) ...{
                Image.asset(
                  step.travelPngIcon!,
                  width: MediaQuery.of(context).size.width * 0.08,
                  height: MediaQuery.of(context).size.width * 0.08,
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.05),
              },
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Bidi.stripHtmlIfNeeded(step.instructions ?? ''),
                      style: const TextStyle(color: Colors.black),
                    ),
                    if (step.transit?.numStops != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          LocaleKeys.getOfAfter.plural(step.transit!.numStops!),
                          style: const TextStyle(
                            color: Colors.black45,
                            fontSize: 14,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (step.steps != null) ...{
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SubStepInstructions(steps: step.steps!),
            ),
          },
          if (step.transit?.line != null) ...{
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: StepLineInfo(line: step.transit!.line!),
            ),
          },
          const Divider()
        ],
      ),
    );
  }
}
