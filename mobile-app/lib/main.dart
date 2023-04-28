import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:lisbon_travel/api_service/dio_provider.dart';
import 'package:lisbon_travel/constants/constants.dart';
import 'package:lisbon_travel/constants/supported.dart';
import 'package:lisbon_travel/env/env.dart';
import 'package:lisbon_travel/logic/repository/google_direction_repository.dart';
import 'package:lisbon_travel/logic/repository/google_places_repository.dart';
import 'package:lisbon_travel/logic/repository/search_history_repository.dart';
import 'package:lisbon_travel/logic/repository/transit_option_repository.dart';
import 'package:lisbon_travel/logic/repository/transport_maps_repository.dart';
import 'package:lisbon_travel/logic/service/keyboard_manager.dart';
import 'package:lisbon_travel/logic/service/location_service.dart';
import 'package:lisbon_travel/logic/service/route_creator.dart';
import 'package:lisbon_travel/logic/service/settings_service.dart';
import 'package:lisbon_travel/logic/service/shared_pref_service.dart';
import 'package:lisbon_travel/logic/service/toast_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  DirectionsService.init(Env.mapsApiKey);

  await _registerServices();

  runApp(
    EasyLocalization(
      supportedLocales: supportedLanguages,
      path: 'i18n',
      fallbackLocale: const Locale('en'),
      useFallbackTranslations: true,
      useOnlyLangCode: true,
      saveLocale: true,
      child: const App(),
    ),
  );
}

Future<void> _registerServices() async {
  final getIt = GetIt.instance;

  // dio
  getIt.registerSingleton<Dio>(
    dio(
      baseUrl: kGooglePlacesBaseUrl,
      authAccessToken: Env.mapsApiKey,
      accessTokenProviderType: AccessTokenProviderType.query,
    ),
    instanceName: kGooglePlacesDioInstanceName,
  );
  getIt.registerSingleton<Dio>(
    dio(
      baseUrl: kTransportAccessibilityBaseUrl,
    ),
    instanceName: kTransportAccessibilityDioInstanceName,
  );

  // services
  getIt.registerSingleton<RouteCreator>(RouteCreator());
  getIt.registerSingleton<KeyboardManager>(KeyboardManager());
  getIt.registerSingleton<ToastManager>(ToastManager());
  getIt.registerSingleton<SharedPrefService>(
    SharedPrefService(
      sharedPreferences: await SharedPreferences.getInstance(),
    ),
  );
  getIt.registerSingleton<LocationService>(
    LocationService(),
    dispose: (s) => s.dispose(),
  );
  getIt.registerSingleton<SettingsService>(
    SettingsService(
      sharedPreferences: getIt<SharedPrefService>(),
    ),
  );

  // Repositories
  getIt.registerSingleton<GoogleDirectionRepository>(
    GoogleDirectionRemoteRepository(locationService: getIt<LocationService>()),
  );
  getIt.registerSingleton<GooglePlacesRepository>(
    GooglePlacesRemoteRepository(locationService: getIt<LocationService>()),
  );
  getIt.registerSingleton<SearchHistoryRepository>(
    SearchHistoryLocalRepository(
      preferencesService: getIt<SharedPrefService>(),
    ),
  );
  getIt.registerSingleton<TransportMapsRepository>(
    TransportMapsRemoteRepository(),
  );
  getIt.registerSingleton<TransitOptionRepository>(
    TransitOptionRemoteRepository(),
  );
}
