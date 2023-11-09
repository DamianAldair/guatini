import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guatini/models/wiki_models.dart';
import 'package:guatini/providers/userpreferences_provider.dart';
import 'package:guatini/providers/wikipedia_provider.dart';

class MediawikiSearchPage extends StatelessWidget {
  final MediawikiSearch source;
  final String? lang;
  final String? query;

  const MediawikiSearchPage({
    Key? key,
    required this.source,
    required this.query,
    this.lang,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchOn = switch (source) {
      MediawikiSearch.wikipedia => AppLocalizations.of(context).searchOnWikipedia,
      MediawikiSearch.ecured => AppLocalizations.of(context).searchOnEcured,
    };
    return Scaffold(
      appBar: AppBar(
        title: Text('$searchOn:'),
      ),
      body: query == null
          ? Center(child: Text(AppLocalizations.of(context).errorObtainingInfo))
          : FutureBuilder(
              future: WikipediaProvider.search(
                context: context,
                source: source,
                lang: lang,
                query: query!,
              ),
              builder: (_, AsyncSnapshot<WikiResults> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(AppLocalizations.of(context).errorObtainingInfo),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final wikires = snapshot.data!;
                if (wikires.results.isEmpty) {
                  return Center(
                    child: Text(AppLocalizations.of(context).noResults),
                  );
                }
                final useExternal = UserPreferences().externalBrowser;
                return ListView.builder(
                  itemCount: wikires.results.length,
                  itemBuilder: (_, int i) {
                    return ListTile(
                      leading: const Icon(FontAwesomeIcons.earthAmericas),
                      title: Text(wikires.results[i].name),
                      trailing: Icon(useExternal ? Icons.open_in_new_rounded : Icons.chevron_right_rounded),
                      onTap: () => wikires.results[i].launchUrl(!useExternal),
                    );
                  },
                );
              },
            ),
    );
  }
}
