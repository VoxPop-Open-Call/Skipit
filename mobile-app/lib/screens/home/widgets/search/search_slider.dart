import 'dart:async';
import 'dart:io';

import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get_it/get_it.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:lisbon_travel/logic/bloc/map/map_bloc.dart';
import 'package:lisbon_travel/logic/bloc/search/search_bloc.dart';
import 'package:lisbon_travel/logic/bloc/trip/trip_bloc.dart';
import 'package:lisbon_travel/logic/repository/google_places_repository.dart';
import 'package:lisbon_travel/logic/repository/search_history_repository.dart';
import 'package:lisbon_travel/logic/service/keyboard_manager.dart';
import 'package:lisbon_travel/logic/service/location_service.dart';
import 'package:lisbon_travel/models/responses/place_autocomplete_prediction.dart';
import 'package:lisbon_travel/screens/home/models/slider_result_state.dart';
import 'package:lisbon_travel/screens/home/widgets/search/destination_bar.dart';
import 'package:lisbon_travel/screens/home/widgets/search/search_route_options.dart';
import 'package:lisbon_travel/utils/extensions/index.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'current_bar.dart';
import 'search_result_list.dart';

class SearchSlider extends StatefulWidget {
  const SearchSlider({Key? key}) : super(key: key);

  @override
  State<SearchSlider> createState() => _SearchSliderState();
}

class _SearchSliderState extends State<SearchSlider> {
  final _panelController = PanelController();
  late StreamSubscription<bool> _keyboardSubscription;

  SliderResultState currentResultState = SliderResultState.destination;
  bool isPanelOpen = false;

  final TextEditingController _currentController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final FocusNode _focusNodeCurrent = FocusNode();
  final FocusNode _focusNodeDestination = FocusNode();
  late SearchBloc searchBlocCurrent;
  late SearchBloc searchBlocDestination;

  late TripBloc tripBloc;

