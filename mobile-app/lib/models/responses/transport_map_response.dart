import 'package:freezed_annotation/freezed_annotation.dart';

part 'transport_map_response.freezed.dart';

part 'transport_map_response.g.dart';

@freezed
class TransportMapResponse with _$TransportMapResponse {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory TransportMapResponse({
    required String name,
    required String url,
    String? icon,
    String? thumbnailUrl,
  }) = _TransportMapResponse;

  factory TransportMapResponse.fromJson(Map<String, dynamic> json) =>
      _$TransportMapResponseFromJson(json);
}
