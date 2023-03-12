import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:guatini/models/author_model.dart';
import 'package:guatini/models/conservationstatus_model.dart';
import 'package:guatini/models/license_model.dart';
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

    return GestureDetector(
      onTap: instances == null
          ? () {}
          : () {
              if (instances!.length == 1) {
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
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(15.0),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 25.0,
                                  vertical: 5.0,
                                ),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AdaptiveTheme.of(context).mode.isDark
                                      ? const Color.fromARGB(255, 50, 50, 50)
                                      : const Color.fromARGB(
                                          255, 220, 220, 220),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                alignment: Alignment.center,
                                child: Text(i.toString()),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                );
              }
            },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 7.0,
        ),
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
    );
  }
}

class ConservationStateCard extends StatelessWidget {
  final ConservationStatusModel? status;

  const ConservationStateCard({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 7.0,
      ),
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(AppLocalizations.of(context).conservationStatus),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _getConservationIcon(status!.status),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(_getConservationText(context, status!.status)),
          ),
        ],
      ),
    );
  }

  String _getConservationText(BuildContext context, int? index) {
    String conservation = '';
    switch (index) {
      case 1:
        conservation = AppLocalizations.of(context).extinct;
        break;
      case 2:
        conservation = AppLocalizations.of(context).extinctInTheWild;
        break;
      case 3:
        conservation = AppLocalizations.of(context).criticalEndangered;
        break;
      case 4:
        conservation = AppLocalizations.of(context).endangered;
        break;
      case 5:
        conservation = AppLocalizations.of(context).vulnerable;
        break;
      case 6:
        conservation = AppLocalizations.of(context).nearThreataned;
        break;
      case 7:
        conservation = AppLocalizations.of(context).leastConcern;
        break;
      case 8:
        conservation = AppLocalizations.of(context).deficientData;
        break;
      case 9:
        conservation = AppLocalizations.of(context).notEvaluated;
        break;
      default:
        conservation = AppLocalizations.of(context).errorObtainingInfo;
        break;
    }
    return conservation;
  }

  List<Widget> _getConservationIcon(int? index) {
    List<Widget> list = <Widget>[];
    if (index! >= 1 && index <= 7) {
      bool ex = false;
      bool ew = false;
      bool ce = false;
      bool ed = false;
      bool vu = false;
      bool nt = false;
      bool lc = false;
      switch (index) {
        case 1:
          ex = true;
          break;
        case 2:
          ew = true;
          break;
        case 3:
          ce = true;
          break;
        case 4:
          ed = true;
          break;
        case 5:
          vu = true;
          break;
        case 6:
          nt = true;
          break;
        case 7:
          lc = true;
          break;
      }
      list.add(_extinct(ex));
      list.add(_extinctInTheWild(ew));
      list.add(_criticalEndangered(ce));
      list.add(_endangered(ed));
      list.add(_vulnerable(vu));
      list.add(_nearThreataned(nt));
      list.add(_leastConcern(lc));
    } else if (index == 8 || index == 9) {
      bool dd = false;
      bool ne = false;
      switch (index) {
        case 8:
          dd = true;
          break;
        case 9:
          ne = true;
          break;
      }
      list.add(_deficientData(dd));
      list.add(_notEvaluated(ne));
    }
    return list;
  }

  Widget _extinct(bool active) {
    return Container(
      height: 35.0,
      width: 35.0,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: active
            ? const Color.fromARGB(255, 0, 0, 0)
            : const Color.fromARGB(255, 240, 240, 240),
        borderRadius: BorderRadius.circular(100.0),
        border: Border.all(
          color: active
              ? const Color.fromARGB(0, 0, 0, 0)
              : const Color.fromARGB(255, 0, 0, 0),
        ),
      ),
      child: Text(
        'EX',
        style: TextStyle(
          color: active
              ? const Color.fromARGB(255, 207, 52, 52)
              : const Color.fromARGB(255, 0, 0, 0),
        ),
      ),
    );
  }

  Widget _extinctInTheWild(bool active) {
    return Container(
      height: 35.0,
      width: 35.0,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: active
            ? const Color.fromARGB(255, 0, 0, 0)
            : const Color.fromARGB(255, 240, 240, 240),
        borderRadius: BorderRadius.circular(100.0),
        border: Border.all(
          color: active
              ? const Color.fromARGB(0, 0, 0, 0)
              : const Color.fromARGB(255, 0, 0, 0),
        ),
      ),
      child: Text(
        'EW',
        style: TextStyle(
          color: active
              ? const Color.fromARGB(255, 255, 255, 255)
              : const Color.fromARGB(255, 0, 0, 0),
        ),
      ),
    );
  }

  Widget _criticalEndangered(bool active) {
    return Container(
      height: 35.0,
      width: 35.0,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: active
            ? const Color.fromARGB(255, 204, 51, 51)
            : const Color.fromARGB(255, 240, 240, 240),
        borderRadius: BorderRadius.circular(100.0),
        border: Border.all(
          color: active
              ? const Color.fromARGB(0, 0, 0, 0)
              : const Color.fromARGB(255, 0, 0, 0),
        ),
      ),
      child: Text(
        'CE',
        style: TextStyle(
          color: active
              ? const Color.fromARGB(255, 252, 193, 193)
              : const Color.fromARGB(255, 0, 0, 0),
        ),
      ),
    );
  }

  Widget _endangered(bool active) {
    return Container(
      height: 35.0,
      width: 35.0,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: active
            ? const Color.fromARGB(255, 204, 102, 51)
            : const Color.fromARGB(255, 240, 240, 240),
        borderRadius: BorderRadius.circular(100.0),
        border: Border.all(
          color: active
              ? const Color.fromARGB(0, 0, 0, 0)
              : const Color.fromARGB(255, 0, 0, 0),
        ),
      ),
      child: Text(
        'EN',
        style: TextStyle(
          color: active
              ? const Color.fromARGB(255, 247, 188, 137)
              : const Color.fromARGB(255, 0, 0, 0),
        ),
      ),
    );
  }

  Widget _vulnerable(bool active) {
    return Container(
      height: 35.0,
      width: 35.0,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: active
            ? const Color.fromARGB(255, 204, 159, 0)
            : const Color.fromARGB(255, 240, 240, 240),
        border: Border.all(
          color: active
              ? const Color.fromARGB(0, 0, 0, 0)
              : const Color.fromARGB(255, 0, 0, 0),
        ),
        borderRadius: BorderRadius.circular(100.0),
      ),
      child: Text(
        'VU',
        style: TextStyle(
          color: active
              ? const Color.fromARGB(255, 255, 255, 255)
              : const Color.fromARGB(255, 0, 0, 0),
        ),
      ),
    );
  }

  Widget _nearThreataned(bool active) {
    return Container(
      height: 35.0,
      width: 35.0,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: active
            ? const Color.fromARGB(255, 0, 102, 102)
            : const Color.fromARGB(255, 240, 240, 240),
        border: Border.all(
          color: active
              ? const Color.fromARGB(0, 0, 0, 0)
              : const Color.fromARGB(255, 0, 0, 0),
        ),
        borderRadius: BorderRadius.circular(100.0),
      ),
      child: Text(
        'NT',
        style: TextStyle(
          color: active
              ? const Color.fromARGB(255, 113, 177, 140)
              : const Color.fromARGB(255, 0, 0, 0),
        ),
      ),
    );
  }

  Widget _leastConcern(bool active) {
    return Container(
      height: 35.0,
      width: 35.0,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: active
            ? const Color.fromARGB(255, 0, 102, 102)
            : const Color.fromARGB(255, 240, 240, 240),
        borderRadius: BorderRadius.circular(100.0),
        border: Border.all(
          color: active
              ? const Color.fromARGB(0, 0, 0, 0)
              : const Color.fromARGB(255, 0, 0, 0),
        ),
      ),
      child: Text(
        'LC',
        style: TextStyle(
          color: active
              ? const Color.fromARGB(255, 255, 255, 255)
              : const Color.fromARGB(255, 0, 0, 0),
        ),
      ),
    );
  }

  Widget _deficientData(bool active) {
    return Expanded(
      child: Container(
        height: 35.0,
        width: 35.0,
        margin: const EdgeInsets.only(left: 15.0, right: 8.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active
              ? const Color.fromARGB(255, 55, 55, 135)
              : const Color.fromARGB(255, 240, 240, 240),
          borderRadius: BorderRadius.circular(100.0),
          border: Border.all(
            color: active
                ? const Color.fromARGB(0, 0, 0, 0)
                : const Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        child: Text(
          'DD',
          style: TextStyle(
            color: active
                ? const Color.fromARGB(255, 255, 255, 255)
                : const Color.fromARGB(255, 0, 0, 0),
          ),
        ),
      ),
    );
  }

  Widget _notEvaluated(bool active) {
    return Expanded(
      child: Container(
        height: 35.0,
        width: 35.0,
        margin: const EdgeInsets.only(left: 8.0, right: 15.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active
              ? const Color.fromARGB(255, 55, 55, 135)
              : const Color.fromARGB(255, 240, 240, 240),
          borderRadius: BorderRadius.circular(100.0),
          border: Border.all(
            color: active
                ? const Color.fromARGB(0, 0, 0, 0)
                : const Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        child: Text(
          'NE',
          style: TextStyle(
            color: active
                ? const Color.fromARGB(255, 255, 255, 255)
                : const Color.fromARGB(255, 0, 0, 0),
          ),
        ),
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
              SelectableMenuItem(type: SelectableMenuItemType.copy),
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
  final AuthorModel author;

  const AuthorCard(this.author, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const radius = 10.0;
    return GestureDetector(
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
                author.name ?? AppLocalizations.of(context).unknown,
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
  final LicenseModel license;

  const LicenseCard(this.license, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const radius = 10.0;
    return GestureDetector(
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
                license.name ?? AppLocalizations.of(context).unknown,
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
