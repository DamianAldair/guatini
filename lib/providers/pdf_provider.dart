// ignore_for_file: use_build_context_synchronously
import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:guatini/models/specie_model.dart';
import 'package:guatini/providers/appinfo_provider.dart';
import 'package:guatini/widgets/pdf_widgets.dart';
import 'package:path/path.dart' as p;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

abstract class PdfProvider {
  static Future<File> exportSpecies(BuildContext context, SpeciesModel species) async {
    final bytesData = await rootBundle.load('assets/icons/android_icon.png');
    final pdf = pw.Document(
      title: species.scientificName,
      author: AppInfo().appName,
    );
    pdf.addPage(
      pw.Page(
        build: (pw.Context pwContext) {
          return pdfContent(
            context,
            pwContext,
            bytesData.buffer.asUint8List(),
            species,
          );
        },
      ),
    );
    final bytes = await pdf.save();
    final dir = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
    final fileName = '${species.scientificName ?? 'pdf'}.pdf';
    final file = File(p.join(dir, fileName));
    return await file.writeAsBytes(bytes);
  }

  static pw.Widget pdfContent(
    BuildContext context,
    pw.Context pwContext,
    Uint8List image,
    SpeciesModel species,
  ) {
    final theme = pw.Theme.of(pwContext);
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.SizedBox(height: 30.0),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 200),
          child: pw.Image(pw.MemoryImage(image)),
        ),
        pw.SizedBox(height: 30.0),
        pw.Text(
          AppLocalizations.of(context).scientificName,
          textAlign: pw.TextAlign.center,
        ),
        pw.Text(
          species.scientificName ?? '',
          textAlign: pw.TextAlign.center,
          style: theme.header0,
        ),
        pw.SizedBox(height: 20.0),
        pw.Text(
          AppLocalizations.of(context).speciesDetails,
          style: theme.header1.copyWith(fontSize: 20.0),
        ),
        pw.SizedBox(height: 10.0),
        BulletText.list(
          property: AppLocalizations.of(context).commonName,
          instances: species.commonNames!.map((n) => n.name ?? '').toList(),
        ),
        BulletText.bullets(
          property: AppLocalizations.of(context).commonName,
          bullets: [
            BulletText.simple(
              property: AppLocalizations.of(context).taxDomain,
              instance: species.taxdomain?.name ?? '',
            ),
            BulletText.simple(
              property: AppLocalizations.of(context).taxKingdom,
              instance: species.taxkindom?.name ?? '',
            ),
            BulletText.simple(
              property: AppLocalizations.of(context).taxPhylum,
              instance: species.taxphylum?.name ?? '',
            ),
            BulletText.simple(
              property: AppLocalizations.of(context).taxClass,
              instance: species.taxclass?.name ?? '',
            ),
            BulletText.simple(
              property: AppLocalizations.of(context).taxOrder,
              instance: species.taxorder?.name ?? '',
            ),
            BulletText.simple(
              property: AppLocalizations.of(context).taxFamily,
              instance: species.taxfamily?.name ?? '',
            ),
            BulletText.simple(
              property: AppLocalizations.of(context).taxGenus,
              instance: species.taxdomain?.name ?? '',
            ),
          ],
        ),
        BulletText.simple(
          property: AppLocalizations.of(context).conservationStatus,
          instance: species.conservationStatus?.status ?? '',
        ),
        BulletText.simple(
          property: AppLocalizations.of(context).endemism,
          instance: species.endemism?.zone ?? '',
        ),
        BulletText.simple(
          property: AppLocalizations.of(context).abundance,
          instance: species.abundance?.abundance ?? '',
        ),
        BulletText.list(
          property: AppLocalizations.of(context).activity,
          instances: species.activities?.map((a) => a.activity ?? '').toList(),
        ),
        BulletText.list(
          property: AppLocalizations.of(context).habitat,
          instances: species.habitats?.map((h) => h.habitat ?? '').toList(),
        ),
        BulletText.list(
          property: AppLocalizations.of(context).diet,
          instances: species.diets?.map((d) => d.diet ?? '').toList(),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 10.0),
          child: pw.Text(species.dimorphism == null || !species.dimorphism!
              ? AppLocalizations.of(context).withoutDimorphism
              : AppLocalizations.of(context).withDimorphism),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.only(
            top: 10.0,
            bottom: 5.0,
          ),
          child: pw.Text(
            AppLocalizations.of(context).description,
            style: pw.TextStyle(
              fontSize: 20.0,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        pw.Text(
          species.description ?? '',
          textAlign: pw.TextAlign.justify,
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.only(
            top: 10.0,
            bottom: 5.0,
          ),
          child: pw.Text(
            AppLocalizations.of(context).gallery,
            style: pw.TextStyle(
              fontSize: 20.0,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        //IMAGES
        pw.SizedBox(height: 50.0),
        pw.Text(
          '${AppLocalizations.of(context).docGeneratedBy} ${AppInfo().appName}',
          textAlign: pw.TextAlign.center,
          style: const pw.TextStyle(color: PdfColors.grey),
        ),
        pw.SizedBox(height: 30.0),
      ],
    );
  }
}
