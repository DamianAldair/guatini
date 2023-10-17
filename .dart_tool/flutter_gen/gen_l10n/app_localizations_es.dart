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
  String get addDatabase => 'Añadir base de datos desde el almacenamiento';

  @override
  String get added => 'Añadida';

  @override
  String get addedDatabase => 'Base de datos añadida';

  @override
  String get alreadyAdded => 'Esta base de datos ya está añadida';

  @override
  String get attempts => 'intentos';

  @override
  String get audio => 'Audio';

  @override
  String get author => 'Autor';

  @override
  String get back => 'Volver';

  @override
  String get cannotOpenSettings => 'No se puede abrir la pantalla de permisos de la apliación.\nNo se puede conceder el permiso solicitado.\nNecesita conceder el permiso manualmente en la pantalla de permisos de la aplicación.';

  @override
  String get chooseOne => 'Seleccione una opción';

  @override
  String get clear => 'Borrar todo';

  @override
  String get college => 'Facultad de Ingeniería informática';

  @override
  String get conservationStatus => 'Estado de conservación';

  @override
  String get criticalEndangered => 'En peligro crítico';

  @override
  String get correct => 'Correcto';

  @override
  String get current => 'Actual';

  @override
  String get customLocationMode => 'Ubicación personalizada';

  @override
  String get customLocationModeString => 'Toque sobre el mapa para seleccionar una ubicación';

  @override
  String get database => 'Base de datos';

  @override
  String get databaseSelectedInfo => 'El lenguae de la bases de datos no depende de la aplicación';

  @override
  String date(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Fecha: $dateString';
  }

  @override
  String get dark => 'Oscuro';

  @override
  String get deficientData => 'Datos deficientes';

  @override
  String get deletedDatabase => 'Base de datos borrada permanentemente';

  @override
  String get deleteFromList => 'Borrar de la lista';

  @override
  String get deleteFromListText => '¿Borrar de la lista?';

  @override
  String get deleteList => 'Borrar lista';

  @override
  String get deleteListText => '¿Está seguro que desea borrar la lista?';

  @override
  String get deletePermanently => 'Borrar permanentemente';

  @override
  String get deletePermanentlyText => '¿Borrar permanentemente?';

  @override
  String get description => 'Descripción';

  @override
  String get developedBy => 'Desarrollado por';

  @override
  String get diet => 'Dieta';

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
  String get errorReadingQr => 'No se ha detectado información compatible en el código QR';

  @override
  String get errorObtainingInfo => 'Ha ocurrido un error al obtener la información';

  @override
  String get exit => '¿Salir?';

  @override
  String get exitText => '¿Realmente desea salir de la aplicación?';

  @override
  String get extinct => 'Extinta';

  @override
  String get extinctInTheWild => 'Extinta en estado silvestre';

  @override
  String get findDatabase => 'Buscar base de datos';

  @override
  String get fileNotFound => 'Archivo no encontrado';

  @override
  String get gallery => 'Galería';

  @override
  String get game => 'Juego';

  @override
  String get games => 'Juegos';

  @override
  String get gameSelectSNameFromCName => 'Selecciona el nombre científico dado el nombre común';

  @override
  String get gameSelectImageFromCName => 'Selecciona la imagen dado el nombre común';

  @override
  String get gameSelectCNameFromSound => 'Selecciona el nombre común dado el sonido';

  @override
  String get go => 'Comencemos';

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
  String get license => 'Licencia';

  @override
  String get light => 'Claro';

  @override
  String get locationMode => 'Modo de ubicación';

  @override
  String get map => 'Mapa';

  @override
  String get moreOf => 'Más de';

  @override
  String get moreWith => 'Más con';

  @override
  String get nearThreataned => 'Casi amenazada';

  @override
  String get next => 'Siguiente';

  @override
  String get noCameraPermission => 'Guatiní no tiene permiso para acceder a la cámara';

  @override
  String noInDb(String info) {
    return 'La información \"$info\" no está en la base de datos';
  }

  @override
  String get noLocationEnabled => 'Se necesita activar la ubicación de su dispositivo';

  @override
  String get noLocationPermission => 'Guatiní no tiene permiso para utilizar la ubicación';

  @override
  String get noStoragePermission => 'Guatiní no tiene permiso para acceder al almacenamiento';

  @override
  String get notEvaluated => 'No evaluado';

  @override
  String get no => 'No';

  @override
  String get noDatabases => 'No hay bases de datos';

  @override
  String get noRecentSearches => 'No hay búsquedas recientes';

  @override
  String get noResults => 'No hay resultados';

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
  String get onlineAudio => 'Audio en línea';

  @override
  String get onlineImage => 'Imagen en línea';

  @override
  String get onlineUse => 'Uso en línea';

  @override
  String get onlineVideo => 'Video en línea';

  @override
  String get onlineUseText => 'Uso de información desde internet';

  @override
  String get openQrReader => 'Abrir escaner QR';

  @override
  String get pause => 'Pausa';

  @override
  String get play => 'Reproducir';

  @override
  String get previousFolder => 'Ir a la carpeta anterior';

  @override
  String get qrReader => 'Escaner QR';

  @override
  String get refresh => 'Refrescar';

  @override
  String get replay => 'Comenzar reproducción de nuevo';

  @override
  String get search => 'Buscar';

  @override
  String get searchSpecies => 'Buscar especie';

  @override
  String get selectLocationMode => 'Por favor, seleccione un modo de ubicación';

  @override
  String get selectMode => 'Seleccionar modo';

  @override
  String get settings => 'Configuración';

  @override
  String get skip => 'Omitir';

  @override
  String get sound => 'Sonido';

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
  String get unavailable => 'No disponible';

  @override
  String get university => 'Universidad Tecnológica de La Habana';

  @override
  String get unknown => 'Desconocido';

  @override
  String get unknownInfo => 'No se puede procesar si la información es desconocida';

  @override
  String get version => 'Versión';

  @override
  String get video => 'Vídeo';

  @override
  String get vulnerable => 'Vulnerable';

  @override
  String get wikiSearch => 'Buscar en Wikipedia';

  @override
  String get yes => 'Sí';
}
