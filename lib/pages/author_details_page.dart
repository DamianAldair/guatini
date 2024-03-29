import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:guatini/models/author_model.dart';
import 'package:guatini/widgets/more_media_widget.dart';
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
            if (author?.description != null)
              Selectable(
                popupMenuItems: [
                  SelectableMenuItem(
                    type: SelectableMenuItemType.copy,
                    icon: Icons.copy_rounded,
                    title: AppLocalizations.of(context).copy,
                  ),
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
                    author!.description!,
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
