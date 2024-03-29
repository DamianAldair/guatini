import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:guatini/models/license_model.dart';
import 'package:guatini/widgets/more_media_widget.dart';
import 'package:selectable/selectable.dart';

class LicenseDetailsPage extends StatelessWidget {
  final LicenseModel? license;

  const LicenseDetailsPage(this.license, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).license),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20.0),
            const Icon(
              Icons.text_snippet_rounded,
              size: 80.0,
            ),
            SizedBox(
              width: double.infinity,
              child: Text(
                license?.name ?? AppLocalizations.of(context).unknown,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            if (license?.description != null)
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
                    license!.description!,
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                '${AppLocalizations.of(context).moreWith} ${AppLocalizations.of(context).license}: ${license?.name ?? AppLocalizations.of(context).unknown}',
                textAlign: TextAlign.center,
              ),
            ),
            MoreMedia(
              licenseId: license!.id,
            )
          ],
        ),
      ),
    );
  }
}
