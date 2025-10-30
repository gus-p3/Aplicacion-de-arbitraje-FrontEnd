import 'package:flutter/material.dart';
import 'core/themes/app_themes.dart';
import 'core/utils/environment.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'presentation/pages/password_recovery_page.dart';
import 'presentation/pages/login_organizator_page.dart';
import 'presentation/pages/perfil_organizator_screen.dart';
import 'presentation/pages/register_organizator_page.dart';
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
      home:const LoginScreen(),
      debugShowCheckedModeBanner: !Environment.isProduction,

      initialRoute: '/login',
 localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'MX'), // Español México
        Locale('es', ''),   // Español genérico
      ],
      locale: const Locale('es', 'MX'),
      routes: {
        '/login':(context) => const LoginScreen(),
        '/recuperar-password':(context) => const PasswordRecoveryPage(),
        '/perfil-organizador':(context) => const PerfilScreen(),
        '/registrar':(context) => const RegistroOrganizadorScreen(), //Botón temporal.


      },
    );
  }
}