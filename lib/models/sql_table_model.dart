class SqlTableModel {
  final String name;
  final List<String> columns;

  SqlTableModel({
    required this.name,
    required this.columns,
  });

  factory SqlTableModel.fromMap(Map<String, dynamic> json) => SqlTableModel(
        name: json['name'] as String,
        columns: (json['columns'] as String).split('/'),
      );

  @override
  bool operator ==(Object other) {
    return name == (other as SqlTableModel).name &&
        columns.length == other.columns.length &&
        columns.every((element) => other.columns.contains(element));
  }

  @override
  int get hashCode => Object.hash(name, columns);
}
