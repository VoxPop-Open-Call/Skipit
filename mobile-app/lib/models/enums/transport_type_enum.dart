import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lisbon_travel/generated/assets.gen.dart';
import 'package:lisbon_travel/generated/locale_keys.g.dart';

@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum TransportTypeEnum {
  train,
  tram,
  bus,
  metro,
  ferry;
}

extension TransportTypeEnumX on TransportTypeEnum {
  String get humanName {
    switch (this) {
      case TransportTypeEnum.train:
        return LocaleKeys.cTransportType_train.tr();
      case TransportTypeEnum.tram:
        return LocaleKeys.cTransportType_tram.tr();
      case TransportTypeEnum.bus:
        return LocaleKeys.cTransportType_bus.tr();
      case TransportTypeEnum.metro:
        return LocaleKeys.cTransportType_metro.tr();
      case TransportTypeEnum.ferry:
        return LocaleKeys.cTransportType_ferry.tr();
    }
  }

  String get pngIcon {
    switch (this) {
      case TransportTypeEnum.metro:
      case TransportTypeEnum.train:
        return Assets.mapIcons.train.path;
      case TransportTypeEnum.tram:
        return Assets.mapIcons.subwayIcon.path;
      case TransportTypeEnum.bus:
        return Assets.mapIcons.busIcon.path;
      case TransportTypeEnum.ferry:
        return Assets.mapIcons.boatIcon.path;
    }
  }

  IconData get icon {
    switch (this) {
      case TransportTypeEnum.train:
        return FontAwesomeIcons.train;
      case TransportTypeEnum.tram:
        return FontAwesomeIcons.trainTram;
      case TransportTypeEnum.bus:
        return FontAwesomeIcons.bus;
      case TransportTypeEnum.metro:
        return FontAwesomeIcons.trainSubway;
      case TransportTypeEnum.ferry:
        return FontAwesomeIcons.ferry;
    }
  }
}
