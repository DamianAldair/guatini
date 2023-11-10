import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:guatini/models/specie_model.dart';
import 'package:guatini/providers/pdf_provider.dart';

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
