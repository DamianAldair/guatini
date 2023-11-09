import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:guatini/models/class_model.dart';
import 'package:guatini/models/conservationstatus_model.dart';
import 'package:guatini/models/domain_model.dart';
import 'package:guatini/models/family_model.dart';
import 'package:guatini/models/genus_model.dart';
import 'package:guatini/models/kindom_model.dart';
import 'package:guatini/models/order_model.dart';
import 'package:guatini/models/phylum_model.dart';
import 'package:guatini/models/specie_model.dart';
import 'package:guatini/pages/species_details_page.dart';
import 'package:guatini/providers/db_provider.dart';
import 'package:guatini/providers/search_provider.dart';
import 'package:guatini/util/parse.dart';
import 'package:sqflite/sqflite.dart';

class CharacteristicPage extends StatelessWidget {
  final String title;
  final dynamic instance;

  const CharacteristicPage({
    Key? key,
    required this.title,
    required this.instance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isTaxonomy = instance is DomainModel ||
        instance is KindomModel ||
        instance is PhylumModel ||
        instance is ClassModel ||
        instance is OrderModel ||
        instance is FamilyModel ||
        instance is GenusModel;
    final desc = isTaxonomy ? instance.description : null;
    final subtitle = instance is ConservationStatusModel ? instance.status.toString() : instance.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Scrollbar(
        radius: const Radius.circular(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20.0),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 25.0),
              ),
              if (desc != null)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 20.0,
                  ),
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    desc,
                    textAlign: TextAlign.justify,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  '${AppLocalizations.of(context).moreWith} $title: $subtitle',
                  textAlign: TextAlign.center,
                ),
              ),
              FutureBuilder(
                future: DbProvider.database,
                builder: (_, AsyncSnapshot<Database?> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final db = snapshot.data!;
                  return FutureBuilder<List<SpeciesModel>>(
                    future: isTaxonomy
                        ? SearchProvider.moreSpeciesFromTaxonomy(
                            db,
                            instance,
                          )
                        : SearchProvider.moreSpeciesFromOther(
                            db,
                            instance,
                          ),
                    builder: (_, AsyncSnapshot<List<SpeciesModel>> snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final list = joinEquals(snapshot.data!);
                      return list.isEmpty
                          ? Text(
                              AppLocalizations.of(context).noResults,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 20.0),
                            )
                          : ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: list.length,
                              itemBuilder: (_, int i) {
                                final species = list[i];
                                return ListTile(
                                  leading: SizedBox(
                                    height: 60.0,
                                    width: 60.0,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5.0),
                                      child: species.image,
                                    ),
                                  ),
                                  title: Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Text(species.searchName.toString()),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                                    child: Text(species.scientificName.toString()),
                                  ),
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => SpeciesDetailsPage(species.id),
                                    ),
                                  ),
                                );
                              },
                            );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
