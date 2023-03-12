import 'package:guatini/models/abundance_model.dart';
import 'package:guatini/models/activity_model.dart';
import 'package:guatini/models/author_model.dart';
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
import 'package:guatini/models/license_model.dart';
import 'package:guatini/models/media_model.dart';
import 'package:guatini/models/mediatype_model.dart';
import 'package:guatini/models/order_model.dart';
import 'package:guatini/models/phylum_model.dart';
import 'package:guatini/models/specie_model.dart';
import 'package:sqflite/sqflite.dart';

abstract class SearchProvider {
  static Future<LicenseModel?> getLicense(Database db, int id) async {
    final query = '''
      SELECT 
      [main].[license].[id], 
      [main].[license].[name], 
      [main].[license].[description]
      FROM   [main].[license]
      WHERE  [main].[license].[id] = $id;
    ''';
    final result = await db.rawQuery(query);
    return result.isNotEmpty ? LicenseModel.fromMap(result.first) : null;
  }

  static Future<AuthorModel?> getAuthor(Database db, int id) async {
    final query = '''
      SELECT 
      [main].[author].[id], 
      [main].[author].[name], 
      [main].[author].[description]
      FROM   [main].[author]
      WHERE  [main].[author].[id] = $id;
    ''';
    final result = await db.rawQuery(query);
    return result.isNotEmpty ? AuthorModel.fromMap(result.first) : null;
  }

  static Future<MainImageModel?> _getMainImage(
      Database db, int speciesId) async {
    final query = '''
      SELECT 
      [main].[media].[id], 
      [main].[media].[path], 
      [main].[media].[date_capture], 
      [main].[media].[lat], 
      [main].[media].[lon], 
      [main].[author].[id] AS [authorId], 
      [main].[license].[id] AS [licenseId]
      FROM [main].[specie]
      INNER JOIN [main].[media] ON [main].[specie].[id] = [main].[media].[fk_specie_]
      INNER JOIN [main].[main_image] ON [main].[media].[id] = [main].[main_image].[fk_media_]
      INNER JOIN [main].[media_author] ON [main].[media].[id] = [main].[media_author].[fk_media_]
      INNER JOIN [main].[author] ON [main].[author].[id] = [main].[media_author].[fk_author_]
      INNER JOIN [main].[license] ON [main].[license].[id] = [main].[media].[fk_license_]
      where [main].[specie].[id] = $speciesId;
    ''';
    final result = await db.rawQuery(query);
    return result.isNotEmpty ? MainImageModel.fromMap(result.first) : null;
  }

  static Future<List<CommonNameModel>> _getCommonNames(
      Database db, int speciesId) async {
    final query = '''
        select
        [main].[common_name].[id],
        [main].[common_name].[name]
        from [main].[specie]
        inner join [main].[common_name] on [main].[specie].[id] = [main].[common_name].[fk_specie_]
        where [main].[specie].[id] = $speciesId;
    ''';
    final result = await db.rawQuery(query);
    final commonNames = <CommonNameModel>[];
    for (var item in result) {
      commonNames.add(CommonNameModel.fromMap(item));
    }
    return commonNames;
  }

  static Future<GenusModel?> _getGenus(Database db, int? speciesId) async {
    final query = '''
        select
        [main].[t_genus].[id],
        [main].[t_genus].[name],
        [main].[t_genus].[description]
        from [main].[specie]
        inner join [main].[t_genus] on [main].[t_genus].[id] = [main].[specie].[fk_t_genus_]
        where [main].[specie].[id] = $speciesId;
    ''';
    final result = speciesId != null ? await db.rawQuery(query) : [];
    return result.isNotEmpty ? GenusModel.fromMap(result.first) : null;
  }

