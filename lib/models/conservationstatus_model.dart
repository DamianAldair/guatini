import 'package:flutter/material.dart';

class ConservationStatusModel {
  final int? id;
  final String? status;

  const ConservationStatusModel({
    required this.id,
    required this.status,
  });

  factory ConservationStatusModel.fromMap(Map<String, dynamic> json) => ConservationStatusModel(
        id: json["id"],
        status: json["status"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "status": status,
      };

  // String getConservationText(BuildContext context) {
  //   String conservation = '';
  //   switch (status) {
  //     case 1:
  //       conservation = AppLocalizations.of(context).extinct;
  //       break;
  //     case 2:
  //       conservation = AppLocalizations.of(context).extinctInTheWild;
  //       break;
  //     case 3:
  //       conservation = AppLocalizations.of(context).criticalEndangered;
  //       break;
  //     case 4:
  //       conservation = AppLocalizations.of(context).endangered;
  //       break;
  //     case 5:
  //       conservation = AppLocalizations.of(context).vulnerable;
  //       break;
  //     case 6:
  //       conservation = AppLocalizations.of(context).nearThreataned;
  //       break;
  //     case 7:
  //       conservation = AppLocalizations.of(context).leastConcern;
  //       break;
  //     case 8:
  //       conservation = AppLocalizations.of(context).deficientData;
  //       break;
  //     case 9:
  //       conservation = AppLocalizations.of(context).notEvaluated;
  //       break;
  //     default:
  //       conservation = AppLocalizations.of(context).errorObtainingInfo;
  //       break;
  //   }
  //   return conservation;
  // }

  List<Widget> getConservationIcon(BuildContext context) {
    List<Widget> list = <Widget>[];
    if (id! >= 1 && id! <= 7) {
      bool ex = false;
      bool ew = false;
      bool ce = false;
      bool ed = false;
      bool vu = false;
      bool nt = false;
      bool lc = false;
      switch (id) {
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
    } else if (id == 8 || id == 9) {
      bool dd = false;
      bool ne = false;
      switch (id) {
        case 8:
          dd = true;
          break;
        case 9:
        default:
          ne = true;
          break;
      }
      list.add(_deficientData(dd));
      list.add(_notEvaluated(ne));
    }
    return list;
  }

  Widget _extinct(bool active) {
    return Tooltip(
      message: status,
      child: Container(
        height: 35.0,
        width: 35.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? const Color.fromARGB(255, 0, 0, 0) : const Color.fromARGB(125, 240, 240, 240),
          borderRadius: BorderRadius.circular(100.0),
          border: Border.all(
            color: active ? const Color.fromARGB(0, 0, 0, 0) : const Color.fromARGB(125, 0, 0, 0),
          ),
        ),
        child: Text(
          'EX',
          style: TextStyle(
            color: active ? const Color.fromARGB(255, 207, 52, 52) : const Color.fromARGB(125, 0, 0, 0),
          ),
        ),
      ),
    );
  }

  Widget _extinctInTheWild(bool active) {
    return Tooltip(
      message: status,
      child: Container(
        height: 35.0,
        width: 35.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? const Color.fromARGB(255, 0, 0, 0) : const Color.fromARGB(125, 240, 240, 240),
          borderRadius: BorderRadius.circular(100.0),
          border: Border.all(
            color: active ? const Color.fromARGB(0, 0, 0, 0) : const Color.fromARGB(125, 0, 0, 0),
          ),
        ),
        child: Text(
          'EW',
          style: TextStyle(
            color: active ? const Color.fromARGB(255, 255, 255, 255) : const Color.fromARGB(125, 0, 0, 0),
          ),
        ),
      ),
    );
  }

