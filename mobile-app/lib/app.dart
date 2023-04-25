import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lisbon_travel/constants/colors.dart';
import 'package:lisbon_travel/logic/bloc/map/map_bloc.dart';
import 'package:lisbon_travel/logic/bloc/trip/trip_bloc.dart';
import 'package:lisbon_travel/logic/repository/google_direction_repository.dart';
import 'package:lisbon_travel/logic/repository/transit_option_repository.dart';
import 'package:lisbon_travel/logic/service/location_service.dart';
import 'package:lisbon_travel/logic/service/toast_manager.dart';
import 'package:lisbon_travel/screens/home/view/home_screen.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final getIt = GetIt.instance;

  @override
  void initState() {
    super.initState();
    getIt<ToastManager>().initialize(_scaffoldMessengerKey);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MapBloc()),
        BlocProvider(
          create: (_) => TripBloc(
            directionRepository: getIt<GoogleDirectionRepository>(),
            locationService: getIt<LocationService>(),
            transitOptionsRepository: getIt<TransitOptionRepository>(),
          ),
        )
      ],
      child: MaterialApp(
        scaffoldMessengerKey: _scaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        theme: AppColors.toTheme(),
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home: const HomeScreen(),
      ),
    );
  }
}
