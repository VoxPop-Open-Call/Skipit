import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:lisbon_travel/constants/colors.dart';
import 'package:lisbon_travel/models/responses/transport_map_response.dart';
import 'package:lisbon_travel/utils/extensions/index.dart';

class TransportMapsCarousel extends StatefulWidget {
  final List<TransportMapResponse> maps;
  final Function(TransportMapResponse map)? onMapSelected;

  const TransportMapsCarousel({
    Key? key,
    required this.maps,
    this.onMapSelected,
  }) : super(key: key);

  @override
  State<TransportMapsCarousel> createState() => _TransportMapsCarouselState();
}

class _TransportMapsCarouselState extends State<TransportMapsCarousel> {
  late TransportMapResponse current;

  @override
  void initState() {
    super.initState();
    if (widget.maps.isNotEmpty) {
      current = widget.maps.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.maps.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.maps.length,
          options: CarouselOptions(
            onPageChanged: (index, reason) {
              setState(() {
                current = widget.maps[index];
              });
            },
            height: MediaQuery.of(context).size.height * 0.52,
            enableInfiniteScroll: widget.maps.length <= 1 ? false : true,
            enlargeCenterPage: true,
          ),
          itemBuilder: (context, index, realIndex) {
            final item = widget.maps[index];
            return GestureDetector(
              onTap: () => widget.onMapSelected?.call(item),
              child: Stack(
                children: [
                  Material(
                    elevation: 3,
                    borderRadius: BorderRadius.circular(10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.75,
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Image.network(
                          item.thumbnailUrl ?? item.url,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 0,
                    child: Padding(
                      padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.05,
                      ),
                      child: Material(
                        elevation: 3,
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.01,
                          ),
                          child: Icon(
                            Icons.zoom_out_map,
                            size: MediaQuery.of(context).size.width * 0.08,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(10),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (current.icon != null &&
                          TransitVehicleType.values
                              .asNameMap()
                              .containsKey(current.icon!.toLowerCase())) ...{
                        Image.asset(
                          TransitVehicleType.values
                              .byName(current.icon!.toLowerCase())
                              .pngIcon,
                          width: 23,
                          height: 23,
                        ),
                        const SizedBox(width: 10),
                      },
                      Text(
                        current.name,
                        style: const TextStyle(
                          fontSize: 19,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        SizedBox(
          height: 14,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: List.generate(
              widget.maps.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 3.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index == widget.maps.indexOf(current)
                      ? AppColors.sliderDotActive
                      : AppColors.sliderDotInActive,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
