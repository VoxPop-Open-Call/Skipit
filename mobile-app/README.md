# Lisbon Travel

Lisbon Travel is a Flutter app that empowers disabled tourists to use public transport in Lisbon.
The app allows users to search for public transport routes based on their current location or a
manually entered location, and displays the route on a map.

## Demo

<table>
  <tr>
    <td>
      <img width="500px" src="screenshots/Screenshot 1.png">
    </td>
    <td>
      <img width="500px" src="screenshots/Screenshot 2.png">
    </td>
    <td>
      <img width="500px" src="screenshots/Screenshot 3.png">
    </td>
  </tr>
  <tr>
    <td>
      <img width="500px" src="screenshots/Screenshot 4.png">
    </td>
    <td>
      <img width="500px" src="screenshots/Screenshot 5.png">
    </td>
</table>

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

2. **Settings** - /lib/screens/settings<br>
   Right now, there is only one option which is Language. It can also include more information
   related to Terms of Use, Privacy Policy, etc.

3. **Transport Maps** - /lib/screens/transport_maps<br>
   This page uses the API to get all transport maps related to Lisbon. It can show them in full
   screen and users can interact with it.

4. **Station Accessibility** - /lib/screens/transit_search<br>
   This page uses the API to search through all available stations and bus routes. After the search,
   users can select a station to see accessibility details.

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
3. Open `supported.dart` file and add it to `supportedLanguages`.
4. Open `info.plist` file and add it to `CFBundleLocalizations` array.
5. Open `language_names.dart` file and add it's flag to `languageFlags`.

## Payment

Right now, when clicking on the "Buy Ticket" button, it opens a webpage related to city-pass. In an
ideal scenario, it should open another page and pass the route. After that, it should connect to the
API and send all related information about the route. The API should return the price and a link so
users can pay for the ticket.