  @override
  void initState() {
    super.initState();
    tripBloc = context.read<TripBloc>();

    final searchHistoryRepository = GetIt.I<SearchHistoryRepository>();
    final googlePlacesRepository = GetIt.I<GooglePlacesRepository>();
    searchBlocDestination = SearchBloc(
      searchHistory: searchHistoryRepository,
      placesRepository: googlePlacesRepository,
    );
    searchBlocCurrent = SearchBloc(
      searchHistory: searchHistoryRepository,
      placesRepository: googlePlacesRepository,
    );

    _focusNodeCurrent.addListener(() {
      if (currentResultState != SliderResultState.current) {
        setState(() {
          currentResultState = SliderResultState.current;
        });
      }
    });
    _focusNodeDestination.addListener(_onDestinationFocused);
    _keyboardSubscription = KeyboardVisibilityController().onChange.listen(
      (bool visible) {
        if (visible) _onDestinationFocused();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TripBloc, TripState>(
      listener: (context, state) {
        state.whenOrNull(
          pointUpdated: (origin, destination, _) {
            if (origin != null &&
                _currentController.text != origin.description) {
              _currentController.text = origin.description;
            }
            if (destination != null &&
                _destinationController.text != destination.description) {
              _destinationController.text = destination.description;
            }
          },
        );
      },
      builder: (context, state) {
        return state.maybeMap(
          navigation: (_) {
            isPanelOpen = false;
            return const SizedBox();
          },
          orElse: () {
            return SlidingUpPanel(
              controller: _panelController,
              minHeight: 90 + (Platform.isIOS ? 9 : 0),
              maxHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).viewPadding.top -
                  75,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              onPanelSlide: (double pos) {
                if (pos <= 0.05) {
                  if (isPanelOpen) {
                    GetIt.I<KeyboardManager>().dismissKeyboard();
                    _focusNodeCurrent.unfocus();
                    _focusNodeDestination.unfocus();
                    setState(() {
                      isPanelOpen = false;
                    });
                  }
                } else if (pos >= 0.95) {
                  if (!isPanelOpen) {
                    setState(() {
                      isPanelOpen = true;
                    });
                  }
                }
              },
              panelBuilder: (ScrollController sc) {
                return SingleChildScrollView(
                  controller: sc,
                  child: Column(
                    children: [
                      const SizedBox(height: 9),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 30,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: const BorderRadius.all(
                                Radius.circular(12.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // "From" search bar
                      AnimatedSizeAndFade.showHide(
                        show: isPanelOpen,
                        fadeDuration: const Duration(milliseconds: 300),
                        sizeDuration: const Duration(milliseconds: 300),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: CurrentBar(
                            controller: _currentController,
                            searchBloc: searchBlocCurrent,
                            focusNode: _focusNodeCurrent,
                            onClear: () {
                              // set it to current location
                              tripBloc.add(
                                const TripEvent.clearPoints(origin: true),
                              );
                            },
                          ),
                        ),
                      ),
                      // "To/Destination" search bar
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.05,
                        ),
                        child: DestinationBar(
                          controller: _destinationController,
                          searchBloc: searchBlocDestination,
                          focusNode: _focusNodeDestination,
                          isPanelOpen: isPanelOpen,
                          onClear: () {
                            tripBloc.add(
                              const TripEvent.clearPoints(destination: true),
                            );
                            if (currentResultState ==
                                SliderResultState.showRoute) {
                              setState(() {
                                currentResultState =
                                    SliderResultState.destination;
                              });
                            }
                          },
                        ),
                      ),
                      AnimatedPadding(
                        duration: const Duration(milliseconds: 300),
                        padding: EdgeInsets.only(
                          bottom: isPanelOpen ? 8 : 26,
                        ),
                      ),
                      // Recent searches / Search suggestions
                      if (currentResultState == SliderResultState.current ||
                          currentResultState ==
                              SliderResultState.destination) ...{
                        const SizedBox(height: 6),
                        SearchResultList(
                          searchBloc:
                              currentResultState == SliderResultState.current
                                  ? searchBlocCurrent
                                  : searchBlocDestination,
                          resultState: currentResultState,
                          onItemSelected: (item) => _onSearchItemSelected(item),
                        ),
                      },
                      // Route result
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: currentResultState == SliderResultState.showRoute
                            ? AnimatedSize(
                                duration: const Duration(milliseconds: 200),
                                child: SearchRouteOptions(
                                  onRouteTapped: _onRouteTapped,
                                ),
                              )
                            : const SizedBox(),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _onDestinationFocused() {
    if (mounted && _focusNodeDestination.hasFocus) {
      try {
        _panelController.open();
      } catch (_) {}
      if (currentResultState != SliderResultState.destination) {
        setState(() {
          currentResultState = SliderResultState.destination;
        });
      }
    }
  }

  void _onSearchItemSelected(PlaceAutocompletePrediction item) {
    _focusNodeCurrent.unfocus();
    _focusNodeDestination.unfocus();
    GetIt.I<KeyboardManager>().dismissKeyboard();

    if (currentResultState == SliderResultState.current) {
      _currentController.text = item.description;
    } else {
      _destinationController.text = item.description;
    }

    // don't show results if destination is null
    final shouldShowDestination =
        currentResultState == SliderResultState.current &&
            tripBloc.state.maybeMap<bool>(
              pointUpdated: (state) => state.destination == null,
              initial: (_) => true,
              orElse: () => false,
            );
    Future.delayed(Duration.zero, () {
      setState(() {
        currentResultState = shouldShowDestination
            ? SliderResultState.destination
            : SliderResultState.showRoute;
      });
    });
    if (shouldShowDestination) {
      _focusNodeDestination.requestFocus();
    }
  }

  _onRouteTapped(DirectionsRoute currentRoute, TravelMode travelMode) {
    final mapBloc = context.read<MapBloc>();
    final locationService = GetIt.I<LocationService>();

    mapBloc.add(MapEvent.showRoute(currentRoute));
    tripBloc.add(TripEvent.startTrip(
      route: currentRoute,
      travelMode: travelMode,
    ));
    searchBlocCurrent.add(const SearchEvent.clearSearch());
    searchBlocDestination.add(const SearchEvent.clearSearch());
    _currentController.clear();
    _destinationController.clear();

    final focusLocation = locationService.position?.toLatLng() ??
        currentRoute.steps?.firstOrNull?.startLocation?.toLatLng();
    if (focusLocation != null) {
      mapBloc.add(MapEvent.setLocation(focusLocation, zoom: 17));
    }
  }

  @override
  void dispose() {
    _focusNodeCurrent.dispose();
    _focusNodeDestination.dispose();
    _keyboardSubscription.cancel();
    super.dispose();
  }
}
