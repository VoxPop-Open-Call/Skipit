part of 'transit_option_bloc.dart';

@freezed
class TransitOptionEvent with _$TransitOptionEvent {
  const factory TransitOptionEvent.query(
    String query,
  ) = _Query;

  const factory TransitOptionEvent.getTransitOptions(
    List<String> transitNames,
  ) = _GetTransitOptions;
}
