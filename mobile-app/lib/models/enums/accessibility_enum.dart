import 'package:easy_localization/easy_localization.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lisbon_travel/generated/assets.gen.dart';
import 'package:lisbon_travel/generated/locale_keys.g.dart';

@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum AccessibilityEnum {
  elevator,
  stairs,
  escalator,
  toilet,
  waitingRoom,
  bikeParking,
  ramp,
  wheelchairFriendly,
  disabledToilet,
  ticketPurchase,
  assistance;
}

extension AccessibilityEnumX on AccessibilityEnum {
  String get humanName {
    switch (this) {
      case AccessibilityEnum.elevator:
        return LocaleKeys.cAccessibility_elevator.tr();
      case AccessibilityEnum.stairs:
        return LocaleKeys.cAccessibility_stairs.tr();
      case AccessibilityEnum.escalator:
        return LocaleKeys.cAccessibility_escalator.tr();
      case AccessibilityEnum.toilet:
        return LocaleKeys.cAccessibility_toilet.tr();
      case AccessibilityEnum.waitingRoom:
        return LocaleKeys.cAccessibility_waitingRoom.tr();
      case AccessibilityEnum.bikeParking:
        return LocaleKeys.cAccessibility_bikeParking.tr();
      case AccessibilityEnum.ramp:
        return LocaleKeys.cAccessibility_ramp.tr();
      case AccessibilityEnum.wheelchairFriendly:
        return LocaleKeys.cAccessibility_wheelchairFriendly.tr();
      case AccessibilityEnum.disabledToilet:
        return LocaleKeys.cAccessibility_disabledToilet.tr();
      case AccessibilityEnum.ticketPurchase:
        return LocaleKeys.cAccessibility_ticketPurchase.tr();
      case AccessibilityEnum.assistance:
        return LocaleKeys.cAccessibility_assistance.tr();
    }
  }

  String get svgAsset {
    switch (this) {
      case AccessibilityEnum.elevator:
        return Assets.accessibilityIcons.elevator;
      case AccessibilityEnum.stairs:
        return Assets.accessibilityIcons.stairs;
      case AccessibilityEnum.escalator:
        return Assets.accessibilityIcons.escalator;
      case AccessibilityEnum.waitingRoom:
        return Assets.accessibilityIcons.waitingRoom;
      case AccessibilityEnum.bikeParking:
        return Assets.accessibilityIcons.bikeParking;
      case AccessibilityEnum.ramp:
        return Assets.accessibilityIcons.ramp;
      case AccessibilityEnum.wheelchairFriendly:
        return Assets.accessibilityIcons.wheelchairFriendly;
      case AccessibilityEnum.toilet:
      case AccessibilityEnum.disabledToilet:
        return Assets.accessibilityIcons.disabledToilet;
      case AccessibilityEnum.ticketPurchase:
        return Assets.accessibilityIcons.ticketPurchase;
      case AccessibilityEnum.assistance:
        return Assets.accessibilityIcons.assistance;
    }
  }
}
