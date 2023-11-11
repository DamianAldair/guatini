import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:guatini/models/ad_model.dart';
import 'package:guatini/models/specie_model.dart';
import 'package:guatini/providers/ads_provider.dart';
import 'package:guatini/providers/pdf_provider.dart';
import 'package:guatini/providers/userpreferences_provider.dart';
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';

AlertDialog infoDialog(BuildContext context, Widget content) {
  return AlertDialog(
    title: Text(AppLocalizations.of(context).info),
    content: content,
    actions: [
      TextButton(
        child: Text(AppLocalizations.of(context).ok),
        onPressed: () => Navigator.pop(context),
      ),
    ],
  );
}

AlertDialog exitDialog(BuildContext context) {
  return AlertDialog(
    title: Text(AppLocalizations.of(context).exit),
    content: Text(AppLocalizations.of(context).exitText),
    actions: [
      TextButton(
        child: Text(AppLocalizations.of(context).no),
        onPressed: () => Navigator.pop(context),
      ),
      TextButton(
        child: Text(AppLocalizations.of(context).yes),
        onPressed: () => SystemNavigator.pop(),
      ),
    ],
  );
}

AlertDialog deleteDatabaseDialog({
  required BuildContext context,
  required bool permanently,
  required void Function() function,
}) {
  return AlertDialog(
    title: Text(permanently
        ? AppLocalizations.of(context).deletePermanentlyText
        : AppLocalizations.of(context).deleteFromListText),
    content: !permanently ? null : Text(AppLocalizations.of(context).deletePermanentlyTWarning),
    actions: [
      TextButton(
        child: Text(AppLocalizations.of(context).no),
        onPressed: () => Navigator.pop(context),
      ),
      TextButton(
        child: Text(AppLocalizations.of(context).yes),
        onPressed: () {
          Navigator.pop(context);
          function.call();
        },
      ),
    ],
  );
}

AlertDialog inputDialog({
  required BuildContext context,
  required String title,
  required dynamic value,
  required void Function() onOk,
}) {
  assert(int.tryParse(value.toString()) is int);
  final controller = TextEditingController(text: value.toString());
  return AlertDialog(
    title: Text(title),
    content: TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(border: OutlineInputBorder()),
    ),
    actions: [
      TextButton(
        onPressed: () {
          onOk.call();
          Navigator.pop(context);
        },
        child: Text(AppLocalizations.of(context).ok),
      )
    ],
  );
}

AlertDialog savePdfDialog(BuildContext context, SpeciesModel species) {
  return AlertDialog(
    title: Text(AppLocalizations.of(context).exportPdf),
    content: Text(AppLocalizations.of(context).exportPdfText),
    actions: [
      TextButton(
        child: Text(AppLocalizations.of(context).no),
        onPressed: () => Navigator.pop(context),
      ),
      TextButton(
        child: Text(AppLocalizations.of(context).yes),
        onPressed: () {
          Navigator.pop(context);
          PdfProvider.exportSpecies(context, species).then((value) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context).exportPdfDone),
              ),
            );
          });
        },
      ),
    ],
  );
}

Widget adDialog(BuildContext context, AdModel ad) {
  final adType = AdModelType.fromText(ad.type);

  final content = Padding(
    padding: adType == AdModelType.text ? EdgeInsets.zero : const EdgeInsets.only(bottom: 20.0),
    child: switch (adType) {
      AdModelType.text => const SizedBox.shrink(),
      AdModelType.link => TextButton(
          onPressed: ad.path == null ? null : () => launchUrl(Uri.parse(ad.path!)),
          child: Text(ad.path ?? AppLocalizations.of(AdsProvider.context!).link),
        ),
      AdModelType.image => Image.file(
          File(p.join(UserPreferences().dbPathNotifier.value!, ad.path).replaceAll('\\', '/')),
        ),
    },
  );

  return Material(
    color: Colors.transparent,
    child: Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(AdsProvider.context!).ad,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                  ),
                  const Spacer(),
                  IconButton.filledTonal(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(AdsProvider.context!),
                  ),
                ],
              ),
            ),
            AlertDialog(
              scrollable: true,
              title: Text(ad.name),
              content: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                ),
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * 0.3,
                          ),
                          child: content,
                        ),
                        Text(
                          ad.description,
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
