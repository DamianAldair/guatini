import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:guatini/models/specie_model.dart';
import 'package:guatini/pages/species_details_page.dart';
import 'package:guatini/providers/db_provider.dart';
import 'package:guatini/providers/search_provider.dart';
import 'package:sqflite/sqflite.dart';

class SimilarsPage extends StatelessWidget {
  final SpeciesModel species;

  const SimilarsPage(this.species, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${AppLocalizations.of(context).similarTo}:'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              right: 10.0,
              bottom: kToolbarHeight / 3,
            ),
            child: Text(
              species.scientificName ?? '',
              style: Theme.of(context).textTheme.titleMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: DbProvider.database,
        builder: (_, AsyncSnapshot<Database?> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final db = snapshot.data!;
          return FutureBuilder(
            future: SearchProvider.getSimilarSpecies(db, species.id!),
            builder: (_, AsyncSnapshot<List<SpeciesModel>> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final list = snapshot.data!;
              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (_, int i) {
                  final s = list[i];
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
                      child: Text(s.searchName.toString()),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Text(s.scientificName.toString()),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SpeciesDetailsPage(s.id),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
