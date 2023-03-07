import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:guatini/models/specie_search_model.dart';
import 'package:guatini/providers/db_provider.dart';
import 'package:guatini/providers/search_provider.dart';
import 'package:guatini/providers/userpreferences_provider.dart';
import 'package:guatini/widgets/text_widget.dart';
import 'package:sqflite/sqflite.dart';

class SimpleSearch extends SearchDelegate {
  final BuildContext context;

  SimpleSearch(this.context);

  @override
  String get searchFieldLabel => AppLocalizations.of(context).searchSpecie;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear_rounded),
        tooltip: AppLocalizations.of(context).clear,
        onPressed: () => query = '',
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
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      final prefs = UserPreferences();
      final lastSearches = prefs.lastSearches.reversed.toList();
      if (lastSearches.isEmpty) {
        return Center(
          child: Text(AppLocalizations.of(context).noRecentSearches),
        );
      }
      return ListView.builder(
        itemCount: lastSearches.length,
        itemBuilder: (_, int i) => ListTile(
          leading: const Icon(Icons.access_time_rounded),
          title: Text(lastSearches[i]),
          onTap: () => query = lastSearches[i],
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
            final results = snapshot.data as List<SpecieModelFromSimpleSearch>;
            return ListView.builder(
              itemCount: results.length,
              itemBuilder: (_, int i) => ListTile(
                leading: SizedBox(
                  height: 60.0,
                  width: 60.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: results[i].image,
                  ),
                ),
                title: getSearchedText(results[i].name!, query),
                subtitle: getSearchedText(results[i].scientificName!, query),
              ),
            );
          },
        );
      },
    );
  }
}
