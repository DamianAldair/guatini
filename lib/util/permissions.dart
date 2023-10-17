import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';

export 'package:permission_handler/permission_handler.dart';

abstract class Permissions {
  static Future<bool> check({
    required BuildContext context,
    required Permission permission,
    void Function()? function,
  }) async {
    final status = await permission.request();
    if (status.isGranted) {
      function?.call();
      return true;
    } else {
      openAppSettings().then((opened) {
        if (!opened) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context).cannotOpenSettings)),
          );
        }
      });
      return false;
    }
  }
}
