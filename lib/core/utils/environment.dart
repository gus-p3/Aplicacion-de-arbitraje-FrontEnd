import 'dart:ui';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get appName => dotenv.get('APP_NAME', fallback: 'Sistema Liga');
  static String get apiBaseUrl =>
      dotenv.get('API_BASE_URL');
  static Color get primaryColor =>
      Color(int.parse(dotenv.get('PRIMARY_COLOR', fallback: '0xFFFF6B35')));
  static Color get secondaryColor =>
      Color(int.parse(dotenv.get('SECONDARY_COLOR', fallback: '0xFF4CAF50')));
  static Color get accentColor =>
      Color(int.parse(dotenv.get('ACCENT_COLOR', fallback: '0xFF2196F3')));
  static bool get isProduction =>
      dotenv.get('IS_PRODUCTION', fallback: 'false').toLowerCase() == 'true';

  static Future<void> load() async {
    await dotenv.load(fileName: '.env');
  }
}
