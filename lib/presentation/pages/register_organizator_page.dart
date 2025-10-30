import 'package:flutter/material.dart';
import '../../data/models/organizador_complete_model.dart';
import '../../data/services/organizador_service.dart';

class RegistroOrganizadorScreen extends StatefulWidget {
  const RegistroOrganizadorScreen({Key? key}) : super(key: key);

  @override
  State<RegistroOrganizadorScreen> createState() =>
      _RegistroOrganizadorScreenState();
}

class _RegistroOrganizadorScreenState extends State<RegistroOrganizadorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = OrganizadorService();

  // Controladores para los campos
  final _correoController = TextEditingController();
  final _contraseniaController = TextEditingController();
  final _confirmarContraseniaController = TextEditingController();
  final _nombreController = TextEditingController();
  final _apellidoPController = TextEditingController();
  final _apellidoMController = TextEditingController();
  final _curpController = TextEditingController();
  final _ineController = TextEditingController();
  final _nombreOrgController = TextEditingController();
  final _tipoOrgController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _telefonoPrincipalController =
      TextEditingController(); // Cambiado nombre
  final _redesController = TextEditingController();

  DateTime? _fechaNacimiento;
  DateTime? _fechaCreacionOrg; // Nueva fecha para la organización
  String _sexo = 'H';
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _correoController.dispose();
    _contraseniaController.dispose();
    _confirmarContraseniaController.dispose();
    _nombreController.dispose();
    _apellidoPController.dispose();
    _apellidoMController.dispose();
    _curpController.dispose();
    _ineController.dispose();
    _nombreOrgController.dispose();
    _tipoOrgController.dispose();
    _descripcionController.dispose();
    _telefonoPrincipalController.dispose();
    _redesController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFecha() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      locale: const Locale('es', 'MX'),
    );

    if (picked != null && picked != _fechaNacimiento) {
      setState(() {
        _fechaNacimiento = picked;
      });
    }
  }

  Future<void> _registrar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_fechaNacimiento == null) {
      _mostrarError('Por favor selecciona tu fecha de nacimiento');
      return;
    }

    if (_contraseniaController.text != _confirmarContraseniaController.text) {
      _mostrarError('Las contraseñas no coinciden');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final request = RegistroOrganizadorRequest(
        datosPersonales: DatosPersonales(
          correo: _correoController.text.trim(),
          contrasenia: _contraseniaController.text,
          nombre: _nombreController.text.trim(),
          apellidoP: _apellidoPController.text.trim(),
          apellidoM: _apellidoMController.text.trim(),
          fechaNacimiento: _fechaNacimiento!,
          curp: _curpController.text.trim().toUpperCase(),
          ine: _ineController.text.trim(),
          sexo: _sexo,
        ),
        datosOrganizacion: DatosOrganizacion(
  nombreOrganizacion: _nombreOrgController.text.trim().isEmpty 
      ? null 
      : _nombreOrgController.text.trim(),
  tipoOrganizacion: _tipoOrgController.text.trim().isEmpty 
      ? null 
      : _tipoOrgController.text.trim(),
  descripcion: _descripcionController.text.trim().isEmpty 
      ? null 
      : _descripcionController.text.trim(),
  fechaCreacionOrganizacion: DateTime.now(), // ✅ Siempre enviar fecha actual
),
        contacto: Contacto(
          telefonoPrincipal: _telefonoPrincipalController.text.trim(),
          redesSociales: _redesController.text.trim().isEmpty
              ? null
              : _redesController.text.trim(),
        ),
        configuracion: Configuracion(notificaciones: true, idioma: 'es'),
      );

      final response = await _service.registrarOrganizador(request);

      if (response.success) {
        _mostrarExito(response.message);
        // Navegar a otra pantalla o limpiar formulario
        _limpiarFormulario();
      } else {
        String mensaje = response.message;
        if (response.errores != null && response.errores!.isNotEmpty) {
          mensaje += '\n${response.errores!.join('\n')}';
        }
        _mostrarError(mensaje);
      }
    } catch (e) {
      _mostrarError('Error inesperado: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _limpiarFormulario() {
    _formKey.currentState?.reset();
    _correoController.clear();
    _contraseniaController.clear();
    _confirmarContraseniaController.clear();
    _nombreController.clear();
    _apellidoPController.clear();
    _apellidoMController.clear();
    _curpController.clear();
    _ineController.clear();
    _nombreOrgController.clear();
    _tipoOrgController.clear();
    _descripcionController.clear();
    _telefonoPrincipalController.clear();
    _redesController.clear();
    setState(() {
      _fechaNacimiento = null;
      _sexo = 'H';
    });
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _mostrarExito(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Organizador'),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // SECCIÓN: DATOS PERSONALES
                    _buildSectionTitle('Datos Personales'),
                    _buildTextField(
                      controller: _correoController,
                      label: 'Correo Electrónico',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El correo es requerido';
                        }
                        if (!_service.validarCorreo(value)) {
                          return 'Ingresa un correo válido';
                        }
                        return null;
                      },
                    ),
                    _buildPasswordField(
                      controller: _contraseniaController,
                      label: 'Contraseña',
                      obscure: _obscurePassword,
                      onToggle: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'La contraseña es requerida';
                        }
                        if (!_service.validarContrasenia(value)) {
                          return 'Mínimo 8 caracteres';
                        }
                        return null;
                      },
                    ),
                    _buildPasswordField(
                      controller: _confirmarContraseniaController,
                      label: 'Confirmar Contraseña',
                      obscure: _obscureConfirmPassword,
                      onToggle: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Confirma tu contraseña';
                        }
                        return null;
                      },
                    ),
                    _buildTextField(
                      controller: _nombreController,
                      label: 'Nombre',
                      icon: Icons.person,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El nombre es requerido';
                        }
                        return null;
                      },
                    ),
                    _buildTextField(
                      controller: _apellidoPController,
                      label: 'Apellido Paterno',
                      icon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El apellido paterno es requerido';
                        }
                        return null;
                      },
                    ),
                    _buildTextField(
                      controller: _apellidoMController,
                      label: 'Apellido Materno',
                      icon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El apellido materno es requerido';
                        }
                        return null;
                      },
                    ),

                    // Fecha de Nacimiento
                    Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: const Icon(Icons.calendar_today),
                        title: Text(
                          _fechaNacimiento == null
                              ? 'Seleccionar Fecha de Nacimiento'
                              : 'Fecha: ${_fechaNacimiento!.day}/${_fechaNacimiento!.month}/${_fechaNacimiento!.year}',
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: _seleccionarFecha,
                      ),
                    ),

                    // Sexo
                    Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Sexo',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<String>(
                                    title: const Text('Hombre'),
                                    value: 'H',
                                    groupValue: _sexo,
                                    onChanged: (value) {
                                      setState(() {
                                        _sexo = value!;
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<String>(
                                    title: const Text('Mujer'),
                                    value: 'M',
                                    groupValue: _sexo,
                                    onChanged: (value) {
                                      setState(() {
                                        _sexo = value!;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    _buildTextField(
                      controller: _curpController,
                      label: 'CURP',
                      icon: Icons.badge,
                      textCapitalization: TextCapitalization.characters,
                      maxLength: 18,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El CURP es requerido';
                        }
                        if (!_service.validarFormatoCURP(value)) {
                          return 'CURP inválido (18 caracteres)';
                        }
                        return null;
                      },
                    ),
                    _buildTextField(
                      controller: _ineController,
                      label: 'INE',
                      icon: Icons.credit_card,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El INE es requerido';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // SECCIÓN: DATOS DE ORGANIZACIÓN
                    _buildSectionTitle('Datos de Organización'),
                    _buildTextField(
                      controller: _nombreOrgController,
                      label: 'Nombre de la Organización',
                      icon: Icons.business,
                    ),
                    _buildTextField(
                      controller: _tipoOrgController,
                      label: 'Tipo de Organización',
                      icon: Icons.category,
                    ),
                    _buildTextField(
                      controller: _descripcionController,
                      label: 'Descripción',
                      icon: Icons.description,
                      maxLines: 3,
                    ),

                    const SizedBox(height: 20),

                    // SECCIÓN: CONTACTO
                    _buildSectionTitle('Contacto'),
                    _buildTextField(
                      controller: _telefonoPrincipalController,
                      label: 'Teléfono',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                    ),
                    _buildTextField(
                      controller: _redesController,
                      label: 'Redes Sociales',
                      icon: Icons.share,
                    ),

                    const SizedBox(height: 30),

                    // BOTÓN DE REGISTRO
                    ElevatedButton(
                      onPressed: _isLoading ? null : _registrar,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'REGISTRAR',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
    int? maxLength,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          counterText: maxLength != null ? '' : null,
        ),
        keyboardType: keyboardType,
        validator: validator,
        maxLines: maxLines,
        maxLength: maxLength,
        textCapitalization: textCapitalization,
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: Icon(obscure ? Icons.visibility : Icons.visibility_off),
            onPressed: onToggle,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        validator: validator,
      ),
    );
  }
}
