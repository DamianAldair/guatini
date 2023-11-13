import 'dart:io';

import 'package:flutter/material.dart';
import 'package:guatini/models/abundance_model.dart';
import 'package:guatini/models/activity_model.dart';
import 'package:guatini/models/class_model.dart';
import 'package:guatini/models/commonmane_model.dart';
import 'package:guatini/models/conservationstatus_model.dart';
import 'package:guatini/models/diet_model.dart';
import 'package:guatini/models/domain_model.dart';
import 'package:guatini/models/endemism_model.dart';
import 'package:guatini/models/family_model.dart';
import 'package:guatini/models/genus_model.dart';
import 'package:guatini/models/habitat_model.dart';
import 'package:guatini/models/kindom_model.dart';
import 'package:guatini/models/media_model.dart';
import 'package:guatini/models/order_model.dart';
import 'package:guatini/models/phylum_model.dart';
import 'package:guatini/providers/userpreferences_provider.dart';
import 'package:path/path.dart' as p;

class SpeciesModel {
  final int? id;
  final MainImageModel? mainImage;
  final String? imagePath;
  final List<CommonNameModel>? commonNames;
  final String? searchName;
  final String? scientificName;
  final DomainModel? taxdomain;
  final KindomModel? taxkindom;
  final PhylumModel? taxphylum;
  final ClassModel? taxclass;
  final OrderModel? taxorder;
  final FamilyModel? taxfamily;
  final GenusModel? taxgenus;
  final ConservationStatusModel? conservationStatus;
  final EndemismModel? endemism;
  final AbundanceModel? abundance;
  final List<ActivityModel>? activities;
  final List<HabitatModel>? habitats;
  final List<DietModel>? diets;
  final bool? dimorphism;
  final String? description;
  final List<MediaModel>? medias;

  const SpeciesModel({
    this.id,
    this.mainImage,
    this.imagePath,
    this.commonNames,
    this.searchName,
    this.scientificName,
    this.taxdomain,
    this.taxkindom,
    this.taxphylum,
    this.taxclass,
    this.taxorder,
    this.taxfamily,
    this.taxgenus,
    this.conservationStatus,
    this.endemism,
    this.abundance,
    this.activities,
    this.habitats,
    this.diets,
    this.dimorphism,
    this.description,
    this.medias,
  });

  factory SpeciesModel.fromMap({
    required Map<String, dynamic>? json,
    required MainImageModel? mainImage,
    required List<CommonNameModel>? commonNames,
    required DomainModel? taxdomain,
    required KindomModel? taxkindom,
    required PhylumModel? taxphylum,
    required ClassModel? taxclass,
    required OrderModel? taxorder,
    required FamilyModel? taxfamily,
    required GenusModel? taxgenus,
    required ConservationStatusModel? conservationStatus,
    required EndemismModel? endemism,
    required AbundanceModel? abundance,
    required List<ActivityModel>? activities,
    required List<HabitatModel>? habitats,
    required List<DietModel>? diets,
    required List<MediaModel>? medias,
  }) =>
      SpeciesModel(
        id: json!["id"],
        mainImage: mainImage,
        commonNames: commonNames,
        scientificName: json["scientific_name"],
        taxdomain: taxdomain,
        taxkindom: taxkindom,
        taxphylum: taxphylum,
        taxclass: taxclass,
        taxorder: taxorder,
        taxfamily: taxfamily,
        taxgenus: taxgenus,
        conservationStatus: conservationStatus,
        endemism: endemism,
        abundance: abundance,
        activities: activities,
        habitats: habitats,
        diets: diets,
        dimorphism: json["dimorphism"].runtimeType == bool
            ? json["dimorphism"]
            : json["dimorphism"].runtimeType == int
                ? json["dimorphism"] == 1
                : false,
        description: json["description"],
        medias: medias,
      );

  factory SpeciesModel.fromSimpleSearch(Map<String, dynamic> json) {
    return SpeciesModel(
      id: json["id"],
      searchName: json["name"],
      scientificName: json["scientific_name"],
      imagePath: json["path"],
    );
  }

  String get commonNamesAsString {
    String names = '';
    for (var item in commonNames!) {
      names += '${item.name}\n';
    }
    return names.substring(0, names.length - 1);
  }

  Image get image {
    final placeholder = Image.asset(
      'assets/images/image_not_available.png',
      fit: BoxFit.cover,
    );
    if (imagePath == null) return placeholder;
    final prefs = UserPreferences();
    final db = prefs.dbPathNotifier.value;
    if (db == null) return placeholder;
    final file = File(p.join(db, imagePath).replaceAll('\\', '/'));
    if (!file.existsSync()) return placeholder;
    return Image.file(file, fit: BoxFit.cover);
  }
}
