import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:guatini/models/author_model.dart';
import 'package:selectable/selectable.dart';

class AuthorDetailsPage extends StatelessWidget {
  final AuthorModel? author;

  const AuthorDetailsPage(this.author, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).author),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.person_rounded,
              size: 80.0,
            ),
            SizedBox(
              width: double.infinity,
              child: Text(
                author?.name ?? AppLocalizations.of(context).unknown,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Selectable(
              popupMenuItems: [
                SelectableMenuItem(type: SelectableMenuItemType.copy),
              ],
              child: Container(
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
                  author?.description ?? AppLocalizations.of(context).unknown,
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              '${AppLocalizations.of(context).morePhotosOf} ${author?.name ?? AppLocalizations.of(context).unknown}',
              textAlign: TextAlign.center,
            ),
            //TODO: list of photos
          ],
        ),
      ),
    );
  }
}
