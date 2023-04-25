part of 'search_bloc.dart';

@freezed
class SearchEvent with _$SearchEvent {
  const factory SearchEvent.searchText(String query) = _SearchText;

  const factory SearchEvent.updateSearchHistory() = _UpdateSearchHistory;

  const factory SearchEvent.addSearchHistory(
    PlaceAutocompletePrediction prediction,
  ) = _AddSearchHistory;

  const factory SearchEvent.clearSearch() = _ClearSearch;
}
