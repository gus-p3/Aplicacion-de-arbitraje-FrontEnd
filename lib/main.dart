import 'package:flutter/material.dart';
import 'core/themes/app_themes.dart';
import 'core/utils/environment.dart';
import 'presentation/pages/password_recovery_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Environment.load();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Environment.appName,
      theme: AppThemes.lightTheme,
      home: const PasswordRecoveryPage(),
      debugShowCheckedModeBanner: !Environment.isProduction,
    );
  }
}