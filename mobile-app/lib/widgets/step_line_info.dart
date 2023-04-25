import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:lisbon_travel/generated/locale_keys.g.dart';
import 'package:lisbon_travel/utils/extensions/index.dart';

class StepLineInfo extends StatelessWidget {
  final TransitLine line;

  const StepLineInfo({super.key, required this.line});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(
            FontAwesomeIcons.info,
            size: MediaQuery.of(context).size.width * 0.04,
            color: Colors.grey,
          ),
          const SizedBox(width: 12),
          Text(
            '${LocaleKeys.line.tr()} ',
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 14,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 2),
            padding: const EdgeInsets.symmetric(
              horizontal: 2,
              vertical: 1,
            ),
            decoration: BoxDecoration(
              color: line.lineColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 1, left: 2, right: 2),
              child: Text(
                line.lineName,
                style: TextStyle(
                  color: line.lineColor.computeLuminance() > 0.5
                      ? Colors.black
                      : Colors.white,
                  fontSize: 10,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
