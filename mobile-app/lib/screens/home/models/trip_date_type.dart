import 'package:easy_localization/easy_localization.dart';
import 'package:lisbon_travel/generated/locale_keys.g.dart';

enum TripDateType {
  now,
  leave,
  arrive;

  String get name {
    switch (this) {
      case TripDateType.now:
        return LocaleKeys.now.tr();
      case TripDateType.leave:
        return LocaleKeys.leave.tr();
      case TripDateType.arrive:
        return LocaleKeys.arrive.tr();
    }
  }
}
