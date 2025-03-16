import 'dart:convert';
import 'package:flutter/services.dart';

class ReverseLookupService {
  static final ReverseLookupService _instance =
      ReverseLookupService._internal();
  Map<String, String> _reverseMap = {};

  factory ReverseLookupService() {
    return _instance;
  }

  ReverseLookupService._internal();

  // Load the translations into reverse map (this is simplified)
  Future<void> loadTranslations(String languageCode) async {
    print('prepping data');
    final translations = await _loadTranslationFile(languageCode);
    final reverseMap = <String, String>{};

    translations.forEach((key, value) {
      print(key);
      if (value != null && value is String) {
        reverseMap[value] = key;
      }
    });

    _reverseMap = reverseMap;
  }

  Map<String, String> get reverseMap => _reverseMap;

  // Function to load translation JSON
  Future<Map<String, dynamic>> _loadTranslationFile(String languageCode) async {
    final jsonString =
        await rootBundle.loadString('assets/translations/$languageCode.json');
    final Map<String, dynamic> translations = json.decode(jsonString);
    return translations;
  }

  // Simple reverse lookup for a given translated species name
  String getOriginalText(String translatedText) {
    return _reverseMap[translatedText] ?? 'unknown';
  }
}
