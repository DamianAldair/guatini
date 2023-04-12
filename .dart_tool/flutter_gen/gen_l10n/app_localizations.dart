
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations returned
/// by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// localizationDelegates list, and the locales they support in the app's
/// supportedLocales list. For example:
///
/// ```
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @abundance.
  ///
  /// In en, this message translates to:
  /// **'Abundance'**
  String get abundance;

  /// No description provided for @activity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activity;

  /// No description provided for @addDatabase.
  ///
  /// In en, this message translates to:
  /// **'Add database from storage'**
  String get addDatabase;

  /// No description provided for @added.
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get added;

  /// No description provided for @addedDatabase.
  ///
  /// In en, this message translates to:
  /// **'Added database'**
  String get addedDatabase;

  /// No description provided for @alreadyAdded.
  ///
  /// In en, this message translates to:
  /// **'This database is already added'**
  String get alreadyAdded;

  /// No description provided for @audio.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get audio;

  /// No description provided for @author.
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get author;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @chooseOne.
  ///
  /// In en, this message translates to:
  /// **'Choose one'**
  String get chooseOne;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @college.
  ///
  /// In en, this message translates to:
  /// **'College of Computer Engineering'**
  String get college;

  /// No description provided for @conservationStatus.
  ///
  /// In en, this message translates to:
  /// **'Conservation status'**
  String get conservationStatus;

  /// No description provided for @criticalEndangered.
  ///
  /// In en, this message translates to:
  /// **'Critical endangered'**
  String get criticalEndangered;

  /// No description provided for @current.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get current;

  /// No description provided for @database.
  ///
  /// In en, this message translates to:
  /// **'Databases'**
  String get database;

  /// No description provided for @databaseSelectedInfo.
  ///
  /// In en, this message translates to:
  /// **'The database language does not depend on the app language'**
  String get databaseSelectedInfo;

  /// Date
  ///
  /// In en, this message translates to:
  /// **'Date: {date}'**
  String date(DateTime date);

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @deficientData.
  ///
  /// In en, this message translates to:
  /// **'Deficient data'**
  String get deficientData;

  /// No description provided for @deletedDatabase.
  ///
  /// In en, this message translates to:
  /// **'Database permanently deleted'**
  String get deletedDatabase;

  /// No description provided for @deleteFromList.
  ///
  /// In en, this message translates to:
  /// **'Delete from list'**
  String get deleteFromList;

  /// No description provided for @deleteFromListText.
  ///
  /// In en, this message translates to:
  /// **'Delete from list?'**
  String get deleteFromListText;

  /// No description provided for @deleteList.
  ///
  /// In en, this message translates to:
  /// **'Delete list'**
  String get deleteList;

  /// No description provided for @deleteListText.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the list?'**
  String get deleteListText;

  /// No description provided for @deletePermanently.
  ///
  /// In en, this message translates to:
  /// **'Delete permanently'**
  String get deletePermanently;

  /// No description provided for @deletePermanentlyText.
  ///
  /// In en, this message translates to:
  /// **'Delete permanently?'**
  String get deletePermanentlyText;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @developedBy.
  ///
  /// In en, this message translates to:
  /// **'Developed by'**
  String get developedBy;

  /// No description provided for @diet.
  ///
  /// In en, this message translates to:
  /// **'Diet'**
  String get diet;

  /// No description provided for @endangered.
  ///
  /// In en, this message translates to:
  /// **'Endangered'**
  String get endangered;

  /// No description provided for @endemism.
  ///
  /// In en, this message translates to:
  /// **'Endemism'**
  String get endemism;

  /// No description provided for @errorObtainingInfo.
  ///
  /// In en, this message translates to:
  /// **'An error has occurred while obtaining the information'**
  String get errorObtainingInfo;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit the app?'**
  String get exit;

  /// No description provided for @exitText.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to exit the application?'**
  String get exitText;

  /// No description provided for @extinct.
  ///
  /// In en, this message translates to:
  /// **'Extinct'**
  String get extinct;

  /// No description provided for @extinctInTheWild.
  ///
  /// In en, this message translates to:
  /// **'Extinct in the wild'**
  String get extinctInTheWild;

  /// No description provided for @findDatabase.
  ///
  /// In en, this message translates to:
  /// **'Find database'**
  String get findDatabase;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @grantPermissionManually.
  ///
  /// In en, this message translates to:
  /// **'Grant required app permissions manually'**
  String get grantPermissionManually;

  /// No description provided for @habitat.
  ///
  /// In en, this message translates to:
  /// **'Habitat'**
  String get habitat;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @image.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get image;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageName.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageName;

  /// No description provided for @leastConcern.
  ///
  /// In en, this message translates to:
  /// **'Least concern'**
  String get leastConcern;

  /// No description provided for @license.
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get license;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @moreAudiosOf.
  ///
  /// In en, this message translates to:
  /// **'More audios of'**
  String get moreAudiosOf;

  /// No description provided for @morePhotosOf.
  ///
  /// In en, this message translates to:
  /// **'More photos of'**
  String get morePhotosOf;

  /// No description provided for @moreVideosOf.
  ///
  /// In en, this message translates to:
  /// **'More videos of'**
  String get moreVideosOf;

  /// No description provided for @moreAudiosWith.
  ///
  /// In en, this message translates to:
  /// **'More audios with'**
  String get moreAudiosWith;

  /// No description provided for @morePhotosWith.
  ///
  /// In en, this message translates to:
  /// **'More photos with'**
  String get morePhotosWith;

  /// No description provided for @moreVideosWith.
  ///
  /// In en, this message translates to:
  /// **'More videos with'**
  String get moreVideosWith;

  /// No description provided for @nearThreataned.
  ///
  /// In en, this message translates to:
  /// **'Near threataned'**
  String get nearThreataned;

  /// No description provided for @noStoragePermission.
  ///
  /// In en, this message translates to:
  /// **'Guatiní has not permission to access to storage'**
  String get noStoragePermission;

  /// No description provided for @notEvaluated.
  ///
  /// In en, this message translates to:
  /// **'Not evaluated'**
  String get notEvaluated;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @noDatabases.
  ///
  /// In en, this message translates to:
  /// **'No databases'**
  String get noDatabases;

  /// No description provided for @noRecentSearches.
  ///
  /// In en, this message translates to:
  /// **'There are no recent searches'**
  String get noRecentSearches;

  /// No description provided for @notSelected.
  ///
  /// In en, this message translates to:
  /// **'Not selected'**
  String get notSelected;

  /// No description provided for @numberItemsSearchHistory.
  ///
  /// In en, this message translates to:
  /// **'Number of items in the search history'**
  String get numberItemsSearchHistory;

  /// No description provided for @numberSeggestions.
  ///
  /// In en, this message translates to:
  /// **'Number of suggestions on Home'**
  String get numberSeggestions;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @previousFolder.
  ///
  /// In en, this message translates to:
  /// **'Go to previous folder'**
  String get previousFolder;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @replay.
  ///
  /// In en, this message translates to:
  /// **'Replay'**
  String get replay;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchSpecies.
  ///
  /// In en, this message translates to:
  /// **'Search Species'**
  String get searchSpecies;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @sound.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get sound;

  /// No description provided for @speciesDetails.
  ///
  /// In en, this message translates to:
  /// **'Species Details'**
  String get speciesDetails;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @taxClass.
  ///
  /// In en, this message translates to:
  /// **'Class'**
  String get taxClass;

  /// No description provided for @taxDomain.
  ///
  /// In en, this message translates to:
  /// **'Domain'**
  String get taxDomain;

  /// No description provided for @taxFamily.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get taxFamily;

  /// No description provided for @taxGenus.
  ///
  /// In en, this message translates to:
  /// **'Genus'**
  String get taxGenus;

  /// No description provided for @taxKingdom.
  ///
  /// In en, this message translates to:
  /// **'Kingdom'**
  String get taxKingdom;

  /// No description provided for @taxPhylum.
  ///
  /// In en, this message translates to:
  /// **'Phylum'**
  String get taxPhylum;

  /// No description provided for @taxOrder.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get taxOrder;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'No disponible'**
  String get unavailable;

  /// No description provided for @university.
  ///
  /// In en, this message translates to:
  /// **'Technological University of Havana'**
  String get university;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @video.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get video;

  /// No description provided for @vulnerable.
  ///
  /// In en, this message translates to:
  /// **'Vulnerable'**
  String get vulnerable;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
