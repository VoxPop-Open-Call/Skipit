import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lisbon_travel/generated/locale_keys.g.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewerScreen extends StatelessWidget {
  final String imageUrl;

  const ImageViewerScreen({
    required this.imageUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(iconTheme: const IconThemeData(color: Colors.black)),
      body: PhotoView(
        maxScale: PhotoViewComputedScale.covered * 3.0,
        minScale: PhotoViewComputedScale.contained,
        initialScale: PhotoViewComputedScale.contained,
        loadingBuilder: (context, event) {
          if (event == null) {
            return Center(
              child: Text(LocaleKeys.loading.tr()),
            );
          }

          final value = event.cumulativeBytesLoaded /
              (event.expectedTotalBytes ?? event.cumulativeBytesLoaded);
          return Center(
            child: SizedBox(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(value: value),
            ),
          );
        },
        backgroundDecoration: const BoxDecoration(color: Colors.white),
        imageProvider: NetworkImage(imageUrl),
      ),
    );
  }
}