  static Future<FamilyModel?> _getFamily(Database db, int? genusId) async {
    final query = '''
        select 
        [main].[t_family].[id], 
        [main].[t_family].[name], 
        [main].[t_family].[description]
        from [main].[t_genus]
        inner join [main].[t_family] on [main].[t_family].[id] = [main].[t_genus].[fk_t_family_]
        where [main].[t_genus].[id] = $genusId;
    ''';
    final result = genusId != null ? await db.rawQuery(query) : [];
    return result.isNotEmpty ? FamilyModel.fromMap(result.first) : null;
  }

  static Future<OrderModel?> _getOrder(Database db, int? familyId) async {
    final query = '''
        select
        [main].[t_order].[id],
        [main].[t_order].[name],
        [main].[t_order].[description]
        from [main].[t_family]
        inner join [main].[t_order] on [main].[t_order].[id] = [main].[t_family].[fk_t_order_]
        where [main].[t_family].[id] = $familyId;
    ''';
    final result = familyId != null ? await db.rawQuery(query) : [];
    return result.isNotEmpty ? OrderModel.fromMap(result.first) : null;
  }

  static Future<ClassModel?> _getClass(Database db, int? orderId) async {
    final query = '''
        select
        [main].[t_class].[id],
        [main].[t_class].[name],
        [main].[t_class].[description]
        from [main].[t_order]
        inner join [main].[t_class] on [main].[t_class].[id] = [main].[t_order].[fk_t_class_]
        where [main].[t_order].[id] = $orderId;
    ''';
    final result = orderId != null ? await db.rawQuery(query) : [];
    return result.isNotEmpty ? ClassModel.fromMap(result.first) : null;
  }

  static Future<PhylumModel?> _getPhylum(Database db, int? classId) async {
    final query = '''
        select
        [main].[t_phylum].[id],
        [main].[t_phylum].[name],
        [main].[t_phylum].[description]
        from [main].[t_class]
        inner join [main].[t_phylum] on [main].[t_phylum].[id] = [main].[t_class].[fk_t_phylum_]
        where [main].[t_class].[id] = $classId;
    ''';
    final result = classId != null ? await db.rawQuery(query) : [];
    return result.isNotEmpty ? PhylumModel.fromMap(result.first) : null;
  }

  static Future<KindomModel?> _getKindom(Database db, int? phylumId) async {
    final query = '''
        select
        [main].[t_kindom].[id],
        [main].[t_kindom].[name],
        [main].[t_kindom].[description]
        from [main].[t_phylum]
        inner join [main].[t_kindom] on [main].[t_kindom].[id] = [main].[t_phylum].[fk_t_kindom_]
        where [main].[t_phylum].[id] = $phylumId;
    ''';
    final result = phylumId != null ? await db.rawQuery(query) : [];
    return result.isNotEmpty ? KindomModel.fromMap(result.first) : null;
  }

  static Future<DomainModel?> _getDomain(Database db, int? kindomId) async {
    final query = '''
        select
        [main].[t_domain].[id],
        [main].[t_domain].[name],
        [main].[t_domain].[description]
        from [main].[t_kindom]
        inner join [main].[t_domain] on [main].[t_domain].[id] = [main].[t_kindom].[fk_t_domain_]
        where [main].[t_kindom].[id] = $kindomId;
    ''';
    final result = kindomId != null ? await db.rawQuery(query) : [];
    return result.isNotEmpty ? DomainModel.fromMap(result.first) : null;
  }

  static Future<ConservationStatusModel?> _getConservationStatus(
      Database db, int? speciesId) async {
    final query = '''
        select
        [main].[coservation_status].[id],
        [main].[coservation_status].[status]
        from [main].[specie]
        inner join [main].[coservation_status] on [main].[coservation_status].[id] = [main].[specie].[fk_coservation_status_]
        where [main].[specie].[id] = $speciesId;
    ''';
    final result = speciesId != null ? await db.rawQuery(query) : [];
    return result.isNotEmpty
        ? ConservationStatusModel.fromMap(result.first)
        : null;
  }

