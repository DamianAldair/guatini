import 'dart:io';

import 'package:flutter/material.dart';
import 'package:guatini/providers/userpreferences_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;

class SpecieModelFromSimpleSearch {
  final int? id;
  final String? name;
  final String? scientificName;
  final String? imagePath;

  const SpecieModelFromSimpleSearch({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.imagePath,
  });

  factory SpecieModelFromSimpleSearch.fromMap(Map<String, dynamic> json) =>
      SpecieModelFromSimpleSearch(
        id: json["id"],
        name: json["name"],
        scientificName: json["scientific_name"],
        imagePath: json["path"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "scientific_name": scientificName,
        "path": imagePath,
      };

  Image get image {
    final prefs = UserPreferences();
    final db = prefs.dbPath;
    final file = File(p.join(db, imagePath));
    return file.existsSync()
        ? Image.file(file, fit: BoxFit.cover)
        : Image.asset(
            'assets/images/image_not_available.png',
            fit: BoxFit.cover,
          );
  }
}
