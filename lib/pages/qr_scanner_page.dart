import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:guatini/models/qr_models.dart';
import 'package:guatini/widgets/dialogs.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({Key? key}) : super(key: key);

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool pause = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(builder: (_, Orientation orientation) {
        final portrait = orientation == Orientation.portrait;
        return Stack(
          children: [
            getQrView(portrait),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: getInterface(portrait),
            ),
          ],
        );
      }),
    );
  }

  Widget getQrView(bool isPortrait) {
    final color = Theme.of(context).primaryColor;
    final size = MediaQuery.of(context).size;
    final scanArea = isPortrait ? size.width * 2 / 3 : size.height * 2 / 3;
    return QRView(
      key: qrKey,
      overlay: QrScannerOverlayShape(
        borderColor: color,
        borderRadius: 5,
        borderLength: 25,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (_, allowed) {
        if (!allowed) {
          openAppSettings().then((open) {
            if (!open) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context).noCameraPermission),
                ),
              );
            }
          });
        }
      },
      onQRViewCreated: (controller) {
        setState(() {
          this.controller = controller;
          controller.resumeCamera();
        });
        controller.scannedDataStream.listen((scanData) {
          if (scanData.format == BarcodeFormat.qrcode && scanData.code != null) {
            controller.pauseCamera();
            _open(scanData.code!);
          }
        });
      },
    );
  }

  List<Widget> getInterface(bool isPortrait) {
    return [
      AppBar(
        title: isPortrait ? Text(AppLocalizations.of(context).qrReader) : null,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      FutureBuilder<bool?>(
        future: controller?.getFlashStatus(),
        builder: (_, AsyncSnapshot<bool?> snapshot) {
          if (snapshot.hasError || !snapshot.hasData) {
            return const SizedBox.shrink();
          }
          return Row(
            mainAxisAlignment: isPortrait ? MainAxisAlignment.center : MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: FloatingActionButton(
                  elevation: 0.0,
                  child: Icon(snapshot.data! ? Icons.flashlight_off_rounded : Icons.flashlight_on_rounded),
                  onPressed: () async {
                    await controller?.toggleFlash();
                    setState(() {});
                  },
                ),
              ),
            ],
          );
        },
      ),
    ];
  }

  _open(String scanData) {
    const key = 'guatini_qr_data';
    void dialog([String? text]) {
      showDialog(
        context: context,
        builder: (_) => infoDialog(
          context,
          Text(text ?? AppLocalizations.of(context).errorReadingQr),
        ),
      );
      controller?.resumeCamera();
    }

    try {
      final decoded = json.decode(scanData) as Map<String, dynamic>;
      final data = decoded[key] as Map<String, dynamic>;
      final mode = data.keys.first.toLowerCase();
      QrResult? qrResult;
      if (mode == 'link') {
        qrResult = QrLink(url: data[mode]);
      } else if (mode == 'wikipedia') {
        qrResult = QrWikipedia.fromJson(context, data[mode]);
      } else if (mode == 'ecured') {
        qrResult = QrEcured.fromJson(data[mode]);
      } else if (mode == 'offline') {
        qrResult = QrOffline.fromJson(data[mode]);
      }
      if (qrResult == null) {
        dialog.call();
        return;
      }
      if (qrResult is! QrOffline) Navigator.pop(context);
      qrResult.launch(context).onError((_, __) => dialog.call(AppLocalizations.of(context).noResultsFromQr));
    } catch (_) {
      dialog.call();
    }
  }
}
