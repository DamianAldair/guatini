import 'package:guatini/models/author_model.dart';
import 'package:guatini/models/license_model.dart';
import 'package:guatini/models/mediatype_model.dart';
import 'package:guatini/models/specie_model.dart';

class MediaModel {
  final int? id;
  final String? path;
  final DateTime? dateCapture;
  final double? latitude;
  final double? longitude;
  final SpeciesModel? species;
  final int? speciesId;
  final int? authorId;
  final AuthorModel? author;
  final int? licenseId;
  final LicenseModel? license;
  MediaTypeModel? type;

  MediaModel({
    required this.id,
    required this.path,
    required this.dateCapture,
    required this.latitude,
    required this.longitude,
    this.authorId,
    this.author,
    this.licenseId,
    this.license,
    this.species,
    this.speciesId,
  });

  factory MediaModel.fromMore(Map<String, dynamic> json) => MediaModel(
        id: json["id"],
        path: (json["path"] as String).replaceAll('\\', '/'),
        latitude: json["lat"],
        longitude: json["lon"],
        dateCapture: DateTime.fromMillisecondsSinceEpoch(Duration(seconds: json["date_capture"]).inMilliseconds),
        speciesId: json["fk_specie_"],
      )..type = MediaTypeModel.fromMap({"type": json["type"]});

  factory MediaModel.fromMap(Map<String, dynamic> json) => MediaModel(
        id: json["id"],
        path: (json["path"] as String).replaceAll('\\', '/'),
        dateCapture: DateTime.fromMillisecondsSinceEpoch(Duration(milliseconds: json["date_capture"]).inMilliseconds),
        latitude: json["lat"],
        longitude: json["lon"],
        authorId: json["authorId"],
        licenseId: json["licenseId"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "path": path,
        "dateCapture": dateCapture,
        "latitude": latitude,
        "longitude": longitude,
        "fk_specie_": species?.id,
        "fk_license_": license?.id,
        "fk_type_": type?.id,
      };

  set mediaType(MediaTypeModel type) => this.type = type;

  MediaTypeModel get mediaType => type!;
}

class MainImageModel extends MediaModel {
  MainImageModel({
    required int? id,
    required String? path,
    required DateTime? dateCapture,
    required double? latitude,
    required double? longitude,
    int? authorId,
    AuthorModel? author,
    int? licenseId,
    LicenseModel? license,
    SpeciesModel? species,
  }) : super(
          id: id,
          path: path,
          dateCapture: dateCapture,
          latitude: latitude,
          longitude: longitude,
          authorId: authorId,
          author: author,
          licenseId: licenseId,
          license: license,
          species: species,
        );

  factory MainImageModel.fromMap(Map<String, dynamic> json) => MainImageModel(
        id: json["id"],
        path: json["path"],
        dateCapture: json["date_capture"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        authorId: json["authorId"],
        licenseId: json["licenseId"],
      );
}