  static Future<EndemismModel?> _getEndemism(
      Database db, int? speciesId) async {
    final query = '''
        select
        [main].[endemism].[id],
        [main].[endemism].[zone]
        from [main].[specie]
        inner join [main].[endemism] on [main].[endemism].[id] = [main].[specie].[fk_endemism_]
        where [main].[specie].[id] = $speciesId;
    ''';
    final result = speciesId != null ? await db.rawQuery(query) : [];
    return result.isNotEmpty ? EndemismModel.fromMap(result.first) : null;
  }

  static Future<AbundanceModel?> _getAbundance(
      Database db, int? speciesId) async {
    final query = '''
        select
        [main].[abundance].[id],
        [main].[abundance].[abundance]
        from [main].[specie]
        inner join [main].[abundance] on [main].[abundance].[id] = [main].[specie].[fk_abundance_]
        where [main].[specie].[id] = $speciesId;
    ''';
    final result = speciesId != null ? await db.rawQuery(query) : [];
    return result.isNotEmpty ? AbundanceModel.fromMap(result.first) : null;
  }

  static Future<List<ActivityModel>> _getActivities(
      Database db, int speciesId) async {
    final query = '''
        select
        [main].[activity].[id],
        [main].[activity].[activity]
        from [main].[specie]
        inner join [main].[specie_activity] on [main].[specie].[id] = [main].[specie_activity].[fk_specie_]
        inner join [main].[activity] on [main].[activity].[id] = [main].[specie_activity].[fk_activity_]
        where [main].[specie].[id] = $speciesId;
    ''';
    final result = await db.rawQuery(query);
    final activities = <ActivityModel>[];
    for (var item in result) {
      activities.add(ActivityModel.fromMap(item));
    }
    return activities;
  }

  static Future<List<HabitatModel>> _getHabitats(
      Database db, int speciesId) async {
    final query = '''
        select
        [main].[habitat].[id],
        [main].[habitat].[habitat]
        from [main].[specie]
        inner join [main].[specie_habitat] on [main].[specie].[id] = [main].[specie_habitat].[fk_specie_]
        inner join [main].[habitat] on [main].[habitat].[id] = [main].[specie_habitat].[fk_habitat_]
        where [main].[specie].[id] = $speciesId;
    ''';
    final result = await db.rawQuery(query);
    final habitats = <HabitatModel>[];
    for (var item in result) {
      habitats.add(HabitatModel.fromMap(item));
    }
    return habitats;
  }

  static Future<List<DietModel>> _getDiets(Database db, int speciesId) async {
    final query = '''
        select
        [main].[diet].[id],
        [main].[diet].[diet]
        from [main].[specie]
        inner join [main].[specie_diet] on [main].[specie].[id] = [main].[specie_diet].[fk_specie_]
        inner join [main].[diet] on [main].[diet].[id] = [main].[specie_diet].[fk_diet_]
        where [main].[specie].[id] = $speciesId;
    ''';
    final result = await db.rawQuery(query);
    final diets = <DietModel>[];
    for (var item in result) {
      diets.add(DietModel.fromMap(item));
    }
    return diets;
  }

  static Future<List<MediaModel>> _getMedias(Database db, int speciesId) async {
    final query = '''
        select
        [main].[media].[id],
        [main].[media].[path],
        [main].[media].[date_capture],
        [main].[media].[lat],
        [main].[media].[lon],
        [main].[media].[fk_type_]
        from [main].[media]
        inner join [main].[specie] on [main].[specie].[id] = [main].[media].[fk_specie_]
        where [main].[specie].[id] = $speciesId;
    ''';
    final result = await db.rawQuery(query);
    final medias = <MediaModel>[];
    for (Map<String, Object?> item in result) {
      MediaTypeModel? type = await _getMediaType(
        db,
        MediaModel.fromMap(item).id,
      );
      MediaModel media = MediaModel.fromMap(item);
      media.type = type;
      medias.add(media);
    }
    return medias;
  }

