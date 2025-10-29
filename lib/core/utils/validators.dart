class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu correo electrónico';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Por favor ingresa un correo electrónico válido';
    }

    return null;
  }

  //Validacion de contraseñas
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu contraseña';
    }

    if (value.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }

    final hasUppercase = RegExp(r'[A-Z]');
    final hasLowercase = RegExp(r'[a-z]');
    final hasNumber = RegExp(r'[0-9]');
    final hasSpecialChar = RegExp(r'[!@#\$%^&*(),.?":{}|<>]');

    if (!hasUppercase.hasMatch(value)) {
      return 'Debe contener al menos una letra mayúscula';
    }
    if (!hasLowercase.hasMatch(value)) {
      return 'Debe contener al menos una letra minúscula';
    }
    if (!hasNumber.hasMatch(value)) {
      return 'Debe contener al menos un número';
    }
    if (!hasSpecialChar.hasMatch(value)) {
      return 'Debe contener al menos un carácter especial';
    }

    return null;
  }

  // confirmar contraseña
  static String? validatePasswordConfirmation(
    String? value,
    String password,
  ) {
    if (value == null || value.isEmpty) {
      return 'Por favor confirma tu contraseña';
    }

    if (value != password) {
      return 'Las contraseñas no coinciden';
    }

    return null;
  }
}
