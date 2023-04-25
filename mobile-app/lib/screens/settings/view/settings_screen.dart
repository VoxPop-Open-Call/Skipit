import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lisbon_travel/generated/locale_keys.g.dart';
import 'package:lisbon_travel/utils/languages_name_constant.dart';
import 'package:lisbon_travel/widgets/item_picker_page.dart';
import 'package:lisbon_travel/widgets/setting/settings_category.dart';
import 'package:lisbon_travel/widgets/setting/simple_setting_option.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.settings.tr()),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),
          // SettingsCategory(
          //   name: LocaleKeys.accessibility.tr(),
          //   options: [],
          // ),
          SettingsCategory(
            name: LocaleKeys.more.tr(),
            options: <Widget>[
              ClassicSettingsOption(
                name: LocaleKeys.language.tr(),
                trailingText:
                    '${languageFlags[context.locale.languageCode] ?? ''} '
                    '${languageNames[context.locale.languageCode] ?? context.locale.languageCode}',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ItemPickerPage<Locale>(
                      pageTitle: LocaleKeys.chooseLanguage.tr(),
                      items: context.supportedLocales,
                      itemToText: (locale) =>
                          '${languageFlags[locale.languageCode] ?? ''}  '
                          '${languageNames[locale.languageCode] ?? locale.languageCode}',
                      onItemSelected: (Locale locale) async {
                        if (locale != context.locale) {
                          await context.setLocale(locale);
                          final engine =
                              WidgetsFlutterBinding.ensureInitialized();
                          engine.performReassemble();
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
