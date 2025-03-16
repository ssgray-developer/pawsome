import 'dart:convert';
import 'package:flutter/services.dart';

class ReverseLookup {
  static final ReverseLookup _instance = ReverseLookup._internal();
  Map<String, String> _reverseMap = {};

  factory ReverseLookup() {
    return _instance;
  }

  ReverseLookup._internal();

  Future<void> loadTranslations(String languageCode) async {
    final translations = await _loadTranslationFile(languageCode);
    final reverseMap = <String, String>{};

    translations.forEach((key, value) {
      if (value != null && value is String) {
        reverseMap[value] = key;
      }
    });

    _reverseMap = reverseMap;
  }

  Map<String, String> get reverseMap => _reverseMap;

  // Function to load translation JSON
  Future<Map<String, dynamic>> _loadTranslationFile(String languageCode) async {
    final revisedLanguageCode = languageCode.replaceAll('_', '-');
    final jsonString = await rootBundle
        .loadString('assets/translations/$revisedLanguageCode.json');
    final Map<String, dynamic> translations = json.decode(jsonString);
    return translations;
  }

  // Simple reverse lookup for a given translated species name
  String getOriginalText(String translatedText) {
    return _reverseMap[translatedText] ?? 'unknown';
  }
}
