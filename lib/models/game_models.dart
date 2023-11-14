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
