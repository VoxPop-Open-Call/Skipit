import 'package:async_builder/async_builder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:lisbon_travel/constants/colors.dart';
import 'package:lisbon_travel/generated/locale_keys.g.dart';
import 'package:lisbon_travel/logic/repository/transport_maps_repository.dart';
import 'package:lisbon_travel/screens/image_viewer/view/image_viewer_screen.dart';
import 'package:lisbon_travel/screens/transport_map/widgets/transport_maps_carousel.dart';

class TransportMapScreen extends StatelessWidget {
  const TransportMapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.transportMaps.tr()),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AsyncBuilder(
                future: GetIt.I<TransportMapsRepository>().getAll(),
                retain: true,
                waiting: (context) => const CircularProgressIndicator(),
                builder: (context, value) {
                  if (value != null &&
                      value.isRight &&
                      value.right.data?.isNotEmpty == true) {
                    return TransportMapsCarousel(
                      maps: value.right.data!,
                      onMapSelected: (map) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ImageViewerScreen(
                              imageUrl: map.url,
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    String? error;
                    if (value == null || value.isRight) {
                      error = LocaleKeys.cError_noTransportMaps.tr();
                    } else if (value.isLeft) {
                      error = value.left.responseData?['message'];
                    }

                    return Text(
                      error ?? LocaleKeys.cError_oopsTryAgain.tr(),
                      style: const TextStyle(
                        color: AppColors.errorToast,
                        fontSize: 16,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
