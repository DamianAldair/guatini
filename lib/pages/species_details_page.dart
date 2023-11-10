import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:guatini/models/specie_model.dart';
import 'package:guatini/pages/wiki_search_page.dart';
import 'package:guatini/providers/db_provider.dart';
import 'package:guatini/providers/search_provider.dart';
import 'package:guatini/providers/userpreferences_provider.dart';
import 'package:guatini/providers/wikipedia_provider.dart';
import 'package:guatini/widgets/info_card_widget.dart';
import 'package:guatini/widgets/media_widgets.dart';
import 'package:sqflite/sqflite.dart';

class SpeciesDetailsPage extends StatelessWidget {
  final int? speciesId;

  const SpeciesDetailsPage(this.speciesId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prefs = UserPreferences();
    SpeciesModel? species;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).speciesDetails),
        // actions: [
        // IconButton(
        //   tooltip: AppLocalizations.of(context).exportPdf,
        //   icon: const Icon(Icons.picture_as_pdf_rounded),
        //   onPressed: () {
        //     if (species != null) {
        //       showDialog(
        //         context: context,
        //         builder: (_) => savePdfDialog(context, species!),
        //       );
        //     }
        //   },
        // ),
        // ],
      ),
      body: speciesId == null
          ? Center(child: Text(AppLocalizations.of(context).errorObtainingInfo))
          : FutureBuilder(
              future: DbProvider.database,
              builder: (_, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final db = snapshot.data as Database;
                return FutureBuilder(
                  future: SearchProvider.getSpecie(db, speciesId!),
                  builder: (_, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    species = snapshot.data as SpeciesModel;
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          MainImage(species!),
                          Text(
                            species!.commonNamesAsString,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Text(species!.scientificName.toString()),
                          const SizedBox(height: 10.0),
                          InfoCard(
                            title: AppLocalizations.of(context).taxDomain,
                            instance: species!.taxdomain,
                          ),
                          InfoCard(
                            title: AppLocalizations.of(context).taxKingdom,
                            instance: species!.taxkindom,
                          ),
                          InfoCard(
                            title: AppLocalizations.of(context).taxPhylum,
                            instance: species!.taxphylum,
                          ),
                          InfoCard(
                            title: AppLocalizations.of(context).taxClass,
                            instance: species!.taxclass,
                          ),
                          InfoCard(
                            title: AppLocalizations.of(context).taxOrder,
                            instance: species!.taxorder,
                          ),
                          InfoCard(
                            title: AppLocalizations.of(context).taxFamily,
                            instance: species!.taxfamily,
                          ),
                          InfoCard(
                            title: AppLocalizations.of(context).taxGenus,
                            instance: species!.taxgenus,
                          ),
                          ConservationStateCard(
                            status: species!.conservationStatus,
                          ),
                          InfoCard(
                            title: AppLocalizations.of(context).endemism,
                            instance: species!.endemism,
                          ),
                          InfoCard(
                            title: AppLocalizations.of(context).abundance,
                            instance: species!.abundance,
                          ),
                          InfoCard(
                            title: AppLocalizations.of(context).activity,
                            instances: species!.activities,
                          ),
                          InfoCard(
                            title: AppLocalizations.of(context).habitat,
                            instances: species!.habitats,
                          ),
                          InfoCard(
                            title: AppLocalizations.of(context).diet,
                            instances: species!.diets,
                          ),
                          AudioCard(species!.medias),
                          Dimorphism(species!.dimorphism),
                          Description(species!.description.toString()),
                          Gallery(
                            species!.medias,
                            mainImageId: species!.mainImage != null ? species!.mainImage!.id : null,
                          ),
                          const SizedBox(height: 20.0),
                          if (prefs.wikipediaOnline)
                            OutlinedButton(
                              child: Text(AppLocalizations.of(context).searchOnWikipedia),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MediawikiSearchPage(
                                    source: MediawikiSearch.wikipedia,
                                    query: species!.scientificName,
                                  ),
                                ),
                              ),
                            ),
                          if (prefs.ecuredOnline)
                            OutlinedButton(
                              child: Text(AppLocalizations.of(context).searchOnEcured),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MediawikiSearchPage(
                                    source: MediawikiSearch.ecured,
                                    query: species!.scientificName,
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(height: 20.0),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
