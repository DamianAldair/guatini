enum AdModelType {
  text('text'),
  image('image'),
  link('link');

  final String type;
  const AdModelType(this.type);
  factory AdModelType.fromText(String text) {
    final map = {
      'image': AdModelType.image,
      'imagen': AdModelType.image,
      'link': AdModelType.link,
      'url': AdModelType.link,
    };
    return map[text.toLowerCase()] ?? AdModelType.text;
  }
}

class AdModel {
  final int id;
  final String name;
  final String type;
  final String description;
  final String? path;

  const AdModel({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    this.path,
  });

  factory AdModel.fromMap(Map<String, dynamic> json) => AdModel(
        id: json["id"],
        name: json['name'],
        type: json['type'],
        description: json['description'],
        path: json["path"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "type": type,
        "description": description,
        "path": path,
      };
}
