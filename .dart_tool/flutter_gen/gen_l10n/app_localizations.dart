import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
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
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
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

  /// No description provided for @addOneDatabase.
  ///
  /// In en, this message translates to:
  /// **'Add one'**
  String get addOneDatabase;

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

  /// No description provided for @attempts.
  ///
  /// In en, this message translates to:
  /// **'attempts'**
  String get attempts;

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

  /// No description provided for @autoplayAudio.
  ///
  /// In en, this message translates to:
  /// **'Play audio automatically'**
  String get autoplayAudio;

  /// No description provided for @autoplayAudioInfo.
  ///
  /// In en, this message translates to:
  /// **'Play audio automatically when open the player'**
  String get autoplayAudioInfo;

  /// No description provided for @autoplayVideo.
  ///
  /// In en, this message translates to:
  /// **'Play video automatically'**
  String get autoplayVideo;

  /// No description provided for @autoplayVideoInfo.
  ///
  /// In en, this message translates to:
  /// **'Play video automatically when open the player'**
  String get autoplayVideoInfo;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @cannotOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Cannot open the app settings.\nThe requested permission cannot be granted.\nYou need grant the permission manually in the app settings.'**
  String get cannotOpenSettings;

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

  /// No description provided for @closeExplorer.
  ///
  /// In en, this message translates to:
  /// **'Close explorer'**
  String get closeExplorer;

  /// No description provided for @college.
  ///
  /// In en, this message translates to:
  /// **'School of Computer Engineering'**
  String get college;

  /// No description provided for @commonName.
  ///
  /// In en, this message translates to:
  /// **'Common name'**
  String get commonName;

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

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @correct.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get correct;

  /// No description provided for @current.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get current;

  /// No description provided for @customLocationMode.
  ///
  /// In en, this message translates to:
  /// **'Custom location mode'**
  String get customLocationMode;

  /// No description provided for @customLocationModeString.
  ///
  /// In en, this message translates to:
  /// **'Tap on the map to select a location'**
  String get customLocationModeString;

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

  /// No description provided for @deletePermanentlyTWarning.
  ///
  /// In en, this message translates to:
  /// **'Warning: This action will also delete it from your device\'s storage.'**
  String get deletePermanentlyTWarning;

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

  /// No description provided for @docGeneratedBy.
  ///
  /// In en, this message translates to:
  /// **'Document generated with'**
  String get docGeneratedBy;

  /// No description provided for @encyclopedia.
  ///
  /// In en, this message translates to:
  /// **'Encyclopedia'**
  String get encyclopedia;

  /// No description provided for @encyclopediaExp.
  ///
  /// In en, this message translates to:
  /// **'Encyclopedia where you can search for species and consult their characteristics'**
  String get encyclopediaExp;

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

  /// No description provided for @environment.
  ///
  /// In en, this message translates to:
  /// **'Environment'**
  String get environment;

  /// No description provided for @environmentExp.
  ///
  /// In en, this message translates to:
  /// **'Let\'s take care of it. It is our home'**
  String get environmentExp;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @errorReadingQr.
  ///
  /// In en, this message translates to:
  /// **'No compatible information has been detected in the QR code.'**
  String get errorReadingQr;

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

  /// No description provided for @exportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export as PDF document'**
  String get exportPdf;

  /// No description provided for @exportPdfText.
  ///
  /// In en, this message translates to:
  /// **'(The information for this species will be exported as a PDF document and saved in the Downloads folde on your device)'**
  String get exportPdfText;

  /// No description provided for @exportPdfDone.
  ///
  /// In en, this message translates to:
  /// **'PDF document exported successfully'**
  String get exportPdfDone;

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

  /// No description provided for @fileNotFound.
  ///
  /// In en, this message translates to:
  /// **'File not found'**
  String get fileNotFound;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @game.
  ///
  /// In en, this message translates to:
  /// **'Game'**
  String get game;

  /// No description provided for @games.
  ///
  /// In en, this message translates to:
  /// **'Games'**
  String get games;

  /// No description provided for @gameSelectSNameFromCName.
  ///
  /// In en, this message translates to:
  /// **'Select the scientific name from the common name'**
  String get gameSelectSNameFromCName;

  /// No description provided for @gameSelectImageFromCName.
  ///
  /// In en, this message translates to:
  /// **'Select the image from the common name'**
  String get gameSelectImageFromCName;

  /// No description provided for @gameSelectCNameFromSound.
  ///
  /// In en, this message translates to:
  /// **'Select the common name from the sound'**
  String get gameSelectCNameFromSound;

  /// No description provided for @go.
  ///
  /// In en, this message translates to:
  /// **'Go'**
  String get go;

  /// No description provided for @gpsMode.
  ///
  /// In en, this message translates to:
  /// **'GPS mode'**
  String get gpsMode;

  /// No description provided for @grantPermissionManually.
  ///
  /// In en, this message translates to:
  /// **'Grant required app permissions manually'**
  String get grantPermissionManually;

  /// No description provided for @guatini.
  ///
  /// In en, this message translates to:
  /// **'Guatiní'**
  String get guatini;

  /// No description provided for @guatiniExp.
  ///
  /// In en, this message translates to:
  /// **'An extensionist project dedicated to enhance the development of general and environmental culture'**
  String get guatiniExp;

  /// No description provided for @habitat.
  ///
  /// In en, this message translates to:
  /// **'Habitat'**
  String get habitat;

  /// No description provided for @hits.
  ///
  /// In en, this message translates to:
  /// **'hits'**
  String get hits;

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

  /// Hits in a row
  ///
  /// In en, this message translates to:
  /// **'{hits} in a row'**
  String inARow(int hits);

  /// No description provided for @incorrect.
  ///
  /// In en, this message translates to:
  /// **'Incorrect'**
  String get incorrect;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @internalStorage.
  ///
  /// In en, this message translates to:
  /// **'Internal storage'**
  String get internalStorage;

  /// No description provided for @itIs.
  ///
  /// In en, this message translates to:
  /// **'It is'**
  String get itIs;

  /// No description provided for @itIsNot.
  ///
  /// In en, this message translates to:
  /// **'It is not'**
  String get itIsNot;

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

  /// No description provided for @levelUp.
  ///
  /// In en, this message translates to:
  /// **'Level up'**
  String get levelUp;

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

  /// No description provided for @locationMode.
  ///
  /// In en, this message translates to:
  /// **'Location mode'**
  String get locationMode;

  /// No description provided for @map.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get map;

  /// No description provided for @moreOf.
  ///
  /// In en, this message translates to:
  /// **'More of'**
  String get moreOf;

  /// No description provided for @moreWith.
  ///
  /// In en, this message translates to:
  /// **'More with'**
  String get moreWith;

  /// No description provided for @nearThreataned.
  ///
  /// In en, this message translates to:
  /// **'Near threataned'**
  String get nearThreataned;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @noCameraPermission.
  ///
  /// In en, this message translates to:
  /// **'Guatiní has not permission to access to camera'**
  String get noCameraPermission;

  /// No description provided for @noFolders.
  ///
  /// In en, this message translates to:
  /// **'No folders'**
  String get noFolders;

  /// It is not in the database
  ///
  /// In en, this message translates to:
  /// **'The information \"{info}\" is not in the database'**
  String noInDb(String info);

  /// No description provided for @noLocationEnabled.
  ///
  /// In en, this message translates to:
  /// **'You must turn on location'**
  String get noLocationEnabled;

  /// No description provided for @noLocationPermission.
  ///
  /// In en, this message translates to:
  /// **'Guatiní has not permission to access to location'**
  String get noLocationPermission;

  /// No description provided for @noSelectedDatabase.
  ///
  /// In en, this message translates to:
  /// **'There is not a selected database'**
  String get noSelectedDatabase;

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

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'There are no results'**
  String get noResults;

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

  /// No description provided for @ofde.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get ofde;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @onlineAudio.
  ///
  /// In en, this message translates to:
  /// **'Online audio'**
  String get onlineAudio;

  /// No description provided for @onlineImage.
  ///
  /// In en, this message translates to:
  /// **'Online image'**
  String get onlineImage;

  /// No description provided for @onlineUse.
  ///
  /// In en, this message translates to:
  /// **'Online use'**
  String get onlineUse;

  /// No description provided for @onlineVideo.
  ///
  /// In en, this message translates to:
  /// **'Online video'**
  String get onlineVideo;

  /// No description provided for @onlineUseText.
  ///
  /// In en, this message translates to:
  /// **'Use of información from internet'**
  String get onlineUseText;

  /// No description provided for @openQrReader.
  ///
  /// In en, this message translates to:
  /// **'Open QR reader'**
  String get openQrReader;

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

  /// No description provided for @players.
  ///
  /// In en, this message translates to:
  /// **'Players'**
  String get players;

  /// No description provided for @previousFolder.
  ///
  /// In en, this message translates to:
  /// **'Go to previous folder'**
  String get previousFolder;

  /// No description provided for @qrReader.
  ///
  /// In en, this message translates to:
  /// **'QR reader'**
  String get qrReader;

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

  /// No description provided for @scientificName.
  ///
  /// In en, this message translates to:
  /// **'Scientific name'**
  String get scientificName;

  /// No description provided for @sdCard.
  ///
  /// In en, this message translates to:
  /// **'SD card'**
  String get sdCard;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchHistotySize.
  ///
  /// In en, this message translates to:
  /// **'Search history size'**
  String get searchHistotySize;

  /// No description provided for @searchOnEcured.
  ///
  /// In en, this message translates to:
  /// **'Search on Ecured'**
  String get searchOnEcured;

  /// No description provided for @searchOnWikipedia.
  ///
  /// In en, this message translates to:
  /// **'Search on Wikipedia'**
  String get searchOnWikipedia;

  /// No description provided for @searchSpecies.
  ///
  /// In en, this message translates to:
  /// **'Search Species'**
  String get searchSpecies;

  /// No description provided for @selectLocationMode.
  ///
  /// In en, this message translates to:
  /// **'Please, select location mode'**
  String get selectLocationMode;

  /// No description provided for @selectMode.
  ///
  /// In en, this message translates to:
  /// **'Select mode'**
  String get selectMode;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @showSearchOnEcured.
  ///
  /// In en, this message translates to:
  /// **'Show \"Search on Ecured\"'**
  String get showSearchOnEcured;

  /// No description provided for @showSearchOnWikipedia.
  ///
  /// In en, this message translates to:
  /// **'Show \"Search on Wikipedia\"'**
  String get showSearchOnWikipedia;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @sound.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get sound;

  /// No description provided for @sourceOfInfo.
  ///
  /// In en, this message translates to:
  /// **'Source of information'**
  String get sourceOfInfo;

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

  /// No description provided for @ui.
  ///
  /// In en, this message translates to:
  /// **'User interface'**
  String get ui;

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

  /// No description provided for @unknownInfo.
  ///
  /// In en, this message translates to:
  /// **'Cannot be processed if the information is unknown'**
  String get unknownInfo;

  /// No description provided for @useExternalBrowser.
  ///
  /// In en, this message translates to:
  /// **'Use external browser instead in-app browser'**
  String get useExternalBrowser;

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

  /// No description provided for @withDimorphism.
  ///
  /// In en, this message translates to:
  /// **'There may be appreciable differences between the female and the male of this species'**
  String get withDimorphism;

  /// No description provided for @withoutDimorphism.
  ///
  /// In en, this message translates to:
  /// **'There are no appreciable differences between the female and the male of this species'**
  String get withoutDimorphism;

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
