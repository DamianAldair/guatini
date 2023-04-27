import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:guatini/models/qr_models.dart';
import 'package:guatini/widgets/dialogs.dart';
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
      body: Stack(
        children: [
          _qrView,
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _interface,
          ),
        ],
      ),
    );
  }

  Widget get _qrView {
    final color = Theme.of(context).primaryColor;
    final scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context).noCameraPermission),
            ),
          );
        }
      },
      onQRViewCreated: (controller) {
        setState(() {
          this.controller = controller;
          controller.resumeCamera();
        });
        controller.scannedDataStream.listen((scanData) {
          if (scanData.format == BarcodeFormat.qrcode &&
              scanData.code != null) {
            controller.pauseCamera();
            _open(scanData.code!);
          }
        });
      },
    );
  }

  List<Widget> get _interface {
    return [
      AppBar(
        title: Text(AppLocalizations.of(context).qrReader),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      FutureBuilder<bool?>(
        future: controller?.getFlashStatus(),
        builder: (_, AsyncSnapshot<bool?> snapshot) {
          if (snapshot.hasError || !snapshot.hasData) {
            return const SizedBox.shrink();
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: FloatingActionButton(
              elevation: 0.0,
              child: Icon(snapshot.data!
                  ? Icons.flashlight_off_rounded
                  : Icons.flashlight_on_rounded),
              onPressed: () async {
                await controller?.toggleFlash();
                setState(() {});
              },
            ),
          );
        },
      ),
    ];
  }

  _open(String scanData) {
    const key = 'guatini_qr_data';
    void dialog() {
      showDialog(
        context: context,
        builder: (_) => infoDialog(
          context,
          Text(AppLocalizations.of(context).errorReadingQr),
        ),
      );
      controller?.resumeCamera();
    }

    void execute(QrResult? result) {
      if (result == null) {
        dialog.call();
      } else {
        Navigator.pop(context);
        switch (result.runtimeType) {
          case QrLink:
            (result as QrLink).launchUrl();
            break;
          case QrWikipedia:
            (result as QrWikipedia).executeSearch(context);
            break;
        }
      }
    }

    try {
      final decoded = json.decode(scanData) as Map<String, dynamic>;
      if (!decoded.containsKey(key)) {
        dialog.call();
      } else {
        final data = decoded[key] as Map<String, dynamic>;
        if (data.keys.isEmpty) {
          dialog.call();
        } else {
          QrResult? result;
          final mode = data.keys.first;
          switch (mode) {
            case 'link':
              result = QrLink(url: data[mode]);
              break;
            case 'wikipedia':
              try {
                result = QrWikipedia.fromJson(context, data[mode]);
              } catch (_) {
                dialog.call();
              }
              break;
            case 'offline':
              // TODO: QrOffline
              break;
          }
          execute(result);
        }
      }
    } catch (_) {
      dialog.call();
    }
  }
}
