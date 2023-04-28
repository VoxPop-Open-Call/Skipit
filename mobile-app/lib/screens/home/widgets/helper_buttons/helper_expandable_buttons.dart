import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lisbon_travel/constants/colors.dart';
import 'package:lisbon_travel/generated/locale_keys.g.dart';
import 'package:lisbon_travel/screens/transit_search/view/transit_search_screen.dart';
import 'package:lisbon_travel/screens/transport_map/view/transport_map_screen.dart';
import 'package:lisbon_travel/utils/icons/custom_accessibility_icons.dart';
import 'package:lisbon_travel/utils/icons/info_bar_icon_icons.dart';
import 'package:lisbon_travel/widgets/expandable_button.dart';

class HelperExpandableButtons extends StatefulWidget {
  const HelperExpandableButtons({super.key});

  @override
  State<HelperExpandableButtons> createState() =>
      _HelperExpandableButtonsState();
}

class _HelperExpandableButtonsState extends State<HelperExpandableButtons> {
  final _animationDuration = const Duration(milliseconds: 250);
  bool show = false;

  @override
  Widget build(BuildContext context) {
    final baseButtonSize = MediaQuery.of(context).size.width * 0.1;
    return Stack(
      alignment: Alignment.bottomRight,
      clipBehavior: Clip.none,
      children: <Widget>[
        SizedBox(
          height: (baseButtonSize * 4) + (baseButtonSize * 0.3 * 4),
          width: baseButtonSize * 3 + 0.6,
        ),
        ExpandableButton(
          text: LocaleKeys.accessibility.tr(),
          duration: _animationDuration,
          size: show ? baseButtonSize : 0,
          baseSize: baseButtonSize,
          icon: CustomAccessibilityIcons.wheelchair,
          index: 2,
          show: show,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const TransitSearchScreen();
              },
            ),
          ),
        ),
        ExpandableButton(
          text: LocaleKeys.transportMaps.tr(),
          duration: _animationDuration,
          size: show ? baseButtonSize : 0,
          baseSize: baseButtonSize,
          icon: CustomAccessibilityIcons.transport_maps,
          index: 1,
          show: show,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const TransportMapScreen();
              },
            ),
          ),
        ),
        // ======== Main Button ========
        AnimatedPositioned(
          duration: _animationDuration,
          bottom: 0,
          child: GestureDetector(
            onTap: () {
              setState(() {
                show = !show;
              });
            },
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(5),
              elevation: 1,
              child: AnimatedContainer(
                duration: _animationDuration,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: show ? Colors.pink : Colors.white,
                ),
                height: baseButtonSize,
                width: baseButtonSize,
                child: AnimatedSwitcher(
                  duration: _animationDuration,
                  child: Icon(
                    show ? Icons.close : InfoBarIcon.union_2,
                    key: ValueKey<bool>(show),
                    color: show ? Colors.white : AppColors.primaryButton,
                    size: baseButtonSize * (show ? 0.8 : 0.95) / 1.5,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
