import 'dart:io';

import 'package:guatini/models/abundance_model.dart';
import 'package:guatini/models/activity_model.dart';
import 'package:guatini/models/ad_model.dart';
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
import 'package:guatini/models/sql_table_model.dart';
import 'package:guatini/providers/userpreferences_provider.dart';
import 'package:guatini/util/parse.dart';
import 'package:guatini/util/util_data.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

abstract class SearchProvider {
  static String _excludeOnline(String column) {
    final wheres = protocols.map((p) => '($column NOT LIKE \'$p://%\' OR [main].[media].[fk_type_] IS NULL)');
    return wheres.join(' AND\n');
  }

  static Future<List<AdModel>> getAds(Database db) async {
    const query = 'select [ads].* from [main].[ads] order by [main].[ads].[id];';
    final result = await db.rawQuery(query);
    if (result.isEmpty) return [];
    try {
      return result.map((map) => AdModel.fromMap(map)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<List<SqlTableModel>> getTables(Database db) async {
    try {
      const query = '''
      SELECT name, (
        SELECT group_concat(name,'/')
        FROM PRAGMA_TABLE_INFO(m.name)
      ) as columns
      FROM sqlite_master AS m
      WHERE type='table';
    ''';
      final result = await db.rawQuery(query);
      if (result.isEmpty) return [];
      return result.map((map) => SqlTableModel.fromMap(map)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<LicenseModel?> getLicense(Database db, int id) async {
    try {
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
    } catch (_) {
      return null;
    }
  }

  static Future<List<AuthorModel>> getAuthors(Database db, int id) async {
    try {
      final query = '''
      SELECT 
      [main].[author].[id], 
      [main].[author].[name], 
      [main].[author].[description]
      FROM   [main].[author]
      WHERE  [main].[author].[id] = $id;
    ''';
      final result = await db.rawQuery(query);
      return result.map((r) => AuthorModel.fromMap(r)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<MainImageModel?> _getMainImage(Database db, int speciesId) async {
    try {
      final query = '''
      select 
        [main].[main_image].[fk_media_] AS [id], 
        [main].[media].[path], 
        [main].[media].[date_capture], 
        [main].[media].[lat], 
        [main].[media].[lon], 
        [main].[media_author].[fk_author_] AS [authorId], 
        [main].[media].[fk_license_] AS [licenseId]
      from [main].[media]
        inner join [main].[main_image] on [main].[media].[id] = [main].[main_image].[fk_media_]
        inner join [main].[media_author] on [main].[media].[id] = [main].[media_author].[fk_media_]
      where ${_excludeOnline('[main].[media].[path]')} AND
            [main].[media].[fk_specie_] = $speciesId;
    ''';
      final result = await db.rawQuery(query);
      return result.isNotEmpty ? MainImageModel.fromMap(result.first) : null;
    } catch (_) {
      return null;
    }
  }

  static Future<List<CommonNameModel>> _getCommonNames(Database db, int speciesId) async {
    try {
      final query = '''
        select
        [main].[common_name].[id],
        [main].[common_name].[name]
        from [main].[specie]
        inner join [main].[common_name] on [main].[specie].[id] = [main].[common_name].[fk_specie_]
        where [main].[specie].[id] = $speciesId
        group by [main].[common_name].[name];
    ''';
      final result = await db.rawQuery(query);
      return result.map((map) => CommonNameModel.fromMap(map)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<GenusModel?> _getGenus(Database db, int? speciesId) async {
    try {
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
    } catch (_) {
      return null;
    }
  }

  static Future<FamilyModel?> _getFamily(Database db, int? genusId) async {
    try {
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
    } catch (_) {
      return null;
    }
  }

  static Future<OrderModel?> _getOrder(Database db, int? familyId) async {
    try {
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
    } catch (_) {
      return null;
    }
  }

  static Future<ClassModel?> _getClass(Database db, int? orderId) async {
    try {
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
    } catch (_) {
      return null;
    }
  }

  static Future<PhylumModel?> _getPhylum(Database db, int? classId) async {
    try {
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
    } catch (_) {
      return null;
    }
  }

  static Future<KindomModel?> _getKindom(Database db, int? phylumId) async {
    try {
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
    } catch (_) {
      return null;
    }
  }

  static Future<DomainModel?> _getDomain(Database db, int? kindomId) async {
    try {
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
    } catch (_) {
      return null;
    }
  }

  static Future<ConservationStatusModel?> _getConservationStatus(Database db, int? speciesId) async {
    try {
      final query = '''
        select
        [main].[conservation_status].[id], 
        [main].[conservation_status].[status]
        from   [main].[specie]
        inner join [main].[conservation_status] on [main].[conservation_status].[id] = [main].[specie].[fk_coservation_status_]
        where [main].[specie].[id] = $speciesId;
    ''';
      final result = speciesId != null ? await db.rawQuery(query) : [];
      return result.isNotEmpty ? ConservationStatusModel.fromMap(result.first) : null;
    } catch (_) {
      return null;
    }
  }

  static Future<EndemismModel?> _getEndemism(Database db, int? speciesId) async {
    try {
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
    } catch (_) {
      return null;
    }
  }

  static Future<AbundanceModel?> _getAbundance(Database db, int? speciesId) async {
    try {
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
    } catch (_) {
      return null;
    }
  }

  static Future<List<ActivityModel>> _getActivities(Database db, int speciesId) async {
    try {
      final query = '''
        select
        [main].[activity].[id],
        [main].[activity].[activity]
        from [main].[specie]
        inner join [main].[specie_activity] on [main].[specie].[id] = [main].[specie_activity].[fk_specie_]
        inner join [main].[activity] on [main].[activity].[id] = [main].[specie_activity].[fk_activity_]
        where [main].[specie].[id] = $speciesId
        group by [main].[activity].[activity];
    ''';
      final result = await db.rawQuery(query);
      return result.map((map) => ActivityModel.fromMap(map)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<List<HabitatModel>> _getHabitats(Database db, int speciesId) async {
    try {
      final query = '''
        select
        [main].[habitat].[id],
        [main].[habitat].[habitat]
        from [main].[specie]
        inner join [main].[specie_habitat] on [main].[specie].[id] = [main].[specie_habitat].[fk_specie_]
        inner join [main].[habitat] on [main].[habitat].[id] = [main].[specie_habitat].[fk_habitat_]
        where [main].[specie].[id] = $speciesId
        group by [main].[habitat].[habitat];
    ''';
      final result = await db.rawQuery(query);
      return result.map((map) => HabitatModel.fromMap(map)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<List<DietModel>> _getDiets(Database db, int speciesId) async {
    try {
      final query = '''
        select
        [main].[diet].[id],
        [main].[diet].[diet]
        from [main].[specie]
        inner join [main].[specie_diet] on [main].[specie].[id] = [main].[specie_diet].[fk_specie_]
        inner join [main].[diet] on [main].[diet].[id] = [main].[specie_diet].[fk_diet_]
        where [main].[specie].[id] = $speciesId
        group by [main].[diet].[diet];
    ''';
      final result = await db.rawQuery(query);
      return result.map((map) => DietModel.fromMap(map)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<List<MediaModel>> _getMedias(Database db, int speciesId) async {
    try {
      final query = '''
        SELECT 
        [main].[media].[id], 
        [main].[media].[path], 
        [main].[media].[date_capture], 
        [main].[media].[lat], 
        [main].[media].[lon], 
        [main].[author].[id] AS [authorId], 
        [main].[media].[fk_license_] AS [licenseId], 
        [main].[media].[fk_type_]
        FROM [main].[media]
        INNER JOIN [main].[media_author] ON [main].[media].[id] = [main].[media_author].[fk_media_]
        INNER JOIN [main].[author] ON [main].[author].[id] = [main].[media_author].[fk_author_]
        INNER JOIN [main].[type] ON [main].[type].[id] = [main].[media].[fk_type_]
        WHERE [main].[media].[fk_specie_] = $speciesId
        group by [main].[media].[path];
    ''';
      final result = await db.rawQuery(query);
      final medias = <MediaModel>[];
      for (Map<String, Object?> item in result) {
        MediaModel media = MediaModel.fromMap(item);
        MediaTypeModel? type = await _getMediaType(db, media.id);
        media.type = type;
        medias.add(media);
      }
      return medias;
    } catch (_) {
      return [];
    }
  }

  static Future<MediaTypeModel?> _getMediaType(Database db, int? mediaId) async {
    try {
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
    } catch (_) {
      return null;
    }
  }

  static Future<SpeciesModel?> getSpecie(Database db, int speciesId) async {
    try {
      final query = '''
          select
          [main].[specie].[id],
          [main].[specie].[scientific_name],
          [main].[specie].[dimorphism],
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

  static Future<List<SpeciesModel>> getSimilarSpecies(Database db, int speciesId) async {
    try {
      final query = '''
        select 
          [main].[specie].[id], 
          [main].[common_name].[name], 
          [main].[specie].[scientific_name],
          [main].[media].[path]
        from [main].[specie]
          left join [main].[common_name] on [main].[specie].[id] = [main].[common_name].[fk_specie_]
          inner join [main].[specie_similar] on [main].[specie].[id] = [main].[specie_similar].[id_similar]
          left join [main].[media] on [main].[specie].[id] = [main].[media].[fk_specie_]
        where ([main].[media].[fk_type_] IS 1 OR [main].[media].[fk_type_] IS NULL) AND
              ${_excludeOnline('[main].[media].[path]')} AND
              [main].[specie_similar].[fk_specie_] = $speciesId
        group by [main].[specie].[scientific_name]
        order by [main].[specie].[id];
      ''';
      final result = await db.rawQuery(query);
      return result.map((r) => SpeciesModel.fromSimpleSearch(r)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<List<SpeciesModel>> searchSpecie(Database db, String search) async {
    try {
      final query = '''
          select
          [main].[specie].[id],
          [main].[common_name].[name],
          [main].[specie].[scientific_name],
          [main].[media].[path]
          from [main].[specie]
          left join [main].[common_name] on [main].[specie].[id] = [main].[common_name].[fk_specie_]
          left join [main].[media] on [main].[specie].[id] = [main].[media].[fk_specie_]
          where ([main].[media].[fk_type_] IS 1 OR [main].[media].[fk_type_] IS NULL) AND
            ${_excludeOnline('[main].[media].[path]')} AND
            ([main].[common_name].[name] LIKE '%$search%' OR [main].[specie].[scientific_name] LIKE '%$search%')
          group by [main].[specie].[scientific_name]
          order by [main].[specie].[scientific_name];
      ''';
      final result = await db.rawQuery(query);
      return result.map((r) => SpeciesModel.fromSimpleSearch(r)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<List<SpeciesModel>> homeSuggestion(Database db, int max) async {
    try {
      final query = '''
          select * from (
            select * from (
              select distinct
                [main].[specie].[id], 
                [main].[common_name].[name], 
                [main].[specie].[scientific_name], 
                [main].[media].[path]
              from [main].[specie]
                left join [main].[common_name] on [main].[specie].[id] = [main].[common_name].[fk_specie_]
                inner join [main].[media] on [main].[specie].[id] = [main].[media].[fk_specie_]
                inner join [main].[type] on [main].[type].[id] = [main].[media].[fk_type_]
              where ${_excludeOnline('[main].[media].[path]')} AND
                ([main].[media].[fk_type_] IS 1 OR [main].[media].[fk_type_] IS NULL)
              order by random()
            )
            group by scientific_name
          )
          order by random()
          limit $max;
      ''';
      final result = await db.rawQuery(query);
      return result.map((r) => SpeciesModel.fromSimpleSearch(r)).toList();
    } catch (e) {
      return Future.error(Exception());
    }
  }

  static Future<List<SpeciesModel>> homeSuggestionWithoutImages(Database db, int max) async {
    try {
      final query = '''
          select * from (
            select * from (
              select distinct
                [main].[specie].[id], 
                [main].[common_name].[name], 
                [main].[specie].[scientific_name]
              from [main].[specie]
                left join [main].[common_name] on [main].[specie].[id] = [main].[common_name].[fk_specie_]
              order by random()
            )
            group by scientific_name
          )
          order by random()
          limit $max;
      ''';
      final result = await db.rawQuery(query);
      return result.map((r) => SpeciesModel.fromSimpleSearch(r)).toList();
    } catch (e) {
      return Future.error(Exception());
    }
  }

  static Future<List<MediaModel>> moreMedia(
    Database db, {
    int? authorId,
    int? licenseId,
  }) async {
    try {
      String? query;
      if (authorId != null) {
        query = '''
          select 
            [main].[media].[id], 
            [main].[media].[path], 
            [main].[media].[lat], 
            [main].[media].[lon], 
            [main].[media].[date_capture], 
            [main].[media].[fk_specie_], 
            [main].[type].[type]
          from [main].[media]
            inner join [main].[media_author] on [main].[media].[id] = [main].[media_author].[fk_media_]
            inner join [main].[type] on [main].[type].[id] = [main].[media].[fk_type_]
          where${_excludeOnline('[main].[media].[path]')} AND
            [main].[media_author].[fk_author_] = $authorId
          group by [main].[media].[path];
        ''';
      }
      if (licenseId != null) {
        query = '''
          select 
            [main].[media].[id], 
            [main].[media].[path], 
            [main].[media].[lat], 
            [main].[media].[lon], 
            [main].[media].[date_capture], 
            [main].[media].[fk_specie_], 
            [main].[type].[type]
          from [main].[media]
            inner join [main].[type] on [main].[type].[id] = [main].[media].[fk_type_]
          where ${_excludeOnline('[main].[media].[path]')} AND
            [main].[media].[fk_license_] = $licenseId
          group by [main].[media].[path];
        ''';
      }
      final result = await db.rawQuery(query!);
      final results = <MediaModel>[];
      for (var item in result) {
        results.add(MediaModel.fromMore(item));
      }
      return results;
    } catch (e) {
      return [];
    }
  }

  static Future<List<SpeciesModel>> moreSpeciesFromTaxonomy(
    Database db,
    dynamic taxonomyModel,
  ) async {
    try {
      String sqlTable = '';
      switch (taxonomyModel.runtimeType) {
        case DomainModel:
          sqlTable = 't_domain';
          break;
        case KindomModel:
          sqlTable = 't_kindom';
          break;
        case PhylumModel:
          sqlTable = 't_phylum';
          break;
        case ClassModel:
          sqlTable = 't_class';
          break;
        case OrderModel:
          sqlTable = 't_order';
          break;
        case FamilyModel:
          sqlTable = 't_family';
          break;
        case GenusModel:
          sqlTable = 't_genus';
          break;
      }
      final query = '''
        select * from (
          select 
            [main].[specie].[id], 
            [main].[common_name].[name], 
            [main].[specie].[scientific_name], 
            [main].[media].[path],
            [main].[$sqlTable].[id] as sqlTable
          from [main].[specie]
            left join [main].[common_name] on [main].[specie].[id] = [main].[common_name].[fk_specie_]
            left join [main].[media] on [main].[specie].[id] = [main].[media].[fk_specie_]
            inner join [main].[t_genus] on [main].[t_genus].[id] = [main].[specie].[fk_t_genus_]
            inner join [main].[t_family] on [main].[t_family].[id] = [main].[t_genus].[fk_t_family_]
            inner join [main].[t_order] on [main].[t_order].[id] = [main].[t_family].[fk_t_order_]
            inner join [main].[t_class] on [main].[t_class].[id] = [main].[t_order].[fk_t_class_]
            inner join [main].[t_phylum] on [main].[t_phylum].[id] = [main].[t_class].[fk_t_phylum_]
            inner join [main].[t_kindom] on [main].[t_kindom].[id] = [main].[t_phylum].[fk_t_kindom_]
            inner join [main].[t_domain] on [main].[t_domain].[id] = [main].[t_kindom].[fk_t_domain_]
          where ([main].[media].[fk_type_] IS 1 OR [main].[media].[fk_type_] IS NULL) AND
                ${_excludeOnline('[main].[media].[path]')}
          group by [main].[specie].[scientific_name]
          order by [main].[common_name].[name]
      ) where sqlTable = ${taxonomyModel.id};
      ''';
      final result = await db.rawQuery(query);
      return result.map((r) => SpeciesModel.fromSimpleSearch(r)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<List<SpeciesModel>> moreSpeciesFromOther(
    Database db,
    dynamic model,
  ) async {
    try {
      String prop = '';
      switch (model.runtimeType) {
        case ConservationStatusModel:
          prop = 'fk_coservation_status_';
          break;
        case AbundanceModel:
          prop = 'fk_abundance_';
          break;
        case EndemismModel:
          prop = 'fk_endemism_';
          break;
      }
      final String query;
      if (prop.isNotEmpty) {
        query = '''
          select 
            [main].[specie].[id], 
            [main].[common_name].[name], 
            [main].[specie].[scientific_name], 
            [main].[media].[path],
            [main].[media].[fk_type_] as type
          from [main].[specie]
            left join [main].[common_name] on [main].[specie].[id] = [main].[common_name].[fk_specie_]
            left join [main].[media] on [main].[specie].[id] = [main].[media].[fk_specie_]
          where ([main].[media].[fk_type_] IS 1 OR [main].[media].[fk_type_] IS NULL) AND
                ${_excludeOnline('[main].[media].[path]')} AND
                [main].[specie].[$prop] = ${model.id}
          group by [main].[specie].[scientific_name]
          order by [main].[common_name].[name];
        ''';
      } else {
        String join = '';
        String where = '';
        switch (model.runtimeType) {
          case ActivityModel:
            join =
                'inner join [main].[specie_activity] on [main].[specie].[id] = [main].[specie_activity].[fk_specie_]';
            where = '[main].[specie_activity].[fk_activity_]';
            break;
          case HabitatModel:
            join = 'inner join [main].[specie_habitat] on [main].[specie].[id] = [main].[specie_habitat].[fk_specie_]';
            where = '[main].[specie_habitat].[fk_habitat_]';
            break;
          case DietModel:
            join = 'inner join [main].[specie_diet] on [main].[specie].[id] = [main].[specie_diet].[fk_specie_]';
            where = '[main].[specie_diet].[fk_diet_]';
            break;
        }
        query = '''
          select 
            [main].[specie].[id], 
            [main].[common_name].[name], 
            [main].[specie].[scientific_name], 
            [main].[media].[path],
            [main].[media].[fk_type_] as type
          from [main].[specie]
            left join [main].[common_name] on [main].[specie].[id] = [main].[common_name].[fk_specie_]
            left join [main].[media] on [main].[specie].[id] = [main].[media].[fk_specie_]
            $join
          where $where = ${model.id} AND
                ([main].[media].[fk_type_] IS 1 OR [main].[media].[fk_type_] IS NULL) AND
                ${_excludeOnline('[main].[media].[path]')}
          group by [main].[specie].[scientific_name]
          order by [main].[specie].[scientific_name];
        ''';
      }
      final result = await db.rawQuery(query);
      return result.map((r) => SpeciesModel.fromSimpleSearch(r)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<int?> getIdFromScientificName(Database db, String scientificName) async {
    try {
      final query = '''
          select [main].[specie].[id]
          from   [main].[specie]
          where  lower([main].[specie].[scientific_name]) = lower('$scientificName')
          group by [main].[specie].[id];
      ''';
      final result = await db.rawQuery(query);
      if (result.isEmpty) return null;
      return result.first["id"] as int;
    } catch (e) {
      return null;
    }
  }

  static Future<GenusModel?> getGenusByName(Database db, String name) async {
    try {
      final query = '''
        select 
               [main].[t_genus].[id], 
               [main].[t_genus].[name], 
               [main].[t_genus].[description]
        from   [main].[t_genus]
        where  lower([main].[t_genus].[name]) = lower('$name')
        group by [main].[t_genus].[name];
      ''';
      final result = await db.rawQuery(query);
      if (result.isEmpty) return null;
      return GenusModel.fromMap(result.first);
    } catch (e) {
      return null;
    }
  }

  static Future<FamilyModel?> getFamilyByName(Database db, String name) async {
    try {
      final query = '''
        select 
               [main].[t_family].[id], 
               [main].[t_family].[name], 
               [main].[t_family].[description]
        from   [main].[t_family]
        where  lower([main].[t_family].[name]) = lower('$name')
        group by [main].[t_family].[name];
      ''';
      final result = await db.rawQuery(query);
      if (result.isEmpty) return null;
      return FamilyModel.fromMap(result.first);
    } catch (e) {
      return null;
    }
  }

  static Future<OrderModel?> getOrderByName(Database db, String name) async {
    try {
      final query = '''
        select 
               [main].[t_order].[id], 
               [main].[t_order].[name], 
               [main].[t_order].[description]
        from   [main].[t_order]
        where  lower([main].[t_order].[name]) = lower('$name')
        group by [main].[t_order].[name];
      ''';
      final result = await db.rawQuery(query);
      if (result.isEmpty) return null;
      return OrderModel.fromMap(result.first);
    } catch (e) {
      return null;
    }
  }

  static Future<ClassModel?> getClassByName(Database db, String name) async {
    try {
      final query = '''
        select 
               [main].[t_class].[id], 
               [main].[t_class].[name], 
               [main].[t_class].[description]
        from   [main].[t_class]
        where  lower([main].[t_class].[name]) = lower('$name')
        group by [main].[t_class].[name];
      ''';
      final result = await db.rawQuery(query);
      if (result.isEmpty) return null;
      return ClassModel.fromMap(result.first);
    } catch (e) {
      return null;
    }
  }

  static Future<PhylumModel?> getPhyumByName(Database db, String name) async {
    try {
      final query = '''
        select 
               [main].[t_phylum].[id], 
               [main].[t_phylum].[name], 
               [main].[t_phylum].[description]
        from   [main].[t_phylum]
        where  lower([main].[t_phylum].[name]) = lower('$name')
        group by [main].[t_phylum].[name];
      ''';
      final result = await db.rawQuery(query);
      if (result.isEmpty) return null;
      return PhylumModel.fromMap(result.first);
    } catch (e) {
      return null;
    }
  }

  static Future<KindomModel?> getKingdomByName(Database db, String name) async {
    try {
      final query = '''
        select 
               [main].[t_kindom].[id], 
               [main].[t_kindom].[name], 
               [main].[t_kindom].[description]
        from   [main].[t_kindom]
        where  lower([main].[t_kindom].[name]) = lower('$name')
        group by [main].[t_kindom].[name];
      ''';
      final result = await db.rawQuery(query);
      if (result.isEmpty) return null;
      return KindomModel.fromMap(result.first);
    } catch (e) {
      return null;
    }
  }

  static Future<DomainModel?> getDomainByName(Database db, String name) async {
    try {
      final query = '''
        select 
               [main].[t_domain].[id], 
               [main].[t_domain].[name], 
               [main].[t_domain].[description]
        from   [main].[t_domain]
        where  lower([main].[t_domain].[name]) = lower('$name')
        group by [main].[t_domain].[name];
      ''';
      final result = await db.rawQuery(query);
      if (result.isEmpty) return null;
      return DomainModel.fromMap(result.first);
    } catch (e) {
      return null;
    }
  }

  static Future<EndemismModel?> getEndemismByName(Database db, String name) async {
    try {
      final query = '''
        select 
          [main].[endemism].[id], 
          [main].[endemism].[zone]
        from   [main].[endemism]
        where  lower([main].[endemism].[zone]) = lower('$name')
        group by [main].[endemism].[zone];
      ''';
      final result = await db.rawQuery(query);
      if (result.isEmpty) return null;
      return EndemismModel.fromMap(result.first);
    } catch (e) {
      return null;
    }
  }

  static Future<AbundanceModel?> getAbundanceByName(Database db, String name) async {
    try {
      final query = '''
        select 
          [main].[abundance].[id], 
          [main].[abundance].[abundance]
        from   [main].[abundance]
        where  lower([main].[abundance].[abundance]) = lower('$name')
        group by [main].[abundance].[abundance];
      ''';
      final result = await db.rawQuery(query);
      if (result.isEmpty) return null;
      return AbundanceModel.fromMap(result.first);
    } catch (e) {
      return null;
    }
  }

  static Future<ActivityModel?> getActivityByName(Database db, String name) async {
    try {
      final query = '''
        select 
          [main].[activity].[id], 
          [main].[activity].[activity]
        from   [main].[activity]
        where  lower([main].[activity].[activity]) = lower('$name')
        group by [main].[activity].[activity];
      ''';
      final result = await db.rawQuery(query);
      if (result.isEmpty) return null;
      return ActivityModel.fromMap(result.first);
    } catch (e) {
      return null;
    }
  }

  static Future<HabitatModel?> getHabitatByName(Database db, String name) async {
    try {
      final query = '''
        select 
          [main].[habitat].[id], 
          [main].[habitat].[habitat]
        from   [main].[habitat]
        where  lower([main].[habitat].[habitat]) = lower('$name')
        group by [main].[habitat].[habitat];
      ''';
      final result = await db.rawQuery(query);
      if (result.isEmpty) return null;
      return HabitatModel.fromMap(result.first);
    } catch (e) {
      return null;
    }
  }

  static Future<DietModel?> getDietByName(Database db, String name) async {
    try {
      final query = '''
        select 
          [main].[diet].[id], 
          [main].[diet].[diet]
        from   [main].[diet]
        where  lower([main].[diet].[diet]) = lower('$name')
        group by [main].[diet].[diet];
      ''';
      final result = await db.rawQuery(query);
      if (result.isEmpty) return null;
      return DietModel.fromMap(result.first);
    } catch (e) {
      return null;
    }
  }

  static Future<List<SpeciesModel>> getAllDistributions(Database db) async {
    try {
      final query = '''
        select 
          [main].[specie].[id], 
          [main].[specie].[scientific_name], 
          [main].[common_name].[name], 
          [main].[media].[path], 
          [main].[distribution].[polygon] as distribution
        from   [main].[distribution]
          inner join [main].[specie_distribution] on [main].[distribution].[id] = [main].[specie_distribution].[fk_distribution_]
          inner join [main].[specie] on [main].[specie].[id] = [main].[specie_distribution].[fk_specie_]
          left join [main].[common_name] on [main].[specie].[id] = [main].[common_name].[fk_specie_]
          left join [main].[media] on [main].[specie].[id] = [main].[media].[fk_specie_]
        where ([main].[media].[fk_type_] IS 1 OR [main].[media].[fk_type_] IS NULL) AND
          ${_excludeOnline('[main].[media].[path]')}
        group by [main].[specie].[scientific_name]
        order by [main].[specie].[id];
      ''';
      final result = await db.rawQuery(query);
      return result.map((json) => SpeciesModel.fromSimpleSearch(json)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<(List<List<MapLatLng>>, List<String>)> getDistribution(Database db, int speciesId) async {
    try {
      final query = '''
      select 
        [main].[distribution].[id], 
        [main].[distribution].[polygon], 
        [main].[distribution].[description]
      from [main].[distribution]
        inner join [main].[specie_distribution] on [main].[distribution].[id] = [main].[specie_distribution].[fk_distribution_]
      where [main].[specie_distribution].[fk_specie_] = $speciesId
      group by [main].[distribution].[polygon];
      ''';
      final result = await db.rawQuery(query);
      final polygons = <List<MapLatLng>>[];
      final descriptions = <String>[];
      for (final r in result) {
        polygons.addAll(toPolygons(r['polygon'] as String));
        descriptions.add(r['description'] as String);
      }
      return (polygons, descriptions);
    } catch (_) {
      return (<List<MapLatLng>>[], <String>[]);
    }
  }

  static Future<List<List>> getGameOptions(Database db, MediaType mediaType, [int force = 4]) async {
    final type = switch (mediaType) {
      MediaType.image => 1,
      MediaType.video => 2,
      MediaType.audio => 3,
    };
    final asType = switch (mediaType) {
      MediaType.image => 'path',
      MediaType.video => 'video',
      MediaType.audio => 'audio',
    };
    try {
      final query = '''
          select
            [main].[specie].[id],
            [main].[specie].[scientific_name],
            [main].[common_name].[name],
            [main].[media].[path] as $asType
          from [main].[specie]
            inner join [main].[common_name] on [main].[specie].[id] = [main].[common_name].[fk_specie_]
            inner join [main].[media] on [main].[specie].[id] = [main].[media].[fk_specie_]
          where [main].[media].[fk_type_] = $type AND
            ${_excludeOnline('[main].[media].[path]')}
          group by [main].[specie].[scientific_name]
          order by RANDOM();
      ''';
      final result = await db.rawQuery(query);
      final prefs = UserPreferences();
      final species = <SpeciesModel>[];
      final mediaPaths = <String>[];
      for (final json in result) {
        final mediaPath = json[asType] as String;
        final db = prefs.dbPathNotifier.value!;
        final path = p.join(File(db).parent.path, mediaPath).replaceAll('\\', '/');
        if (await File(path).exists()) {
          species.add(SpeciesModel.fromSimpleSearch(json));
          mediaPaths.add(mediaPath);
        }
      }
      if (species.length < force) return [<SpeciesModel>[], <String>[]];
      return [species, mediaPaths];
    } catch (_) {
      return [<SpeciesModel>[], <String>[]];
    }
  }
}
