import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:guatini/models/author_model.dart';
import 'package:guatini/models/conservationstatus_model.dart';
import 'package:guatini/models/license_model.dart';
import 'package:guatini/models/mediatype_model.dart';
import 'package:guatini/pages/author_details_page.dart';
import 'package:guatini/pages/characteristic_page.dart';
import 'package:guatini/pages/license_details_page.dart';
import 'package:selectable/selectable.dart';

class InfoCard<T> extends StatelessWidget {
  final String title;
  final T? instance;
  final List<T>? instances;
  final void Function()? onTap;

  const InfoCard({
    Key? key,
    required this.title,
    this.instance,
    this.instances,
    this.onTap,
  })  : assert(instance is! List),
        assert(
          instance == null || instances == null,
          'Cannot provide both a instance and a list of instances.',
        ),
        assert(instances == null || onTap == null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    String text = '';
    if (instance == null && instances == null) {
      text = AppLocalizations.of(context).unavailable;
    } else if (instances != null) {
      for (T i in instances!) {
        text += '${i.toString()}\n';
      }
      if (instances!.isNotEmpty) {
        text = text.substring(0, text.length - 1);
      } else {
        text = AppLocalizations.of(context).unknown;
      }
    } else {
      text = instance.toString();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 7.0,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0),
        onTap: instances == null
            ? () => viewDescription(context, title, instance)
            : () {
                if (instances!.length == 1) {
                  viewDescription(context, title, instances!.first);
                } else {
                  showDialog(
                    context: context,
                    barrierColor: Colors.black.withOpacity(0.7),
                    builder: (_) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                '${AppLocalizations.of(context).chooseOne}:',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            for (T i in instances!)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 25.0,
                                  vertical: 5.0,
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(15.0),
                                    onTap: () {
                                      Navigator.pop(context);
                                      viewDescription(context, title, i);
                                    },
                                    child: Ink(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: AdaptiveTheme.of(context).mode.isDark
                                            ? const Color.fromARGB(255, 50, 50, 50)
                                            : const Color.fromARGB(255, 220, 220, 220),
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            i.toString(),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(10.0),
          ),
          width: double.infinity,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    alignment: Alignment.center,
                    child: Text(title),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    alignment: Alignment.center,
                    child: Text(text, textAlign: TextAlign.center),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future viewDescription(
    BuildContext context,
    String title,
    dynamic instance,
  ) =>
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CharacteristicPage(
            title: title,
            instance: instance,
          ),
        ),
      );
}

class ConservationStateCard extends StatelessWidget {
  final ConservationStatusModel? status;

  const ConservationStateCard({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = AppLocalizations.of(context).conservationStatus;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 7.0,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CharacteristicPage(
                title: title,
                instance: status,
              ),
            ),
          );
        },
        child: Ink(
          width: double.infinity,
          // alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(title),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: status!.getConservationIcon(context),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(status!.status!),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Dimorphism extends StatelessWidget {
  final bool? present;

  const Dimorphism(this.present, {super.key});

  @override
  Widget build(BuildContext context) {
    if (present == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(
        present! ? AppLocalizations.of(context).withDimorphism : AppLocalizations.of(context).withoutDimorphism,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}

class Description extends StatelessWidget {
  final String description;

  const Description(this.description, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              AppLocalizations.of(context).description,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Selectable(
            popupMenuItems: [
              SelectableMenuItem(
                icon: Icons.copy_rounded,
                title: AppLocalizations.of(context).copy,
                type: SelectableMenuItemType.copy,
              ),
            ],
            child: Text(
              description,
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}

class AuthorCard extends StatelessWidget {
  final AuthorModel? author;
  final MediaType type;

  const AuthorCard(this.author, this.type, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const radius = 10.0;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => AuthorDetailsPage(author)),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 7.0,
        ),
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(radius),
        ),
        width: double.infinity,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(10.0),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.person_rounded),
                  const SizedBox(width: 5.0),
                  Text(AppLocalizations.of(context).author),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                author?.name ?? AppLocalizations.of(context).unknown,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LicenseCard extends StatelessWidget {
  final LicenseModel? license;

  const LicenseCard(this.license, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const radius = 10.0;
    return GestureDetector(
      onTap: license == null
          ? () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(context).unknownInfo,
                  ),
                ),
              );
            }
          : () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => LicenseDetailsPage(license)),
              );
            },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 7.0,
        ),
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(radius),
        ),
        width: double.infinity,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(10.0),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.text_snippet_rounded),
                  const SizedBox(width: 5.0),
                  Text(AppLocalizations.of(context).license),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                license?.name ?? AppLocalizations.of(context).unknown,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
