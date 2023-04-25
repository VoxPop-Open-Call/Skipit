import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lisbon_travel/constants/colors.dart';
import 'package:lisbon_travel/generated/locale_keys.g.dart';
import 'package:lisbon_travel/logic/bloc/search/search_bloc.dart';
import 'package:lisbon_travel/widgets/location_search_field.dart';

class CurrentBar extends StatelessWidget {
  const CurrentBar({
    this.searchBloc,
    this.focusNode,
    this.onClear,
    required this.controller,
    super.key,
  });

  final TextEditingController controller;
  final SearchBloc? searchBloc;
  final FocusNode? focusNode;
  final Function()? onClear;

  @override
  Widget build(BuildContext context) {
    return LocationSearchField(
      controller: controller,
      focusNode: focusNode,
      hint: LocaleKeys.currentLocation.tr(),
      leadingIcon: Container(
        width: 55,
        padding: const EdgeInsets.only(left: 4),
        child: Text(
          LocaleKeys.from.tr(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColors.primary,
          ),
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
