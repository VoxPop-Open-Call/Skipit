import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';

String convert12To24hours(String time) {
  try {
    final date = DateFormat('h:mma').parse(time.toUpperCase());
    return DateFormat.Hm().format(date);
  } catch (e) {
    return time;
  }
}

Color hexToColor(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  Codec codec = await instantiateImageCodec(
    data.buffer.asUint8List(),
    targetWidth: width,
  );
  FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ImageByteFormat.png))!
      .buffer
      .asUint8List();
}

String secondsToMinuteText(num num, {bool showMinText = false}) {
  if (num < 90) {
    return '1 ${showMinText ? 'min' : ''}';
  } else {
    final minutes = (num / 60).round();
    return '$minutes ${showMinText ? 'mins' : ''}';
  }
}
