part of 'map_bloc.dart';

@freezed
class MapState with _$MapState {
  const factory MapState.loading() = _Initial;

  const factory MapState.loaded({
    required GoogleMapController controller,
    MapRoute? mapRoute,
  }) = _Loaded;
}
