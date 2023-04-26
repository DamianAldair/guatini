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
    final desc = instance is DomainModel ||
            instance is KindomModel ||
            instance is PhylumModel ||
            instance is ClassModel ||
            instance is OrderModel ||
            instance is FamilyModel ||
            instance is GenusModel
        ? instance.description
        : null;
    final subtitle = instance is ConservationStatusModel
        ? instance.getConservationText(context)
        : instance.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
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
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 20,
              itemBuilder: (_, int i) {
                return ListTile(
                  title: Text('Tile $i'),
                  subtitle: Text('Sub $i'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
