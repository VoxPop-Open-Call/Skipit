part of 'transit_option_bloc.dart';

@freezed
class TransitOptionState with _$TransitOptionState {
  const factory TransitOptionState.initial() = _Initial;

  const factory TransitOptionState.searching() = _Searching;

  const factory TransitOptionState.returned(
    List<TransitOption> results,
  ) = _Returned;

  const factory TransitOptionState.error(
    String? error,
  ) = _Error;
}
