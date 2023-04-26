import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:guatini/models/author_model.dart';
import 'package:guatini/models/media_model.dart';
import 'package:guatini/models/mediatype_model.dart';
import 'package:guatini/providers/db_provider.dart';
import 'package:guatini/providers/search_provider.dart';
import 'package:guatini/providers/userpreferences_provider.dart';
import 'package:guatini/widgets/media_widgets.dart';
import 'package:guatini/widgets/more_media_widget.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
import 'package:selectable/selectable.dart';
import 'package:sqflite/sqflite.dart';

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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                '${AppLocalizations.of(context).moreOf} ${author?.name ?? AppLocalizations.of(context).unknown}',
                textAlign: TextAlign.center,
              ),
            ),
            MoreMedia(authorId: author!.id),
          ],
        ),
      ),
    );
  }
}
