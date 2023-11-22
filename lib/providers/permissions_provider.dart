// ignore_for_file: use_build_context_synchronously

import 'package:device_info_plus/device_info_plus.dart';
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

  static Future<bool> _requestStoragePermissions() async {
    final storage = await Permission.storage.request();
    PermissionStatus? manageExternalStorage;
    final deviceInfo = await DeviceInfoPlugin().androidInfo;
    if (storage.isGranted && deviceInfo.version.sdkInt >= 30) {
      manageExternalStorage = await Permission.manageExternalStorage.request();
    }
    if (manageExternalStorage == null) return storage.isGranted;
    return storage.isGranted && manageExternalStorage.isGranted;
  }

  static void requestStoragePermission(
    BuildContext context,
    void Function()? function,
  ) async {
    _requestStoragePermissions().then((bool granted) {
      if (granted) {
        function?.call();
      } else {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).noStoragePermission),
          ),
        );
        Future.delayed(const Duration(seconds: 2)).then((_) {
          openAppSettings().then((bool opened) {
            if (!opened) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppLocalizations.of(context).cannotOpenSettings)),
              );
            }
          });
        });
      }
    });
  }
}
