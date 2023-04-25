import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lisbon_travel/constants/colors.dart';
import 'package:lisbon_travel/models/enums/accessibility_enum.dart';
import 'package:lisbon_travel/models/responses/transit_option.dart';

class StepAccessibility extends StatelessWidget {
  final TransitOption transitOption;

  const StepAccessibility({super.key, required this.transitOption});

  @override
  Widget build(BuildContext context) {
    if (transitOption.accessibilities?.isNotEmpty != true) {
      return const SizedBox.shrink();
    }

    return Column(
      children: transitOption.accessibilities!
          .map(
            (e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  SvgPicture.asset(
                    e.svgAsset,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    e.humanName,
                    style: const TextStyle(
                      fontSize: 15.5,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
