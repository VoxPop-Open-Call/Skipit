import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:lisbon_travel/constants/colors.dart';
import 'package:lisbon_travel/utils/extensions/index.dart';

class SubStepInstructions extends StatelessWidget {
  final List<DirectionsStep> steps;

  const SubStepInstructions({Key? key, required this.steps}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        steps.length,
        (index) {
          final cStep = steps[index];
          if (cStep.instructions == null || cStep.instructions?.trim() == '') {
            return const SizedBox.shrink();
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                cStep.maneuver != null
                    ? Icon(
                        cStep.actionIcon,
                        size: MediaQuery.of(context).size.width * 0.04,
                        color: AppColors.primary.withOpacity(0.8),
                      )
                    : Icon(
                        FontAwesomeIcons.info,
                        size: MediaQuery.of(context).size.width * 0.04,
                        color: Colors.grey,
                      ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    Bidi.stripHtmlIfNeeded(cStep.instructions ?? ''),
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
