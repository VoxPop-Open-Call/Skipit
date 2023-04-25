# Lisbon Travel

Lisbon Travel is a Flutter app that empowers disabled tourists to use public transport in Lisbon.
The app allows users to search for public transport routes based on their current location or a
manually entered location, and displays the route on a map.

## Getting started

To run the application, follow these steps:

1. Make sure flutter is installed. If
   not, [follow this] (https://docs.flutter.dev/get-started/install).
2. Clone the repository to your local machine.
3. Run `flutter pub get` to install dependencies.
4. Copy and Rename the `.env.example` file to `.env` and add your Google Maps API key.
5. To create the required files, run the commands below.
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   flutter pub run easy_localization:generate -f keys -S i18n -s en.json -o locale_keys.g.dart
   ```
6. Run the app using `flutter run --dart-define MAPS_API_KEY=""`.

**Note:** You will need a Google Maps API key to use this app.

## How to get Google Maps API Key

1. Go to [Google Developers Console](https://console.cloud.google.com/).
2. Choose the project that you want to enable Google Maps on.
3. Select the navigation menu and then select "Google Maps".
4. Select "APIs" under the Google Maps menu.
5. To enable Google Maps for Android, select "Maps SDK for Android" in the "Additional APIs"
   section, then select "ENABLE".
6. To enable Google Maps for iOS, select "Maps SDK for iOS" in the "Additional APIs" section, then
   select "ENABLE".
7. Make sure the APIs you enabled are under the "Enabled APIs" section.

## Supported Platforms

- Android
- iOS

## Overview

1. **Home** - /lib/screens/home<br>
   This is the initial view for the app when it opens up. It shows a large map with a search bar and
   a settings button. The main functionality of the app is here. Users can search for a
   destination (and origin) and plan their trip. They can also view stations along the way. There is
   also a trip overview shown after the user clicks on a trip, which contains all the information
   about the route and station, as well as accessibility data for each station.

3. **Settings** - /lib/screens/settings<br>
   Settings Page

4. **Transport Maps** - /lib/screens/transport_maps<br>
   Transport Maps Page

5. **Station Accessibility** - /lib/screens/...<br>
   Station Accessibility Page

## Update translation files

1. Open `en.json` file
2. Consider a good name for it and put the text in the value.
3. Run the below command to generate a key in `LocaleKeys` class.
   ```shell  
   flutter pub run easy_localization:generate -f keys -S i18n -o locale_keys.g.dart  
   ```
4. Use it in the code (like `LocaleKeys.xyz.tr()` or `LocaleKeys.xyz.plural(4)`)

## Supporting another language

1. Copy the `i18n/en.json` and paste it in the same directory
2. Change the name of the file to desire language code.
3. Open `main_common.dart` file and add it to `supportedLocales`.
4. Open `info.plist` file and add it to `CFBundleLocalizations` array.
5. Open `languages_names_constants.dart` file and add it's flag to `languageFlags`.