  Widget _criticalEndangered(bool active) {
    return Tooltip(
      message: status,
      child: Container(
        height: 35.0,
        width: 35.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? const Color.fromARGB(255, 204, 51, 51) : const Color.fromARGB(125, 240, 240, 240),
          borderRadius: BorderRadius.circular(100.0),
          border: Border.all(
            color: active ? const Color.fromARGB(0, 0, 0, 0) : const Color.fromARGB(125, 0, 0, 0),
          ),
        ),
        child: Text(
          'CE',
          style: TextStyle(
            color: active ? const Color.fromARGB(255, 252, 193, 193) : const Color.fromARGB(125, 0, 0, 0),
          ),
        ),
      ),
    );
  }

  Widget _endangered(bool active) {
    return Tooltip(
      message: status,
      child: Container(
        height: 35.0,
        width: 35.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? const Color.fromARGB(255, 204, 102, 51) : const Color.fromARGB(125, 240, 240, 240),
          borderRadius: BorderRadius.circular(100.0),
          border: Border.all(
            color: active ? const Color.fromARGB(0, 0, 0, 0) : const Color.fromARGB(125, 0, 0, 0),
          ),
        ),
        child: Text(
          'EN',
          style: TextStyle(
            color: active ? const Color.fromARGB(255, 247, 188, 137) : const Color.fromARGB(125, 0, 0, 0),
          ),
        ),
      ),
    );
  }

  Widget _vulnerable(bool active) {
    return Tooltip(
      message: status,
      child: Container(
        height: 35.0,
        width: 35.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? const Color.fromARGB(255, 204, 159, 0) : const Color.fromARGB(125, 240, 240, 240),
          border: Border.all(
            color: active ? const Color.fromARGB(0, 0, 0, 0) : const Color.fromARGB(125, 0, 0, 0),
          ),
          borderRadius: BorderRadius.circular(100.0),
        ),
        child: Text(
          'VU',
          style: TextStyle(
            color: active ? const Color.fromARGB(255, 255, 255, 255) : const Color.fromARGB(125, 0, 0, 0),
          ),
        ),
      ),
    );
  }

  Widget _nearThreataned(bool active) {
    return Tooltip(
      message: status,
      child: Container(
        height: 35.0,
        width: 35.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? const Color.fromARGB(255, 0, 102, 102) : const Color.fromARGB(125, 240, 240, 240),
          border: Border.all(
            color: active ? const Color.fromARGB(0, 0, 0, 0) : const Color.fromARGB(125, 0, 0, 0),
          ),
          borderRadius: BorderRadius.circular(100.0),
        ),
        child: Text(
          'NT',
          style: TextStyle(
            color: active ? const Color.fromARGB(255, 113, 177, 140) : const Color.fromARGB(125, 0, 0, 0),
          ),
        ),
      ),
    );
  }

  Widget _leastConcern(bool active) {
    return Tooltip(
      message: status,
      child: Container(
        height: 35.0,
        width: 35.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? const Color.fromARGB(255, 0, 102, 102) : const Color.fromARGB(125, 240, 240, 240),
          borderRadius: BorderRadius.circular(100.0),
          border: Border.all(
            color: active ? const Color.fromARGB(0, 0, 0, 0) : const Color.fromARGB(125, 0, 0, 0),
          ),
        ),
        child: Text(
          'LC',
          style: TextStyle(
            color: active ? const Color.fromARGB(255, 255, 255, 255) : const Color.fromARGB(125, 0, 0, 0),
          ),
        ),
      ),
    );
  }

  Widget _deficientData(bool active) {
    return Expanded(
      child: Tooltip(
        message: status,
        child: Container(
          height: 35.0,
          width: 35.0,
          margin: const EdgeInsets.only(left: 15.0, right: 8.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? const Color.fromARGB(255, 55, 55, 135) : const Color.fromARGB(125, 240, 240, 240),
            borderRadius: BorderRadius.circular(100.0),
            border: Border.all(
              color: active ? const Color.fromARGB(0, 0, 0, 0) : const Color.fromARGB(125, 0, 0, 0),
            ),
          ),
          child: Text(
            'DD',
            style: TextStyle(
              color: active ? const Color.fromARGB(255, 255, 255, 255) : const Color.fromARGB(125, 0, 0, 0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _notEvaluated(bool active) {
    return Expanded(
      child: Tooltip(
        message: status,
        child: Container(
          height: 35.0,
          width: 35.0,
          margin: const EdgeInsets.only(left: 8.0, right: 15.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? const Color.fromARGB(255, 55, 55, 135) : const Color.fromARGB(125, 240, 240, 240),
            borderRadius: BorderRadius.circular(100.0),
            border: Border.all(
              color: active ? const Color.fromARGB(0, 0, 0, 0) : const Color.fromARGB(125, 0, 0, 0),
            ),
          ),
          child: Text(
            'NE',
            style: TextStyle(
              color: active ? const Color.fromARGB(255, 255, 255, 255) : const Color.fromARGB(125, 0, 0, 0),
            ),
          ),
        ),
      ),
    );
  }
}
