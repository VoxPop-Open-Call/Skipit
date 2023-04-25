import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lisbon_travel/constants/colors.dart';
import 'package:lisbon_travel/models/enums/accessibility_enum.dart';
import 'package:lisbon_travel/models/enums/transport_type_enum.dart';
import 'package:lisbon_travel/models/responses/transit_option.dart';

class TransitDetails extends StatelessWidget {
  final TransitOption? transit;

  const TransitDetails({
    Key? key,
    this.transit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (transit == null) {
      return const SizedBox.shrink();
    }

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.only(top: 95, right: 16, left: 16),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  transit!.name +
                      (transit!.transportTypes.isNotEmpty
                          ? ' (${transit!.transportTypes.first.humanName})'
                          : ''),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...transit!.transportTypes.map(
                (e) => Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Image.asset(
                    e.pngIcon,
                    width: 30,
                    height: 30,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...?transit!.accessibilities?.map(
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
          ),
        ],
      ),
    );
  }
}
