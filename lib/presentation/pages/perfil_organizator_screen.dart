import 'package:flutter/material.dart';
import '../../data/services/auth_service.dart';
import '../../data/models/organizador_model.dart';
class PerfilScreen extends StatefulWidget {
  const PerfilScreen({Key? key}) : super(key: key);

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final _authService = AuthService();
  OrganizadorModel? _organizador;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPerfil();
  }

  Future<void> _loadPerfil() async {
    // Primero intenta cargar datos guardados
    final savedData = await _authService.getUserData();
    
    if (savedData != null) {
      setState(() {
        _organizador = savedData;
        _isLoading = false;
      });
    }

    // Luego actualiza desde el servidor
    final result = await _authService.getPerfil();
    
    if (result['success']) {
      setState(() {
        _organizador = OrganizadorModel.fromJson(result['organizador']);
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _logout() async {
    await _authService.logout();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _organizador == null
              ? const Center(child: Text('No se pudo cargar el perfil'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              child: Text(
                                _organizador!.nombre[0].toUpperCase(),
                                style: const TextStyle(fontSize: 40),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _organizador!.nombreCompleto,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildInfoCard(
                        'Información Personal',
                        [
                          _buildInfoRow('Nombre', _organizador!.nombre),
                          _buildInfoRow('Apellido Paterno', _organizador!.apellidoP),
                          _buildInfoRow('Apellido Materno', _organizador!.apellidoM),
                          _buildInfoRow('Correo', _organizador!.correo),
                          _buildInfoRow('Clave', _organizador!.claveOrganizacion),
                          _buildInfoRow('Estado', _organizador!.estado),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildInfoCard(
                        'Organización',
                        [
                          _buildInfoRow('Nombre', _organizador!.nombreOrganizacion),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}