  static Future<MediaTypeModel?> _getMediaType(
      Database db, int? mediaId) async {
    final query = '''
        select
        [main].[type].[id],
        [main].[type].[type]
        from [main].[media]
        inner join [main].[type] on [main].[type].[id] = [main].[media].[fk_type_]
        where [main].[media].[id] = $mediaId;
    ''';
    final result = mediaId != null ? await db.rawQuery(query) : [];
    return result.isNotEmpty ? MediaTypeModel.fromMap(result.first) : null;
  }

  static Future<SpeciesModel?> getSpecie(Database db, int speciesId) async {
    try {
      final query = '''
          select
          [main].[specie].[id],
          [main].[specie].[scientific_name],
          [main].[specie].[description]
          from [main].[specie]
          where [main].[specie].[id] = $speciesId;
      ''';

      final result = await db.rawQuery(query);
      final mainImage = await _getMainImage(db, speciesId);
      final commonNames = await _getCommonNames(db, speciesId);
      final taxgenus = await _getGenus(db, speciesId);
      final taxfamily = await _getFamily(db, taxgenus!.id);
      final taxorder = await _getOrder(db, taxfamily!.id);
      final taxclass = await _getClass(db, taxorder!.id);
      final taxphylum = await _getPhylum(db, taxclass!.id);
      final taxkindom = await _getKindom(db, taxphylum!.id);
      final taxdomain = await _getDomain(db, taxkindom!.id);
      final conservationStatus = await _getConservationStatus(db, speciesId);
      final endemism = await _getEndemism(db, speciesId);
      final abundance = await _getAbundance(db, speciesId);
      final activities = await _getActivities(db, speciesId);
      final habitats = await _getHabitats(db, speciesId);
      final diets = await _getDiets(db, speciesId);
      final medias = await _getMedias(db, speciesId);
      return SpeciesModel.fromMap(
        json: result.first,
        mainImage: mainImage,
        commonNames: commonNames,
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
        medias: medias,
      );
    } catch (e) {
      return null;
    }
  }

  static Future<List<SpeciesModel>> searchSpecie(
      Database db, String search) async {
    try {
      final query = '''
          select
          [main].[specie].[id],
          [main].[common_name].[name],
          [main].[specie].[scientific_name],
          [main].[media].[path]
          from [main].[specie]
          inner join [main].[media] on [main].[specie].[id] = [main].[media].[fk_specie_]
          inner join [main].[main_image] on [main].[media].[id] = [main].[main_image].[fk_media_]
          inner join [main].[common_name] on [main].[specie].[id] = [main].[common_name].[fk_specie_]
          where [main].[common_name].[name] LIKE '%$search%' OR [main].[specie].[scientific_name] LIKE '%$search%';
      ''';
      final result = await db.rawQuery(query);
      final results = <SpeciesModel>[];
      for (var item in result) {
        results.add(SpeciesModel.fromSimpleSearch(item));
      }
      return results;
    } catch (e) {
      return [];
    }
  }

  static Future<List<SpeciesModel>> homeSuggestion(Database db, int max) async {
    try {
      final query = '''
          select * from (
            select * from (
              select
              [main].[specie].[id],
              [main].[common_name].[name],
              [main].[specie].[scientific_name],
              [main].[media].[path]
              from [main].[specie]
              inner join [main].[common_name] on [main].[specie].[id] = [main].[common_name].[fk_specie_]
              inner join [main].[media] on [main].[specie].[id] = [main].[media].[fk_specie_]
              inner join [main].[main_image] on [main].[media].[id] = [main].[main_image].[fk_media_]
              order by random()
            )
            group by id
          )
          order by random()
          limit $max;
      ''';
      final result = await db.rawQuery(query);
      final results = <SpeciesModel>[];
      for (var item in result) {
        results.add(SpeciesModel.fromSimpleSearch(item));
      }
      return results;
    } catch (e) {
      return [];
    }
  }
}
