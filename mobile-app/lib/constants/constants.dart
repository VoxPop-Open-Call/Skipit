import 'package:google_maps_flutter/google_maps_flutter.dart';

const String kDefaultLanguage = 'en';
const LatLng kLisbonPosition = LatLng(38.7223, -9.1393);

// network
const String kGooglePlacesBaseUrl =
    'https://maps.googleapis.com/maps/api/place';
const String kTransportAccessibilityBaseUrl =
    'https://transport-accessibility-backend.azurewebsites.net/api';

// GetIt instances name
const String kGooglePlacesDioInstanceName = 'google_places_dio';
const String kTransportAccessibilityDioInstanceName =
    'transport_accessibility_dio';
