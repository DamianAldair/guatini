import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:guatini/main.dart';
import 'package:guatini/util/parse.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const locales = AppLocalizations.supportedLocales;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).language),
      ),
      body: ListView.builder(
        itemCount: locales.length,
        itemBuilder: (BuildContext context, int index) {
          final locale = locales[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text(locale.languageCode),
            ),
            title: Text(parseLanguageCode(locale.languageCode)),
            trailing: Icon(
                AppLocalizations.of(context).localeName == locale.languageCode
                    ? Icons.radio_button_on
                    : Icons.radio_button_off),
            onTap: () => MyApp.of(context)!.setLocale(locale),
          );
        },
      ),
    );
  }
}
