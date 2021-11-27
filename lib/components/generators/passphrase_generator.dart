import 'dart:convert';
import 'dart:math';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class PassphraseGenerator {
  PassphraseGenerator(
    this.wordCount, {
    this.includeNumbers = false,
    this.shouldCapitalize = false,
    this.separator = "_",
    this.wordList = const [],
  });

  int cachedWords = 100;
  int wordCount;
  bool includeNumbers;
  bool shouldCapitalize;
  String separator;
  List<String> wordList;
  int _currentIndex = 0;

  Future<bool> fetchWordList() async {
    final response = await http.get(
        Uri.parse("https://quiterandomapi.p.rapidapi.com/api/randomWord"),
        headers: {
          "count": cachedWords.toString(),
          "x-rapidapi-key": dotenv.env["X-RAPIDAPI-KEY"]!,
          "x-rapidapi-host": "quiterandomapi.p.rapidapi.com",
        });

    wordList = [];
    for (String word in jsonDecode(response.body)) {
      if (word.length < 7) continue;
      word = word.replaceAll('-', '');
      word = word.replaceAll("'", "");
      wordList.add(word);
    }
    return true;
  }

  String generate() {
    final passphrase =
        includeNumbers ? _generateWithNumber() : _generateWithoutNumber();
    _currentIndex += wordCount;

    return passphrase;
  }

  String _generateWithoutNumber() {
    return wordList
        .sublist(_currentIndex, _currentIndex + wordCount)
        .map(shouldCapitalize
            ? (word) => word[0].toUpperCase() + word.substring(1)
            : (word) => word)
        .join(separator);
  }

  String _generateWithNumber() {
    final random = Random();
    final position = random.nextInt(wordCount);
    final randomNumber = random.nextInt(10);

    final words = wordList
        .sublist(_currentIndex, _currentIndex + wordCount)
        .map((word) =>
            shouldCapitalize ? word[0].toUpperCase() + word.substring(1) : word)
        .toList();

    words[position] += randomNumber.toString();

    return words.join(separator);
  }
}
