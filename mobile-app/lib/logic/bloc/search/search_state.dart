part of 'search_bloc.dart';

@freezed
class SearchState with _$SearchState {
  const factory SearchState.searching() = _Searching;

  const factory SearchState.returned({
    List<PlaceAutocompletePrediction>? result,
    List<PlaceAutocompletePrediction>? history,
  }) = _Returned;
}
