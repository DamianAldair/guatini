import 'dart:ffi';

import 'package:guatini/models/author_model.dart';
import 'package:guatini/models/license_model.dart';
import 'package:guatini/models/mediatype_model.dart';
import 'package:guatini/models/specie_model.dart';

class MediaModel {
  final int? id;
  final String? path;
  final String? dateCapture;
  final Float? latitude;
  final Float? longitude;
  final SpeciesModel? species;
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
  });

  factory MediaModel.fromMap(Map<String, dynamic> json) => MediaModel(
        id: json["id"],
        path: json["path"],
        dateCapture: json["dateCapture"],
        latitude: json["latitude"],
        longitude: json["longitude"],
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

  DateTime? get date => dateCapture == null
      ? null
      : DateTime(
          int.parse(dateCapture!.substring(0, 4)),
          int.parse(dateCapture!.substring(4, 6)),
          int.parse(dateCapture!.substring(6)),
        );
}

class MainImageModel extends MediaModel {
  MainImageModel({
    required int? id,
    required String? path,
    required String? dateCapture,
    required Float? latitude,
    required Float? longitude,
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
