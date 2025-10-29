import 'package:flutter/material.dart';
import '../widgets/primary_button.dart';
import '../../core/themes/app_themes.dart';
import '../../core/utils/environment.dart';

class RecoverySentPage extends StatelessWidget {
  final String email;

  const RecoverySentPage({Key? key, required this.email}) : super(key: key);

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
              Icons.mark_email_read_outlined,
              size: 80,
              color: Environment.secondaryColor,
            ),
            const SizedBox(height: 32),
            Text(
              'Correo Enviado',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Si el correo existe en nuestro sistema, recibirás un enlace de recuperación en:',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Environment.accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppThemes.defaultBorderRadius),
                border: Border.all(
                  color: Environment.accentColor.withOpacity(0.3),
                ),
              ),
              child: Text(
                email,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Environment.accentColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Revisa tu bandeja de entrada y sigue las instrucciones para restablecer tu contraseña.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Si no encuentras el correo, revisa tu carpeta de spam.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
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