import 'package:easy_localization/easy_localization.dart';

// ignore: depend_on_referenced_packages
import 'package:endless/endless.dart' show EndlessPaginationDelegate;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lisbon_travel/generated/locale_keys.g.dart';
import 'package:lisbon_travel/logic/bloc/transit_option/transit_option_bloc.dart';
import 'package:lisbon_travel/models/responses/transit_option.dart';
import 'package:paginated_search_bar/paginated_search_bar.dart';

class TransitSearchBar extends StatelessWidget {
  final Function(TransitOption transit)? onTransitSelected;

  const TransitSearchBar({
    super.key,
    this.onTransitSelected,
  });

  @override
  Widget build(BuildContext context) {
    final transitOptionBloc = context.read<TransitOptionBloc>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.topCenter,
          width: double.infinity,
          child: Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: const InputDecorationTheme(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
              ),
            ),
            child: PaginatedSearchBar<TransitOption>(
              maxHeight: MediaQuery.of(context).size.height * 0.3,
              hintText: LocaleKeys.search.tr(),
              autoFocus: true,
              padding: const EdgeInsets.symmetric(vertical: 6),
              itemPadding: 0,
              minSearchLength: 1,
              searchDebounceDuration: const Duration(milliseconds: 500),
              onSubmit: ({item, required searchQuery}) {
                if (item != null) onTransitSelected?.call(item);
              },
              emptyBuilder: (context) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: transitOptionBloc.state.maybeMap(
                    error: (state) => Text(
                      state.error ?? LocaleKeys.cError_oopsTryAgain.tr(),
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    searching: (_) => const SizedBox.shrink(),
                    orElse: () => Text(LocaleKeys.cError_nothingFound.tr()),
                  ),
                );
              },
              paginationDelegate: EndlessPaginationDelegate(
                pageSize: 10,
                maxPages: 1,
              ),
              onSearch: ({
                required pageIndex,
                required pageSize,
                required searchQuery,
              }) async {
                transitOptionBloc.add(TransitOptionEvent.query(searchQuery));
                await transitOptionBloc.stream.firstWhere(
                  (state) => state.maybeMap(
                    searching: (_) => false,
                    orElse: () => true,
                  ),
                );
                return transitOptionBloc.state.maybeMap<List<TransitOption>>(
                  returned: (value) => value.results,
                  orElse: () => [],
                );
              },
              itemBuilder: (
                context, {
                required item,
                required index,
              }) {
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      onTransitSelected?.call(item);
                    },
                    child: Ink(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Text(
                        item.name,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
