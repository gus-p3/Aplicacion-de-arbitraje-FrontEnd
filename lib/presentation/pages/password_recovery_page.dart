import 'package:flutter/material.dart';
import '../../data/services/api_service_recovery_pass.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/custom_snackbar.dart';
import 'recovery_sent_page.dart';
import '../../core/utils/validators.dart';
import '../../core/themes/app_themes.dart';
import '../../core/utils/environment.dart';

class PasswordRecoveryPage extends StatefulWidget {
  const PasswordRecoveryPage({Key? key}) : super(key: key);

  @override
  State<PasswordRecoveryPage> createState() => _PasswordRecoveryPageState();
}

class _PasswordRecoveryPageState extends State<PasswordRecoveryPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitRecoveryRequest() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiService().requestPasswordRecovery(
        _emailController.text.trim(),
      );

      if (response['success'] == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RecoverySentPage(email: _emailController.text.trim()),
          ),
        );
      } else {
        CustomSnackbar.showError(context, response['message'] ?? 'Error desconocido');
      }
    } catch (e) {
      CustomSnackbar.showError(context, 'Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Environment.appName),
        backgroundColor: Environment.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: AppThemes.defaultPadding,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Text(
                'Recuperar Contraseña',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Ingresa tu correo electrónico y te enviaremos un enlace para recuperar tu contraseña',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 40),
              CustomTextField(
                label: 'Correo Electrónico',
                hintText: 'ejemplo@correo.com',
                controller: _emailController,
                validator: Validators.validateEmail,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 40),
              PrimaryButton(
                text: 'Enviar Enlace de Recuperación',
                onPressed: _submitRecoveryRequest,
                isLoading: _isLoading,
                isEnabled: true,
              ),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.maybePop(context);
                  },
                  child: Text(
                    'Volver al Inicio de Sesión',
                    style: TextStyle(
                      color: Environment.accentColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}