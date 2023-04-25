import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lisbon_travel/models/enums/accessibility_enum.dart';
import 'package:lisbon_travel/models/enums/transport_type_enum.dart';

part 'transit_option.freezed.dart';

part 'transit_option.g.dart';

@freezed
class TransitOption with _$TransitOption {
  const factory TransitOption({
    required String id,
    required String name,
    required List<TransportTypeEnum> transportTypes,
    List<AccessibilityEnum>? accessibilities,
  }) = _TransitOption;

  factory TransitOption.fromJson(Map<String, dynamic> json) =>
      _$TransitOptionFromJson(json);
}

@freezed
class TransitTypeTuple with _$TransitTypeTuple {
  const factory TransitTypeTuple({
    required String name,
    TransportTypeEnum? type,
  }) = _TransitTypeTuple;

  factory TransitTypeTuple.fromJson(Map<String, dynamic> json) =>
      _$TransitTypeTupleFromJson(json);
}
