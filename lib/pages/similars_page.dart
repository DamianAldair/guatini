import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:guatini/models/specie_model.dart';
import 'package:guatini/pages/species_details_page.dart';

class SimilarsPage extends StatelessWidget {
  final SpeciesModel species;
  final List<SpeciesModel> similars;

  const SimilarsPage(
    this.species, {
    super.key,
    required this.similars,
  });

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
      body: ListView.builder(
        itemCount: similars.length,
        itemBuilder: (_, int i) {
          final s = similars[i];
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
                s.searchName == null || s.searchName!.isEmpty ? s.scientificName ?? '' : s.searchName.toString(),
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
    );
  }
}
