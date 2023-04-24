import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guatini/models/wiki_models.dart';
import 'package:guatini/providers/wikipedia_provider.dart';

class WikiSearchPage extends StatelessWidget {
  final String? query;

  const WikiSearchPage(this.query, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${AppLocalizations.of(context).wikiSearch}: $query'),
      ),
      body: query == null
          ? Center(child: Text(AppLocalizations.of(context).errorObtainingInfo))
          : FutureBuilder(
              future: WikipediaProvider.search(context, query!),
              builder: (_, AsyncSnapshot<WikiResults> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child:
                        Text(AppLocalizations.of(context).errorObtainingInfo),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final wikires = snapshot.data!;
                if (wikires.results.isEmpty) {
                  return Center(
                      child: Text(AppLocalizations.of(context).noResults));
                }
                return ListView.builder(
                  itemCount: wikires.results.length,
                  itemBuilder: (_, int i) {
                    return ListTile(
                      leading: const Icon(FontAwesomeIcons.wikipediaW),
                      title: Text(wikires.results[i].name),
                      trailing: const Icon(Icons.open_in_new_rounded),
                      onTap: () => wikires.results[i].launchUrl(),
                    );
                  },
                );
              },
            ),
    );
  }
}
