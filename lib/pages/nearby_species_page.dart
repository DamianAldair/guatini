import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:guatini/models/specie_model.dart';
import 'package:guatini/pages/species_details_page.dart';
import 'package:guatini/providers/db_provider.dart';
import 'package:guatini/providers/search_provider.dart';
import 'package:guatini/util/extensions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class NearbySpeciesPage extends StatelessWidget {
  final MapLatLng point;

  const NearbySpeciesPage(this.point, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).nearbySpecies),
      ),
      body: FutureBuilder(
        future: DbProvider.database,
        builder: (_, AsyncSnapshot<Database?> snapshot) {
          const placeholder = Center(child: CircularProgressIndicator());
          if (snapshot.hasError) {
            return Center(
              child: Text(
                AppLocalizations.of(context).errorObtainingInfo,
                textAlign: TextAlign.center,
              ),
            );
          }
          if (!snapshot.hasData) return placeholder;
          final db = snapshot.data!;
          return FutureBuilder(
            future: SearchProvider.getAllDistributions(db),
            builder: (_, AsyncSnapshot<List<SpeciesModel>> snapshot) {
              if (snapshot.hasError) return placeholder;
              if (!snapshot.hasData) return placeholder;
              final list = <SpeciesModel>[];
              for (final item in snapshot.data!) {
                if (item.distribution != null) {
                  for (final d in item.distribution!) {
                    if (d.contains(point)) {
                      list.add(item);
                      break;
                    }
                  }
                }
              }
              if (list.isEmpty) {
                return Center(
                  child: Text(
                    AppLocalizations.of(context).noSpeciesNearby,
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return Scrollbar(
                radius: const Radius.circular(100.0),
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (_, int i) {
                    final s = list[i];
                    final title =
                        s.searchName == null || s.searchName!.isEmpty ? s.scientificName ?? '' : s.searchName!;
                    final subtitle = s.searchName == null || s.searchName!.isEmpty ? '' : s.scientificName ?? '';
                    return ListTile(
                      leading: SizedBox(
                        height: 60.0,
                        width: 60.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: s.image,
                        ),
                      ),
                      title: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(title),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Text(subtitle),
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SpeciesDetailsPage(s.id),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
