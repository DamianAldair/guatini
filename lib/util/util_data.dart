import 'dart:math';

final List<String> protocols = [
  'http',
  'https',
  'ftp',
  'ftps',
];

List<int> get3RandomIndexes(int index, int listLength) {
  final random = Random();
  final indexes = <int>[];
  while (indexes.length < 3) {
    final randomIndex = random.nextInt(listLength);
    if (randomIndex != index && !indexes.contains(randomIndex)) {
      indexes.add(randomIndex);
    }
  }
  return indexes;
}
