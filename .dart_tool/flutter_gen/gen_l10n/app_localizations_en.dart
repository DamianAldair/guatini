import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get about => 'About';

  @override
  String get abundance => 'Abundance';

  @override
  String get activity => 'Actividad';

  @override
  String get ad => 'Ad';

  @override
  String get addDatabase => 'Add data source from storage';

  @override
  String get addOneDatabase => 'Add one';

  @override
  String get added => 'Added';

  @override
  String get addedDatabase => 'Added data source';

  @override
  String get alreadyAdded => 'This data source is already added';

  @override
  String get attempts => 'attempts';

  @override
  String get audio => 'Audio';

  @override
  String get author => 'Author';

  @override
  String get autoplayAudio => 'Play audio automatically';

  @override
  String get autoplayAudioInfo => 'Play audio automatically when open the player';

  @override
  String get autoplayVideo => 'Play video automatically';

  @override
  String get autoplayVideoInfo => 'Play video automatically when open the player';

  @override
  String get back => 'Back';

  @override
  String get cannotOpenSettings => 'Cannot open the app settings.\nThe requested permission cannot be granted.\nYou need grant the permission manually in the app settings.';

  @override
  String get chooseOne => 'Choose one';

  @override
  String get clear => 'Clear';

  @override
  String get closeExplorer => 'Close explorer';

  @override
  String get college => 'School of Computer Engineering';

  @override
  String get commonName => 'Common name';

  @override
  String get conservationStatus => 'Conservation status';

  @override
  String get criticalEndangered => 'Critical endangered';

  @override
  String get copy => 'Copy';

  @override
  String get correct => 'Correct';

  @override
  String get correctAnswerIs => 'The correct answer is:';

  @override
  String get current => 'Current';

  @override
  String get customLocationMode => 'Custom location mode';

  @override
  String get customLocationModeString => 'Tap on the map to select a location';

  @override
  String get database => 'Data source';

  @override
  String get databaseSelectedInfo => 'The data source language does not depend on the app language';

  @override
  String date(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Date: $dateString';
  }

  @override
  String get dark => 'Dark';

  @override
  String get dbStructureNoCorrect => 'The data source structure is not correct';

  @override
  String get deficientData => 'Deficient data';

  @override
  String get deletedDatabase => 'Data source permanently deleted';

  @override
  String get deleteFromList => 'Delete from list';

  @override
  String get deleteFromListText => 'Delete from list?';

  @override
  String get deleteList => 'Delete list';

  @override
  String get deleteListText => 'Are you sure you want to delete the list?';

  @override
  String get deletePermanently => 'Delete permanently';

  @override
  String get deletePermanentlyText => 'Delete permanently?';

  @override
  String get deletePermanentlyTWarning => 'Warning: This action will also delete it from your device\'s storage.';

  @override
  String get description => 'Description';

  @override
  String get developedBy => 'Developed by';

  @override
  String get diet => 'Diet';

  @override
  String get docGeneratedBy => 'Document generated with';

  @override
  String get encyclopedia => 'Encyclopedia';

  @override
  String get encyclopediaExp => 'Encyclopedia where you can search for species and consult their characteristics';

  @override
  String get endangered => 'Endangered';

  @override
  String get endemism => 'Endemism';

  @override
  String get environment => 'Environment';

  @override
  String get environmentExp => 'Let\'s take care of it. It is our home';

  @override
  String get error => 'Error';

  @override
  String get errorAnalyzingDb => 'An error has occurred while analyzing the data source structure';

  @override
  String get errorReadingQr => 'No compatible information has been detected in the QR code.';

  @override
  String get errorObtainingInfo => 'An error has occurred while obtaining the information';

  @override
  String get exit => 'Exit the app?';

  @override
  String get exitText => 'Do you really want to exit the application?';

  @override
  String get exportPdf => 'Export as PDF document';

  @override
  String get exportPdfText => '(The information for this species will be exported as a PDF document and saved in the Downloads folde on your device)';

  @override
  String get exportPdfDone => 'PDF document exported successfully';

  @override
  String get extinct => 'Extinct';

  @override
  String get extinctInTheWild => 'Extinct in the wild';

  @override
  String get findDatabase => 'Find data source';

  @override
  String get fileNotFound => 'File not found';

  @override
  String get gallery => 'Gallery';

  @override
  String get game => 'Game';

  @override
  String get gameOver => 'Game Over!';

  @override
  String get games => 'Games';

  @override
  String get gameScoresReset => 'Game scores reset';

  @override
  String get gameSelectSNameFromCName => 'Select the scientific name from the common name';

  @override
  String get gameSelectImageFromCName => 'Select the image from the common name';

  @override
  String get gameSelectCNameFromSound => 'Select the common name from the sound';

  @override
  String get go => 'Go';

  @override
  String get goBack => 'Go back';

  @override
  String get gpsMode => 'GPS mode';

  @override
  String get grantPermissionManually => 'Grant required app permissions manually';

  @override
  String get guatini => 'Guatiní';

  @override
  String get guatiniExp => 'An extensionist project dedicated to enhance the development of general and environmental culture';

  @override
  String get habitat => 'Habitat';

  @override
  String get hits => 'hits';

  @override
  String get home => 'Home';

  @override
  String get image => 'Image';

  @override
  String inARow(int hits) {
    return '$hits in a row';
  }

  @override
  String get incorrect => 'Incorrect';

  @override
  String get info => 'Info';

  @override
  String get internalStorage => 'Internal storage';

  @override
  String get itIs => 'It is';

  @override
  String get itIsNot => 'It is not';

  @override
  String get language => 'Language';

  @override
  String get languageName => 'English';

  @override
  String get leastConcern => 'Least concern';

  @override
  String get levelUp => 'Level up';

  @override
  String get license => 'License';

  @override
  String get light => 'Light';

  @override
  String get link => 'Link';

  @override
  String get location => 'Location';

  @override
  String get locationMode => 'Location mode';

  @override
  String get map => 'Map';

  @override
  String get moreOf => 'More of';

  @override
  String get moreWith => 'More with';

  @override
  String get nearbySpecies => 'Nearby species';

  @override
  String get nearThreataned => 'Near threataned';

  @override
  String get next => 'Next';

  @override
  String get noCameraPermission => 'Guatiní has not permission to access to camera';

  @override
  String get noFolders => 'No folders';

  @override
  String noInDb(String info) {
    return 'The information \"$info\" is not in the data source';
  }

  @override
  String get noLocationEnabled => 'You must turn on location';

  @override
  String get noLocationPermission => 'Guatiní has not permission to access to location';

  @override
  String get noEnoughDbInfo => 'There is not enough information in the data source to play the game.';

  @override
  String get noSelectedDatabase => 'There is not a selected data source';

  @override
  String get noSpeciesNearby => 'There are no species nearby';

  @override
  String get noStoragePermission => 'Guatiní has not permission to access to storage';

  @override
  String get notEvaluated => 'Not evaluated';

  @override
  String get no => 'No';

  @override
  String get noDatabases => 'No data sources';

  @override
  String get noElements => 'There are no elements to show';

  @override
  String get noRecentSearches => 'There are no recent searches';

  @override
  String get noResults => 'There are no results';

  @override
  String get notSelected => 'Not selected';

  @override
  String get numberItemsSearchHistory => 'Number of items in the search history';

  @override
  String get numberSeggestions => 'Number of suggestions on Home';

  @override
  String get ofde => 'of';

  @override
  String get ok => 'Ok';

  @override
  String get onlineAudio => 'Allow online audio';

  @override
  String get onlineImage => 'Allow online image';

  @override
  String get onlineUse => 'Online use';

  @override
  String get onlineVideo => 'Allow online video';

  @override
  String get onlineUseText => 'Use of información from internet';

  @override
  String get others => 'Others';

  @override
  String get openQrReader => 'Open QR reader';

  @override
  String get pause => 'Pause';

  @override
  String get play => 'Play';

  @override
  String get players => 'Players';

  @override
  String get previousFolder => 'Go to previous folder';

  @override
  String get qrReader => 'QR reader';

  @override
  String get refresh => 'Refresh';

  @override
  String get replay => 'Replay';

  @override
  String get resetGameScores => 'Reset game scores';

  @override
  String get scientificName => 'Scientific name';

  @override
  String get sdCard => 'SD card';

  @override
  String get search => 'Search';

  @override
  String get searchHistotySize => 'Search history size';

  @override
  String get searchNearbySpecies => 'Search nearby species';

  @override
  String get searchOnEcured => 'Search on Ecured';

  @override
  String get searchOnWikipedia => 'Search on Wikipedia';

  @override
  String get searchSpecies => 'Search Species';

  @override
  String get seeMediaLocation => 'See location where the media was taken';

  @override
  String get seeLocation => 'See location on the map';

  @override
  String get seeSimilarSpecies => 'See similar species';

  @override
  String get seeSpeciesDistribution => 'See distribution of the species on the map';

  @override
  String get selectLocationMode => 'Please, select location mode';

  @override
  String get selectMode => 'Select mode';

  @override
  String get setPointOnMap => 'First, set a point on the map';

  @override
  String get settings => 'Settings';

  @override
  String get showAds => 'Show Ads';

  @override
  String get showAdsText => 'Popups with curious and interesting facts';

  @override
  String get showSearchOnEcured => 'Show \"Search on Ecured\"';

  @override
  String get showSearchOnWikipedia => 'Show \"Search on Wikipedia\"';

  @override
  String get similarTo => 'Similar to';

  @override
  String get skip => 'Skip';

  @override
  String get sound => 'Sound';

  @override
  String get sourceOfInfo => 'Source of information';

  @override
  String get speciesDetails => 'Species Details';

  @override
  String get stop => 'Stop';

  @override
  String get system => 'System';

  @override
  String get taxClass => 'Class';

  @override
  String get taxDomain => 'Domain';

  @override
  String get taxFamily => 'Family';

  @override
  String get taxGenus => 'Genus';

  @override
  String get taxKingdom => 'Kingdom';

  @override
  String get taxPhylum => 'Phylum';

  @override
  String get taxOrder => 'Order';

  @override
  String get theme => 'Theme';

  @override
  String get ui => 'User interface';

  @override
  String get unavailable => 'No disponible';

  @override
  String get university => 'Technological University of Havana';

  @override
  String get unknown => 'Unknown';

  @override
  String get unknownInfo => 'Cannot be processed if the information is unknown';

  @override
  String get useExternalBrowser => 'Use external browser instead in-app browser';

  @override
  String get version => 'Version';

  @override
  String get video => 'Video';

  @override
  String get vulnerable => 'Vulnerable';

  @override
  String get withDimorphism => 'There may be appreciable differences between the female and the male of this species';

  @override
  String get withoutDimorphism => 'There are no appreciable differences between the female and the male of this species';

  @override
  String get wizardAgain => 'Go back to see the wizard';

  @override
  String get yes => 'Yes';
}
