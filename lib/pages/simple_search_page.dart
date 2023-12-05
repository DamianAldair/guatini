import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:guatini/models/specie_model.dart';
import 'package:guatini/pages/all_species_page.dart';
import 'package:guatini/pages/species_details_page.dart';
import 'package:guatini/providers/db_provider.dart';
import 'package:guatini/providers/search_provider.dart';
import 'package:guatini/providers/userpreferences_provider.dart';
import 'package:guatini/util/parse.dart';
import 'package:guatini/widgets/text_widget.dart';
import 'package:sqflite/sqflite.dart';

class SimpleSearch extends SearchDelegate {
  final BuildContext context;

  SimpleSearch(this.context);

  @override
  String get searchFieldLabel => AppLocalizations.of(context).searchSpecies;

  @override
  void close(BuildContext context, dynamic result) {
    FocusManager.instance.primaryFocus?.unfocus();
    super.close(context, result);
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear_rounded),
          tooltip: AppLocalizations.of(context).clear,
          onPressed: () => query = '',
        )
      else if (DbProvider.isOpen())
        IconButton(
          icon: const Icon(Icons.view_list_rounded),
          tooltip: AppLocalizations.of(context).listAllSpecies,
          onPressed: () {
            close(context, null);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AllSpeciesPage()),
            );
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_rounded),
      tooltip: AppLocalizations.of(context).back,
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) => _searched();

  @override
  Widget buildSuggestions(BuildContext context) => _searched();

  Widget _searched() {
    if (query.isEmpty) {
      final prefs = UserPreferences();
      final lastSearches = prefs.lastSearches.reversed.toList();
      if (lastSearches.isEmpty) {
        return Center(
          child: Text(AppLocalizations.of(context).noRecentSearches),
        );
      }
      return SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: lastSearches.length,
              itemBuilder: (_, int i) => ListTile(
                leading: const Icon(Icons.access_time_rounded),
                title: Text(lastSearches[i]),
                onTap: () => query = lastSearches[i],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextButton(
                child: Text(AppLocalizations.of(context).deleteList),
                onPressed: () {
                  final prefs = UserPreferences();
                  prefs.cleanLastSearches();
                  query = '';
                },
              ),
            ),
          ],
        ),
      );
    }
    if (!DbProvider.isOpen()) {
      return Center(
        child: Text(AppLocalizations.of(context).noDatabases),
      );
    }
    return FutureBuilder(
      future: DbProvider.database,
      builder: (_, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final db = snapshot.data as Database;
        return FutureBuilder(
          future: SearchProvider.searchSpecie(db, query),
          builder: (_, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final results = joinEquals(snapshot.data as List<SpeciesModel>);
            return ListView.builder(
              itemCount: results.length,
              itemBuilder: (_, int i) {
                final searchName = results[i].searchName;
                final scientificName = results[i].scientificName;
                return ListTile(
                  leading: SizedBox(
                    height: 60.0,
                    width: 60.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: results[i].image,
                    ),
                  ),
                  title: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: getSearchedText(
                      searchName == null || searchName.isEmpty ? scientificName ?? '' : searchName,
                      query,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: getSearchedText(
                      searchName == null || searchName.isEmpty ? '' : scientificName ?? '',
                      query,
                    ),
                  ),
                  onTap: () {
                    UserPreferences().newSearch(query);
                    close(context, null);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SpeciesDetailsPage(results[i].id)),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
