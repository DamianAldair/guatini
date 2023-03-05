import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

AlertDialog deleteDatabaseDialog({
  required BuildContext context,
  required bool permanently,
  required void Function() function,
}) {
  return AlertDialog(
    title: Text(permanently
        ? AppLocalizations.of(context).deletePermanentlyText
        : AppLocalizations.of(context).deleteFromListText),
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
