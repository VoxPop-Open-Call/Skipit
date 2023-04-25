import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lisbon_travel/logic/repository/google_places_repository.dart';
import 'package:lisbon_travel/logic/repository/search_history_repository.dart';
import 'package:lisbon_travel/models/responses/place_autocomplete_prediction.dart';

part 'search_bloc.freezed.dart';

part 'search_event.dart';

part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchHistoryRepository _searchHistory;
  final GooglePlacesRepository _placesRepository;
  final int maxPredictions;
  String _lastQuery = '';

  SearchBloc({
    required SearchHistoryRepository searchHistory,
    required GooglePlacesRepository placesRepository,
    this.maxPredictions = 4,
  })  : _searchHistory = searchHistory,
        _placesRepository = placesRepository,
        super(const SearchState.searching()) {
    on<_SearchText>((event, emit) => _searchText(event, emit));
    on<_UpdateSearchHistory>(
        (event, emit) => _updateSearchHistory(event, emit));
    on<_AddSearchHistory>((event, emit) => _addSearchHistory(event, emit));
    on<_ClearSearch>((event, emit) => _clearSearch(event, emit));

    // initialize
    add(const SearchEvent.updateSearchHistory());
  }

  _searchText(_SearchText event, Emitter<SearchState> emit) async {
    if (event.query == _lastQuery) return;

    final oldState = state;
    if (event.query.isEmpty) {
      emit(
        oldState.map(
          searching: (_) => SearchState.returned(
            history: _searchHistory.getAll(),
          ),
          returned: (state) => state.copyWith(result: null),
        ),
      );
      return;
    }

    emit(const SearchState.searching());
    final response = await _placesRepository.getPlaceAutocomplete(event.query);
    if (response.isRight && response.right.data != null) {
      final searchResult = response.right.data!.take(maxPredictions).toList();
      _lastQuery = event.query;
      emit(oldState.map(
        searching: (_) => SearchState.returned(
          history: _searchHistory.getAll(),
          result: searchResult,
        ),
        returned: (state) => state.copyWith(result: searchResult),
      ));
    } else {
      emit(oldState.map(
        searching: (_) => SearchState.returned(
          history: _searchHistory.getAll(),
        ),
        returned: (state) => state,
      ));
    }
  }

  _updateSearchHistory(
    _UpdateSearchHistory event,
    Emitter<SearchState> emit,
  ) async {
    final history = _searchHistory.getAll();
    emit(state.map(
      searching: (_) => SearchState.returned(history: history),
      returned: (state) => state.copyWith(history: history),
    ));
  }

  _addSearchHistory(_AddSearchHistory event, Emitter<SearchState> emit) async {
    final inserted = await _searchHistory.insert(event.prediction);
    if (inserted) {
      final history = _searchHistory.getAll();
      emit(state.map(
        searching: (_) => SearchState.returned(history: history),
        returned: (state) => state.copyWith(history: history),
      ));
    }
  }

  _clearSearch(_ClearSearch event, Emitter<SearchState> emit) async {
    _lastQuery = '';
    emit(SearchState.returned(history: _searchHistory.getAll()));
  }
}
