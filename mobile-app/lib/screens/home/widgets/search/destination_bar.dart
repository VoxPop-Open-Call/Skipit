import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lisbon_travel/constants/colors.dart';
import 'package:lisbon_travel/generated/locale_keys.g.dart';
import 'package:lisbon_travel/logic/bloc/search/search_bloc.dart';
import 'package:lisbon_travel/widgets/location_search_field.dart';

class DestinationBar extends StatelessWidget {
  const DestinationBar({
    Key? key,
    this.searchBloc,
    this.focusNode,
    this.onClear,
    required this.controller,
    required this.isPanelOpen,
  }) : super(key: key);

  final TextEditingController controller;
  final SearchBloc? searchBloc;
  final FocusNode? focusNode;
  final bool isPanelOpen;
  final Function()? onClear;

  @override
  Widget build(BuildContext context) {
    return LocationSearchField(
      controller: controller,
      hint: LocaleKeys.destination.tr(),
      focusNode: focusNode,
      isDestination: true,
      padding: EdgeInsets.zero,
      leadingIcon: isPanelOpen
          ? Container(
              width: 55,
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                LocaleKeys.to.tr(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.primary,
                ),
              ),
            )
          : const Padding(
              padding: EdgeInsets.only(bottom: 3),
              child: FaIcon(
                FontAwesomeIcons.locationDot,
                size: 23,
                color: AppColors.textGrey,
              ),
            ),
      onQueryChanged: (query) {
        searchBloc?.add(SearchEvent.searchText(query));
      },
      onClear: () {
        searchBloc?.add(const SearchEvent.clearSearch());
        onClear?.call();
      },
    );
  }
}
