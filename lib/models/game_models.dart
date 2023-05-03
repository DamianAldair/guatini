// class RecordModel {
//   final List<GameModel> games;

//   RecordModel(this.games);

//   factory RecordModel.fromList(List<Map<String, dynamic>> list) {
//     final games = <GameModel>[];
//     for (Map<String, dynamic> json in list) {
//       games.add(GameModel.fromJson(json));
//     }
//     return RecordModel(games);
//   }

//   List<Map<String, dynamic>> toList() {
//     final list = <Map<String, dynamic>>[];
//     for (GameModel g in games) {
//       list.add(g.toJson());
//     }
//     return list;
//   }
// }

class GameModel {
  final int id;
  final int record;

  GameModel({required this.id, required this.record});

  factory GameModel.fromJson(Map<String, dynamic> json) => GameModel(
        id: json["id"] ?? 0,
        record: json["record"] ?? 0,
      );

  Map<String, dynamic> toJson() {
    return {"id": id, "record": record};
  }
}

class Game1Option {
  final String imagePath;
  final String scientificName;
  final String commonName;

  Game1Option({
    required this.imagePath,
    required this.scientificName,
    required this.commonName,
  });

  factory Game1Option.fromJson(Map<String, dynamic> json) => Game1Option(
        scientificName: json["scientific_name"],
        commonName: json["name"],
        imagePath: json["path"],
      );
}

// class GameAttempt2 extends GameAttempt {
//   final String imagePath;
//   final String scientificName;
//   final String commonName;

//   GameAttempt2({
//     required super.name,
//     required this.imagePath,
//     required this.scientificName,
//     required this.commonName,
//   });
// }

// class GameAttempt3 extends GameAttempt {
//   final String soundPath;
//   final String commonName;

//   GameAttempt3({
//     required super.name,
//     required this.soundPath,
//     required this.commonName,
//   });
// }
