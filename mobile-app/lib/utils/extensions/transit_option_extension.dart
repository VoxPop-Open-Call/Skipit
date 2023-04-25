import 'package:lisbon_travel/models/enums/transport_type_enum.dart';
import 'package:lisbon_travel/models/responses/transit_option.dart';
import 'package:lisbon_travel/utils/extensions/index.dart';

extension TransitOptionList on List<TransitOption> {
  TransitOption? findByTransit({
    required String name,
    TransportTypeEnum? type,
  }) {
    // if the type is available, we compare with the type as well
    // if the exact type wasn't there but the name is, we choose that one.
    // if multiple found, we only return the first one
    final stations = where((option) => option.name == name);
    if (type != null) {
      return stations.firstWhereOrNull(
            (option) => option.transportTypes.contains(type),
          ) ??
          stations.firstOrNull;
    } else {
      return stations.firstOrNull;
    }
  }

  TransitOption? findByTransitTypeTuple(TransitTypeTuple transitType) =>
      findByTransit(name: transitType.name, type: transitType.type);
}
