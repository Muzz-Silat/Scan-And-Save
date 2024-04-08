// config.dart
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class AppConfig {
  static late final Map<String, dynamic> _config;

  static Future<void> loadConfig() async {
    final configString = await rootBundle.loadString('config.json');
    _config = json.decode(configString);
  }

  static String get apiBaseUrl => _config['apiBaseUrl'] as String;
}
