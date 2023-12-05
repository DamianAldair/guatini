import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:guatini/models/specie_model.dart';
import 'package:guatini/pages/species_details_page.dart';
import 'package:guatini/providers/db_provider.dart';
import 'package:guatini/providers/search_provider.dart';
import 'package:guatini/util/parse.dart';
import 'package:sqflite/sqflite.dart';

class AllSpeciesPage extends StatelessWidget {
  const AllSpeciesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).allSpecies),
      ),
      body: !DbProvider.isOpen()
          ? Center(
              child: Text(AppLocalizations.of(context).noDatabases),
            )
          : FutureBuilder(
              future: DbProvider.database,
              builder: (_, AsyncSnapshot<Database?> snapshot) {
                final phError = Center(child: Text(AppLocalizations.of(context).errorAnalyzingDb));
                const phLoading = Center(child: CircularProgressIndicator());
                if (snapshot.hasError) return phError;
                if (!snapshot.hasData) return phLoading;
                final db = snapshot.data!;
                return FutureBuilder(
                  future: SearchProvider.searchAllSpecies(db),
                  builder: (_, AsyncSnapshot<List<SpeciesModel>> snapshot) {
                    if (snapshot.hasError) return phError;
                    if (!snapshot.hasData) return phLoading;
                    final list = joinEquals(snapshot.data!);
                    return CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          automaticallyImplyLeading: false,
                          centerTitle: true,
                          title: Text('${AppLocalizations.of(context).total}: ${list.length}'),
                          floating: true,
                        ),
                        SliverList.builder(
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
                                child: Text(
                                  s.searchName == null || s.searchName!.isEmpty
                                      ? s.scientificName ?? ''
                                      : s.searchName.toString(),
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: Text(
                                  s.searchName == null || s.searchName!.isEmpty ? '' : s.scientificName ?? '',
                                ),
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
                      ],
                    );
                  },
                );
              },
            ),
    );
  }
}
