import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        onPressed: () => exit(0),
      ),
    ],
  );
}
