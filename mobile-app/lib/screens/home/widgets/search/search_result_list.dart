import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:animated_list_plus/transitions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lisbon_travel/constants/colors.dart';
import 'package:lisbon_travel/logic/bloc/search/search_bloc.dart';
import 'package:lisbon_travel/logic/bloc/trip/trip_bloc.dart';
import 'package:lisbon_travel/models/responses/place_autocomplete_prediction.dart';
import 'package:lisbon_travel/screens/home/models/slider_result_state.dart';

class SearchResultList extends StatelessWidget {
  const SearchResultList({
    required this.searchBloc,
    required this.resultState,
    this.onItemSelected,
    super.key,
  });

  final SearchBloc searchBloc;
  final SliderResultState resultState;
  final Function(PlaceAutocompletePrediction item)? onItemSelected;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      bloc: searchBloc,
      builder: (c, state) {
        return state.map(
          searching: (_) => const Center(
            child: CircularProgressIndicator(),
          ),
          returned: (returned) {
            return ImplicitlyAnimatedList<PlaceAutocompletePrediction>(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              items: returned.result ?? (returned.history ?? []),
              areItemsTheSame: (a, b) => a == b,
              itemBuilder: (_, animation, place, i) {
                return SizeFadeTransition(
                  animation: animation,
                  child: _SearchResultItem(
                    place: place,
                    isRecentSearch: returned.result == null,
                    onTap: (place) => _onTap(context, place),
                  ),
                );
              },
              updateItemBuilder: (_, animation, place) {
                return FadeTransition(
                  opacity: animation,
                  child: _SearchResultItem(
                    place: place,
                    isRecentSearch: returned.result == null,
                    onTap: (place) => _onTap(context, place),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _onTap(BuildContext context, PlaceAutocompletePrediction place) {
    final tripBloc = context.read<TripBloc>();
    final isDestination = resultState == SliderResultState.destination;

    onItemSelected?.call(place);

    searchBloc.add(SearchEvent.addSearchHistory(place));
    if (isDestination) {
      tripBloc.add(TripEvent.setPoint(destination: place));
    } else {
      tripBloc.add(TripEvent.setPoint(origin: place));
    }
  }
}

class _SearchResultItem extends StatelessWidget {
  final PlaceAutocompletePrediction place;
  final bool isRecentSearch;
  final Function(PlaceAutocompletePrediction prediction) onTap;

  const _SearchResultItem({
    Key? key,
    required this.place,
    required this.isRecentSearch,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(place),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 36,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: isRecentSearch
                    ? const Icon(
                        Icons.history,
                        color: AppColors.textGrey,
                      )
                    : const Icon(Icons.place),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.description,
                    style: TextStyle(
                      color: isRecentSearch ? AppColors.textGrey : Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
