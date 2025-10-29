import 'package:flutter/material.dart';
import '../../data/services/api_service_recovery_pass.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/custom_snackbar.dart';
import 'recovery_sent_page.dart';
import '../../core/utils/validators.dart';
import '../../core/themes/app_themes.dart';
import '../../core/utils/environment.dart';

class PasswordRestorePage extends StatefulWidget {
  final String token;
  const PasswordRestorePage({Key? key, required this.token}) : super(key: key);

  @override
  State<PasswordRestorePage> createState() => _PasswordRecoveryPageState();
}

class _PasswordRecoveryPageState extends State<PasswordRestorePage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  Future<void> _submitRecoveryRequest() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiService().requestPasswordReset(
        _passwordController.text.trim(),
        widget.token,
      );

      if (response['success'] == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RecoverySentPage()),
        );
      } else {
        CustomSnackbar.showError(
          context,
          response['message'] ?? 'Error desconocido',
        );
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
                'Ingresa la nueva contraseña',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 40),
              CustomTextField(
                label: 'Coloca tu nueva contraseña',
                hintText: 'Nueva contraseña segura',
                controller: _passwordController,
                validator: Validators.validatePassword,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'Confirma tu nueva contraseña',
                hintText: 'Repite tu contraseña',
                controller: _passwordConfirmController,
                validator: (value) => Validators.validatePasswordConfirmation(
                  value,
                  _passwordController.text,
                ),
                obscureText: true,
                showPasswordToggle: true,
                isPasswordVisible: _isPasswordVisible,
                onSuffixIconPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
              const SizedBox(height: 40),
              PrimaryButton(
                text: 'Restablecer contraseña',
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
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }
}
