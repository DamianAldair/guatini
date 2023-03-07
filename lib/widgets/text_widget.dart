import 'package:flutter/material.dart';

Text getSearchedText(String fullText, String searchedText) {
  final full = fullText.toLowerCase();
  final searched = searchedText.toLowerCase();
  final splitted = full.split(searched);
  List<TextSpan> result = [];
  bool capitalize = false;
  for (String item in splitted) {
    if (!capitalize && item.isNotEmpty) {
      item = item[0].toUpperCase() + item.substring(1);
      capitalize = true;
    }
    result.add(TextSpan(text: item));
    String s = searched;
    if (!capitalize && item.isEmpty) {
      s = s[0].toUpperCase() + s.substring(1);
      capitalize = true;
    }
    result.add(
      TextSpan(
        text: s,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
  result.removeLast();
  final finalText = Text.rich(TextSpan(children: result));
  return finalText;
}
