import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:guatini/pages/main_page.dart';
import 'package:guatini/providers/appinfo_provider.dart';
import 'package:guatini/providers/userpreferences_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await AppInfo().initialize();
  await UserPreferences().initialize();
  runApp(const MyApp());
  FlutterNativeSplash.remove();
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  // ignore: library_private_types_in_public_api
  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final prefs = UserPreferences();

  void setLocale(Locale locale) => setState(() => prefs.locale = locale);

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData.light().copyWith(useMaterial3: true),
      dark: ThemeData.dark().copyWith(useMaterial3: true),
      initial: AdaptiveThemeMode.system,
      builder: (ThemeData light, ThemeData dark) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: prefs.locale,
          theme: light,
          darkTheme: dark,
          title: 'Guatiní',
          home: const MainPage(),
        );
      },
    );
  }
}
