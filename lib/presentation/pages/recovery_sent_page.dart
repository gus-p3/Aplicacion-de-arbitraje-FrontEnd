import 'package:flutter/material.dart';
import '../widgets/primary_button.dart';
import '../../core/themes/app_themes.dart';
import '../../core/utils/environment.dart';

class RecoverySentPage extends StatelessWidget {
  const RecoverySentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Environment.appName),
        backgroundColor: Environment.primaryColor,
      ),
      body: Padding(
        padding: AppThemes.defaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80),
            Icon(
              Icons.check_circle_outlined,
              size: 80,
              color: Environment.secondaryColor,
            ),
            const SizedBox(height: 32),
            Text(
              'Contraseña Modificada',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Tu contraseña ha sido restablecida exitosamente.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'Ahora puedes iniciar sesión con tu nueva contraseña.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Spacer(),
            PrimaryButton(
              text: 'Volver al Inicio de Sesión',
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
    );
  }
}