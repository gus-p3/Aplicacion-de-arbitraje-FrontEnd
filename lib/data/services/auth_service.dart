import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/organizador_model.dart';

class AuthService {
  // Cambia esto por tu URL del servidor
  static const String baseUrl = 'http://localhost:3006/api/auth';
  
  // Para Android Emulator usa: http://10.0.2.2:3006/api/login
  // Para dispositivo físico usa tu IP local: http://192.168.1.X:3006/api/login

  // Login
  Future<Map<String, dynamic>> login(String correo, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/loginOrganizador'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'correo': correo,
          'contraseña': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Guardar token y datos del usuario
        await _saveToken(data['token']);
        await _saveUserData(data['organizador']);
        
        return {
          'success': true,
          'token': data['token'],
          'organizador': OrganizadorModel.fromJson(data['organizador']),
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['error'] ?? 'Error desconocido',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e',
      };
    }
  }

  // Obtener perfil del organizador
  Future<Map<String, dynamic>> getPerfil() async {
    try {
      final token = await getToken();
      
      if (token == null) {
        return {
          'success': false,
          'message': 'No hay token almacenado',
        };
      }

      final response = await http.get(
        Uri.parse('$baseUrl/perfil-organizador'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'organizador': data['organizador'],
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['error'] ?? 'Error al obtener perfil',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e',
      };
    }
  }

  // Guardar token
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Guardar datos del usuario
  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', jsonEncode(userData));
  }

  // Obtener token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Obtener datos del usuario
  Future<OrganizadorModel?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user_data');
    
    if (userData != null) {
      return OrganizadorModel.fromJson(jsonDecode(userData));
    }
    return null;
  }

  // Verificar si hay sesión activa
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  // Cerrar sesión
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_data');
  }
}