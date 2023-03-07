// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class PermissionsHandler {
  static Future<bool> status(Permission permission) async {
    switch (await permission.status) {
      case PermissionStatus.granted:
        return true;
      default:
        return false;
    }
  }

  static Future<bool> request(
    BuildContext context,
    Permission permission,
  ) async {
    final status = await permission.request();
    switch (status) {
      case PermissionStatus.permanentlyDenied:
        final open = await openAppSettings();
        if (!open) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context).grantPermissionManually,
              ),
            ),
          );
        }
        break;
      case PermissionStatus.granted:
        return true;
      default:
        return false;
    }
    return false;
  }

  static Future<bool> requestStoragePermission(
    BuildContext context,
    void Function() function,
  ) async {
    bool status = await PermissionsHandler.status(Permission.storage);
    if (!status) {
      status = await PermissionsHandler.request(
        context,
        Permission.storage,
      );
    }
    if (!status) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).noStoragePermission),
        ),
      );
      return false;
    } else {
      function.call();
      return true;
    }
  }
}
