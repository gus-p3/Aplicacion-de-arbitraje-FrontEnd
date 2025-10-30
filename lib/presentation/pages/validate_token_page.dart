import 'package:bioprode/presentation/pages/password_restore_page.dart';
import 'package:flutter/material.dart';
import '../../data/services/api_service_recovery_pass.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/custom_snackbar.dart';
import '../../core/themes/app_themes.dart';
import '../../core/utils/environment.dart';

class ValidateTokenPage extends StatefulWidget {
  const ValidateTokenPage({Key? key}) : super(key: key);

  @override
  State<ValidateTokenPage> createState() => _ValidateTokenPageState();
}

class _ValidateTokenPageState extends State<ValidateTokenPage> {
  final _formKey = GlobalKey<FormState>();
  final _tokenController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitRecoveryRequest() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiService().requestValidateToken(
        _tokenController.text.trim()
      );
      print(response['success']);

      if (response['success'] == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PasswordRestorePage(token: _tokenController.text.trim()),
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
                'Ingresa el codigo que se te fue enviado via correo electronico',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 40),
              CustomTextField(
                label: 'COdigo de verificación',
                hintText: 'XXXXXXXX',
                controller: _tokenController,
    
              ),
              const SizedBox(height: 40),
              PrimaryButton(
                text: 'Enviar codigo de recuperación',
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
    _tokenController.dispose();
    super.dispose();
  }
}