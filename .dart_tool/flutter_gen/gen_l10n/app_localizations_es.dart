import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get about => 'Acerca de...';

  @override
  String get abundance => 'Abundancia';

  @override
  String get activity => 'Actividad';

  @override
  String get ad => 'Anuncio';

  @override
  String get addDatabase => 'Añadir fuente de datos desde el almacenamiento';

  @override
  String get addOneDatabase => 'Añada una';

  @override
  String get added => 'Añadida';

  @override
  String get addedDatabase => 'Fuente de datos añadida';

  @override
  String get allSpecies => 'Todas las especies';

  @override
  String get alreadyAdded => 'Esta fuente de datos ya está añadida';

  @override
  String get attempts => 'intentos';

  @override
  String get audio => 'Audio';

  @override
  String get author => 'Autor';

  @override
  String get autoplayAudio => 'Reproducir audio automáticamente';

  @override
  String get autoplayAudioInfo => 'Comenzar reproducción de audio automáticamente al abrir el reproductor';

  @override
  String get autoplayVideo => 'Reproducir video automáticamente';

  @override
  String get autoplayVideoInfo => 'Comenzar reproducción de video automáticamente al abrir el reproductor';

  @override
  String get back => 'Volver';

  @override
  String get cannotOpenSettings => 'No se puede abrir la pantalla de permisos de la apliación.\nNo se puede conceder el permiso solicitado.\nNecesita conceder el permiso manualmente en la pantalla de permisos de la aplicación.';

  @override
  String get chooseOne => 'Seleccione una opción';

  @override
  String get clear => 'Borrar todo';

  @override
  String get closeExplorer => 'Cerrar explorador';

  @override
  String get college => 'Facultad de Ingeniería informática';

  @override
  String get commonName => 'Nombre común';

  @override
  String get conservationStatus => 'Estado de conservación';

  @override
  String get criticalEndangered => 'En peligro crítico';

  @override
  String get copy => 'Copiar';

  @override
  String get correct => 'Correcto';

  @override
  String get correctAnswerIs => 'La respuesta correcta es:';

  @override
  String get current => 'Actual';

  @override
  String get customLocationMode => 'Ubicación personalizada';

  @override
  String get customLocationModeString => 'Toque sobre el mapa para seleccionar una ubicación';

  @override
  String get database => 'Fuente de datos';

  @override
  String get databaseSelectedInfo => 'El lenguaje de la fuente de datos no depende de la aplicación';

  @override
  String date(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Fecha: $dateString';
  }

  @override
  String get dark => 'Oscuro';

  @override
  String get dbNotFound => 'Fuente de datos no encontrada';

  @override
  String get dbNotFoundInfo => 'Esta fuente de datos parece que ha sido eliminada o movida y no se puede seleccionar.';

  @override
  String get dbStructureNoCorrect => 'La estructura de la fuente de datos no es correcta';

  @override
  String get deficientData => 'Datos deficientes';

  @override
  String get deletedDatabase => 'Archivo de base de datos borrado permanentemente';

  @override
  String get deletedDataSource => 'Fuente de datos borrada permanentemente';

  @override
  String get deleteEntireFolder => 'Toda la carpeta o fuente de datos';

  @override
  String get deleteFromList => 'Borrar de la lista';

  @override
  String get deleteFromListText => '¿Borrar de la lista?';

  @override
  String get deleteJustDb => 'Sólo el archivo de base de datos';

  @override
  String get deleteList => 'Borrar lista';

  @override
  String get deleteListText => '¿Está seguro que desea borrar la lista?';

  @override
  String get deletePermanently => 'Borrar permanentemente';

  @override
  String get deletePermanentlyText => '¿Borrar permanentemente?';

  @override
  String get deletePermanentlyWarning => 'ATENCIÓN\nCon esta acción también se borrará del almacenamiento de su dispositivo.\nTenga en cuente que tiene la posibilidad de borrar sólo el archivo de base de datos o la fuente de datos completa, la cual incluye toda la carpeta que contiene dicha base de datos.';

  @override
  String get description => 'Descripción';

  @override
  String get developedBy => 'Desarrollado por';

  @override
  String get diet => 'Dieta';

  @override
  String get docGeneratedBy => 'Documento generado con';

  @override
  String get encyclopedia => 'Enciclopedia';

  @override
  String get encyclopediaExp => 'Enciclopedia en la que puedes buscar especies y consultar sus características';

  @override
  String get endangered => 'En peligro';

  @override
  String get endemism => 'Endemismo';

  @override
  String get environment => 'Medio ambiente';

  @override
  String get environmentExp => 'Cuidémoslo. Es nuestro hogar';

  @override
  String get error => 'Error';

  @override
  String get errorAnalyzingDb => 'Ha ocurrido un error al analizar la estrutura de la fuente de datos';

  @override
  String get errorReadingQr => 'No se ha detectado información compatible en el código QR';

  @override
  String get errorObtainingInfo => 'Ha ocurrido un error al obtener la información';

  @override
  String get exit => '¿Salir?';

  @override
  String get exitText => '¿Realmente desea salir de la aplicación?';

  @override
  String get exportPdf => 'Exportar como documento PDF';

  @override
  String get exportPdfText => '(Se exportará la información de esta especie como documento PDF y se guardará en la carpeta de Descargas de su dispositivo)';

  @override
  String get exportPdfDone => 'Documento PDF exportado satisfactoriamente';

  @override
  String get extinct => 'Extinta';

  @override
  String get extinctInTheWild => 'Extinta en estado silvestre';

  @override
  String get findDatabase => 'Buscar fuente de datos';

  @override
  String get fileNotFound => 'Archivo no encontrado';

  @override
  String get gallery => 'Galería';

  @override
  String get game => 'Juego';

  @override
  String get gameOver => '¡Juego terminado!';

  @override
  String get games => 'Juegos';

  @override
  String get gameScoresReset => 'Puntuaciones de juegos restablecidas';

  @override
  String get gameSelectSNameFromCName => 'Selecciona el nombre científico dado el nombre común';

  @override
  String get gameSelectImageFromCName => 'Selecciona la imagen dado el nombre común';

  @override
  String get gameSelectCNameFromSound => 'Selecciona el nombre común dado el sonido';

  @override
  String get go => 'Comencemos';

  @override
  String get goBack => 'Volver';

  @override
  String get gpsMode => 'Utilizar GPS';

  @override
  String get grantPermissionManually => 'Conceda los permisos requeridos de la aplicación manualmente';

  @override
  String get guatini => 'Guatiní';

  @override
  String get guatiniExp => 'Proyecto extensionista dedicado a elevar el desarrollo de la cultura general y medioambiental';

  @override
  String get habitat => 'Hábitat';

  @override
  String get hits => 'aciertos';

  @override
  String get home => 'Inicio';

  @override
  String get image => 'Imagen';

  @override
  String inARow(int hits) {
    return '$hits aciertos seguidos';
  }

  @override
  String get incorrect => 'Incorrecto';

  @override
  String get info => 'Información';

  @override
  String get internalStorage => 'Almacenamiento interno';

  @override
  String get itIs => 'Es';

  @override
  String get itIsNot => 'No es';

  @override
  String get language => 'Idioma';

  @override
  String get languageName => 'Español';

  @override
  String get leastConcern => 'Preocupación menor';

  @override
  String get levelUp => 'Carpeta anterior';

  @override
  String get license => 'Licencia';

  @override
  String get light => 'Claro';

  @override
  String get link => 'Enlace';

  @override
  String get listAllSpecies => 'Listar todas las especies';

  @override
  String get location => 'Ubicación';

  @override
  String get locationMode => 'Modo de ubicación';

  @override
  String get map => 'Mapa';

  @override
  String get moreOf => 'Más de';

  @override
  String get moreWith => 'Más con';

  @override
  String get nearbySpecies => 'Especies cercanas';

  @override
  String get nearThreataned => 'Casi amenazada';

  @override
  String get next => 'Siguiente';

  @override
  String get noCameraPermission => 'Guatiní no tiene permiso para acceder a la cámara';

  @override
  String get noFolders => 'No hay directorios';

  @override
  String noInDb(String info) {
    return 'La información \"$info\" no está en la fuente de datos';
  }

  @override
  String get noLocationEnabled => 'Se necesita activar la ubicación de su dispositivo';

  @override
  String get noLocationPermission => 'Guatiní no tiene permiso para utilizar la ubicación';

  @override
  String get noEnoughDbInfo => 'No hay suficiente información o faltan datos en la fuente de datos para jugar.';

  @override
  String get noSelectedDatabase => 'No hay una fuente de datos seleccionada o la que se seleccionó no existe o se movió';

  @override
  String get noSpeciesNearby => 'No hay especies cerca';

  @override
  String get noStoragePermission => 'Guatiní no tiene permiso para acceder al almacenamiento';

  @override
  String get notEvaluated => 'No evaluado';

  @override
  String get no => 'No';

  @override
  String get noDatabases => 'No hay fuentes de datos';

  @override
  String get noElements => 'No hay elementos para mostrar';

  @override
  String get noRecentSearches => 'No hay búsquedas recientes';

  @override
  String get noResults => 'No hay resultados';

  @override
  String get noResultsFromQr => 'No hay resultados de la información leída en este código QR.';

  @override
  String get notSelected => 'No seleccionada';

  @override
  String get numberItemsSearchHistory => 'Cantidad de elementos en el historial de búsqueda';

  @override
  String get numberSeggestions => 'Cantidad de sugerencias en Inicio';

  @override
  String get ofde => 'de';

  @override
  String get ok => 'Aceptar';

  @override
  String get onlineAudio => 'Permitir audio en línea';

  @override
  String get onlineImage => 'Permitir imagen en línea';

  @override
  String get onlineUse => 'Uso en línea';

  @override
  String get onlineVideo => 'Permitir video en línea';

  @override
  String get onlineUseText => 'Uso de información desde internet';

  @override
  String get others => 'Otros';

  @override
  String get openQrReader => 'Abrir escaner QR';

  @override
  String get pause => 'Pausa';

  @override
  String get play => 'Reproducir';

  @override
  String get players => 'Reproductores';

  @override
  String get previousFolder => 'Ir a la carpeta anterior';

  @override
  String get qrReader => 'Escaner QR';

  @override
  String get refresh => 'Refrescar';

  @override
  String get replay => 'Comenzar reproducción de nuevo';

  @override
  String get resetGameScores => 'Restablecer puntuaciones de juegos';

  @override
  String get scientificName => 'Nombre científico';

  @override
  String get sdCard => 'Tarjeta SD';

  @override
  String get search => 'Buscar';

  @override
  String get searchHistotySize => 'Tamaño del historial de búsqueda';

  @override
  String get searchNearbySpecies => 'Buscar especies cercanas';

  @override
  String get searchOnEcured => 'Buscar en Ecured';

  @override
  String get searchOnWikipedia => 'Buscar en Wikipedia';

  @override
  String get searchSpecies => 'Buscar especie';

  @override
  String get seeMediaLocation => 'Ver ubicación donde se tomó esta multimedia';

  @override
  String get seeLocation => 'Ver ubicación en el mapa';

  @override
  String get seeSimilarSpecies => 'Ver especies similares';

  @override
  String get seeSpeciesDistribution => 'Ver distribución de la especie en el mapa';

  @override
  String get selectLocationMode => 'Por favor, seleccione un modo de ubicación';

  @override
  String get selectMode => 'Seleccionar modo';

  @override
  String get setPointOnMap => 'Primero establezca en punto en el mapa';

  @override
  String get settings => 'Configuración';

  @override
  String get showAds => 'Mostrar anuncios';

  @override
  String get showAdsText => 'Ventanas flotantes con datos curiosos e interesantes';

  @override
  String get showSearchOnEcured => 'Mostrar botón \"Buscar en Ecured\"';

  @override
  String get showSearchOnWikipedia => 'Mostrar botón \"Buscar en Wikipedia\"';

  @override
  String get similarTo => 'Similar a';

  @override
  String get skip => 'Omitir';

  @override
  String get sound => 'Sonido';

  @override
  String get sourceOfInfo => 'Fuente de información';

  @override
  String get speciesDetails => 'Detalles de la especie';

  @override
  String get stop => 'Parar reproducción';

  @override
  String get system => 'Según el sistema';

  @override
  String get taxClass => 'Clase';

  @override
  String get taxDomain => 'Dominio';

  @override
  String get taxFamily => 'Familia';

  @override
  String get taxGenus => 'Género';

  @override
  String get taxKingdom => 'Reino';

  @override
  String get taxPhylum => 'Filo';

  @override
  String get taxOrder => 'Orden';

  @override
  String get theme => 'Tema';

  @override
  String get total => 'Total';

  @override
  String get ui => 'Interfaz de usuario';

  @override
  String get unavailable => 'No disponible';

  @override
  String get university => 'Universidad Tecnológica de La Habana';

  @override
  String get unknown => 'Desconocido';

  @override
  String get unknownInfo => 'No se puede procesar si la información es desconocida';

  @override
  String get useExternalBrowser => 'Utilizar navegador externo en vez del incorporado en la aplicación';

  @override
  String get version => 'Versión';

  @override
  String get video => 'Vídeo';

  @override
  String get vulnerable => 'Vulnerable';

  @override
  String get withDimorphism => 'Pueden existir diferencias apreciables entre la hembra y el macho de esta especie';

  @override
  String get withoutDimorphism => 'No hay diferencias apreciables entre la hembra y el macho de esta especie';

  @override
  String get wizardAgain => 'Volver a ver la introducción';

  @override
  String get yes => 'Sí';
}
