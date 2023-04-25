import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:lisbon_travel/constants/colors.dart';
import 'package:lisbon_travel/constants/styles.dart';
import 'package:lisbon_travel/generated/assets.gen.dart';
import 'package:lisbon_travel/generated/locale_keys.g.dart';
import 'package:lisbon_travel/logic/bloc/trip/trip_bloc.dart';
import 'package:lisbon_travel/logic/service/settings_service.dart';
import 'package:lisbon_travel/models/trip_routes_model.dart';
import 'package:lisbon_travel/screens/home/models/trip_date_type.dart';
import 'package:lisbon_travel/utils/extensions/index.dart';
import 'package:lisbon_travel/widgets/trip_overview.dart';

class SearchRouteOptions extends StatefulWidget {
  final Function(DirectionsRoute route, TravelMode travelMode)? onRouteTapped;

  const SearchRouteOptions({super.key, this.onRouteTapped});

  @override
  State<SearchRouteOptions> createState() => _SearchRouteOptionsState();
}

class _SearchRouteOptionsState extends State<SearchRouteOptions>
    with TickerProviderStateMixin {
  final settings = GetIt.I<SettingsService>();
  late TripBloc _tripBloc;
  TripRouteModel? _tripRoute;
  TripRouteModel? _filteredTripRoute;
  TravelMode _currentTravelMode = TravelMode.transit;
  int selectedTransitIndex = 0;

  // time and date selection
  TripDateType _tripDateType = TripDateType.now;
  TimeOfDay? _selectedTime;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _tripBloc = BlocProvider.of<TripBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TripBloc, TripState>(
      bloc: _tripBloc,
      listener: (context, state) {
        state.mapOrNull(
          pointUpdated: (state) {
            selectedTransitIndex = 0;
            if (settings.options.filterBasedOnAccessibility) {
              _tripRoute = state.routes;
              _filteredTripRoute = _tripRoute?.filteredCopy;
            } else {
              _filteredTripRoute = _tripRoute = state.routes;
            }
          },
        );
      },
      builder: (BuildContext context, TripState tripState) {
        return tripState.maybeMap<Widget>(
          loading: (_) => Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          pointUpdated: (tripState) {
            final hasRoute =
                _filteredTripRoute?.transitRoutes?.isNotEmpty == true;
            final currentRoute = _getCurrentRoute();

            // check if we have any route available in the original request
            // if not, we don't need to show any toggle and options
            if (_tripRoute?.transitRoutes?.isNotEmpty != true) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(
                    MediaQuery.of(context).size.width * 0.05,
                  ),
                  child: Text(LocaleKeys.cError_noRoute.tr()),
                ),
              );
            }

            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: MediaQuery.of(context).size.width * 0.05,
              ),
              child: Column(
                children: [
                  if (hasRoute) ...{
                    _timeDateOptionsRow(
                      isLoading: tripState.maybeMap<bool>(
                        loading: (_) => true,
                        orElse: () => false,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _travelModeRow(),
                    const SizedBox(height: 14),
                    if (currentRoute != null)
                      TripOverview(
                        route: currentRoute,
                        tripType: _currentTravelMode,
                        onTap: () => widget.onRouteTapped?.call(
                          currentRoute,
                          _currentTravelMode,
                        ),
                      ),
                  } else ...{
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.05,
                        ),
                        child: Text(
                          LocaleKeys.cError_noAccessibleRoute.tr(),
                        ),
                      ),
                    ),
                  },
                  if (_currentTravelMode == TravelMode.transit) ...{
                    const SizedBox(height: 7),
                    _toggle(
                      value: settings.options.showAccessibility,
                      text: LocaleKeys.cToggle_stationAccessibility.tr(),
                      enabled: true,
                      onChanged: (value) async {
                        await settings.updateOptions(settings.options
                            .copyWith(showAccessibility: value));
                        setState(() {});

                        // if accessibility data is there, no need to get it again
                        // else, need to get accessibility data
                        if (value &&
                            _tripRoute?.transitOption?.isNotEmpty != true) {
                          _tripBloc.add(const TripEvent.setPoint());
                        }
                      },
                    ),
                    const SizedBox(height: 6),
                    _toggle(
                      value: settings.options.filterBasedOnAccessibility,
                      text: LocaleKeys.cToggle_onlyAccessible.tr(),
                      enabled: true,
                      onChanged: (value) async {
                        await settings.updateOptions(settings.options
                            .copyWith(filterBasedOnAccessibility: value));

                        // if accessibility data is there, no need to get it again
                        // else, need to get accessibility data
                        if (value) {
                          if (_tripRoute?.transitOption?.isNotEmpty != true) {
                            _tripBloc.add(const TripEvent.setPoint());
                          } else {
                            _filteredTripRoute = _tripRoute?.filteredCopy;
                          }
                        } else {
                          _filteredTripRoute = _tripRoute;
                        }

                        // reset index if it's different set of routes
                        if ((_filteredTripRoute?.transitRoutes?.length ?? -1) !=
                            (_tripRoute?.transitRoutes?.length ?? -1)) {
                          selectedTransitIndex = 0;
                        }
                        setState(() {});
                      },
                    ),
                  },
                  if (_currentTravelMode == TravelMode.transit &&
                      _filteredTripRoute?.transitRoutes != null &&
                      _filteredTripRoute!.transitRoutes!.length > 1) ...{
                    const SizedBox(height: 4),
                    _otherRoutesWidget(),
                  },
                  if (hasRoute) ...{
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        style: $styles.button.primaryTextButtonStyle,
                        onPressed: () {},
                        child: Text(
                          LocaleKeys.buyTicket.tr(),
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  }
                ],
              ),
            );
          },
          orElse: () => const SizedBox(),
        );
      },
    );
  }

  Widget _timeDateOptionsRow({required bool isLoading}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.width * 0.02,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.width * 0.1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width * 0.015,
                ),
                color: AppColors.backgroundGray,
              ),
              child: DropdownButton<TripDateType>(
                value: _tripDateType,
                icon: Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: MediaQuery.of(context).size.width * 0.05,
                    color: isLoading ? Colors.grey : Colors.black,
                  ),
                ),
                iconSize: 8,
                dropdownColor: Colors.white,
                style: const TextStyle(color: Colors.black),
                isExpanded: true,
                disabledHint: Center(
                  child: Text(
                    LocaleKeys.now.tr(),
                    textAlign: TextAlign.right,
                  ),
                ),
                underline: const SizedBox(),
                onChanged: isLoading
                    ? null
                    : (TripDateType? newValue) {
                        if (newValue != null && newValue != _tripDateType) {
                          if (newValue == TripDateType.now) {
                            _selectedDate = null;
                            _selectedTime = null;
                            _tripBloc.add(const TripEvent.setPoint());
                          }

                          setState(() {
                            _tripDateType = newValue;
                          });
                        }
                      },
                items: TripDateType.values
                    .map<DropdownMenuItem<TripDateType>>((time) {
                  return DropdownMenuItem<TripDateType>(
                    value: time,
                    child: Center(
                      child: Text(time.name, textAlign: TextAlign.right),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _tripDateType == TripDateType.now
                  ? const SizedBox()
                  : SizedBox(
                      key: const ValueKey('time'),
                      height: MediaQuery.of(context).size.width * 0.1,
                      width: double.infinity,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.width * 0.015,
                            ),
                          ),
                          backgroundColor: AppColors.backgroundGray,
                        ),
                        onPressed: _selectDate,
                        child: Text(
                          _selectedDate != null
                              ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year.toString().substring(2, 4)}'
                              : LocaleKeys.pickDate.tr(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _tripDateType == TripDateType.now
                  ? const SizedBox()
                  : SizedBox(
                      key: const ValueKey('time'),
                      height: MediaQuery.of(context).size.width * 0.1,
                      width: double.infinity,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.backgroundGray,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.width * 0.015,
                            ),
                          ),
                        ),
                        onPressed: _selectTime,
                        child: Text(
                          _selectedTime != null
                              ? '${_selectedTime!.hour}:${_selectedTime!.minute}'
                              : LocaleKeys.pickTime.tr(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    var newDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 60)),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.primary,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (newDate != null) {
      setState(() {
        _selectedDate = DateTime(
          newDate.year,
          newDate.month,
          newDate.day,
          _selectedTime?.hour ?? TimeOfDay.now().hour,
          _selectedTime?.minute ?? TimeOfDay.now().minute,
        );
      });

      _tripBloc.add(TripEvent.setPoint(
        dateTime: _selectedDate,
        tripDateType: _tripDateType,
      ));
    }
  }

  Future<void> _selectTime() async {
    var newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.input,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.primary,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    setState(() {
      if (newTime != null) {
        final now = DateTime.now();
        _selectedDate = DateTime(
          _selectedDate?.year ?? now.year,
          _selectedDate?.month ?? now.month,
          _selectedDate?.day ?? now.day,
          newTime.hour,
          newTime.minute,
        );
      }
    });

    _tripBloc.add(TripEvent.setPoint(
      dateTime: _selectedDate,
      tripDateType: _tripDateType,
    ));
  }

  Widget _otherRoutesWidget() {
    return Center(
      child: TextButton(
        onPressed: () async {
          final result = await showDialog<int?>(
            context: context,
            builder: (context) => selectRouteDialog(
              context,
              selectedTransitIndex,
            ),
          );
          if (result != null) {
            setState(() {
              selectedTransitIndex = result;
            });
          }
        },
        style: TextButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          LocaleKeys.otherRoutes.tr(),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget selectRouteDialog(BuildContext context, int selected) {
    List<DirectionsRoute> routes = List.of(_filteredTripRoute!.transitRoutes!);
    int selectedIndex = 0;
    DirectionsRoute selectedRoute;

    // move already selected route to the top
    final topRoute = routes.elementAt(selected);
    selectedRoute = topRoute;
    routes.removeAt(selected);

    return AlertDialog(
      insetPadding: const EdgeInsets.all(16),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(foregroundColor: Colors.black),
          child: Text(LocaleKeys.cancel.tr().toUpperCase()),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(
            _filteredTripRoute!.transitRoutes!.indexOf(selectedRoute),
          ),
          style: TextButton.styleFrom(foregroundColor: Colors.black),
          child: Text(LocaleKeys.ok.tr().toUpperCase()),
        )
      ],
      scrollable: true,
      title: Text(LocaleKeys.selectRoute.tr()),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.82,
        child: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              children: [
                RadioListTile(
                  contentPadding: const EdgeInsets.all(0),
                  visualDensity: VisualDensity.compact,
                  value: 0,
                  groupValue: selectedIndex,
                  onChanged: (_) {
                    setState(() {
                      selectedIndex = selected;
                      selectedRoute = topRoute;
                    });
                  },
                  activeColor: Colors.green,
                  title: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: TripOverview(
                      route: topRoute,
                      tripType: _currentTravelMode,
                      showWalkingTime: true,
                    ),
                  ),
                ),
                const Divider(height: 16, thickness: 1.5),
                ...List.generate(
                  routes.length,
                  (index) => RadioListTile(
                    contentPadding: const EdgeInsets.all(0),
                    visualDensity: VisualDensity.compact,
                    value: index + 1,
                    groupValue: selectedIndex,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedIndex = value;
                          selectedRoute = routes.elementAt(value - 1);
                        });
                      }
                    },
                    activeColor: Colors.green,
                    title: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: TripOverview(
                        route: routes.elementAt(index),
                        tripType: _currentTravelMode,
                        showWalkingTime: true,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _travelModeRow() {
    final hasBus = _filteredTripRoute?.transitRoutes?.isNotEmpty ?? false;
    final hasWalk = _filteredTripRoute?.walkingRoutes?.isNotEmpty ?? false;
    final hasBike = _filteredTripRoute?.cyclingRoutes?.isNotEmpty ?? false;

    return Row(
      children: [
        if (hasBus)
          Expanded(
            child: _travelModWidget(
              type: TravelMode.transit,
              icon: Assets.mapIcons.busIcon.path,
              duration: _filteredTripRoute?.transitRoutes?[selectedTransitIndex]
                  .legs?.firstOrNull?.duration?.value,
            ),
          ),
        const SizedBox(width: 10),
        Expanded(
          child: hasWalk
              ? _travelModWidget(
                  type: TravelMode.walking,
                  icon: Assets.mapIcons.walkIcon.path,
                  duration: _filteredTripRoute?.walkingRoutes?.firstOrNull?.legs
                      ?.firstOrNull?.duration?.value,
                )
              : const SizedBox(),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: hasBike
              ? _travelModWidget(
                  type: TravelMode.bicycling,
                  icon: Assets.mapIcons.bikeIcon.path,
                  duration: _filteredTripRoute?.cyclingRoutes?.firstOrNull?.legs
                      ?.firstOrNull?.duration?.value,
                )
              : const SizedBox(),
        ),
      ],
    );
  }

  Widget _travelModWidget({
    required String icon,
    required num? duration,
    required TravelMode type,
  }) {
    final selected = _currentTravelMode == type;
    return InkWell(
      onTap: () {
        setState(() {
          _currentTravelMode = type;
        });
      },
      child: AnimatedContainer(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        duration: const Duration(milliseconds: 220),
        decoration: BoxDecoration(
          color: AppColors.backgroundGray,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            width: 2,
            color: selected ? AppColors.primary : AppColors.backgroundGray,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Image.asset(
                  icon,
                  width: 30,
                  height: 30,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: duration != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${duration ~/ 60}',
                          style: TextStyle(
                            color: selected ? AppColors.primary : Colors.black,
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          LocaleKeys.mins.tr(),
                          style: TextStyle(
                            color: selected ? AppColors.primary : Colors.black,
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                          ),
                        )
                      ],
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toggle({
    required bool value,
    required String text,
    required Function(bool value)? onChanged,
    bool enabled = true,
  }) {
    return Material(
      color: Colors.transparent,
      child: SwitchListTile(
        value: value,
        title: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        dense: true,
        activeColor: AppColors.primary,
        onChanged: enabled ? onChanged : null,
      ),
    );
  }

  DirectionsRoute? _getCurrentRoute() {
    if (_filteredTripRoute == null) return null;

    if (_currentTravelMode == TravelMode.transit) {
      return _filteredTripRoute!.transitRoutes
          ?.elementAtOrNull(selectedTransitIndex);
    } else if (_currentTravelMode == TravelMode.walking) {
      return _filteredTripRoute!.walkingRoutes?.firstOrNull;
    } else if (_currentTravelMode == TravelMode.bicycling) {
      return _filteredTripRoute!.cyclingRoutes?.firstOrNull;
    }
    return null;
  }
}
