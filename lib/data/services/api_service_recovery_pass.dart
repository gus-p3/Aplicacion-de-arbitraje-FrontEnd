import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/utils/environment.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final String _baseUrl = Environment.apiBaseUrl;
  final Map<String, String> _headers = {'Content-Type': 'application/json'};

  Future<Map<String, dynamic>> requestPasswordRecovery(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/password-recovery/auth/forgot-password'),
        headers: _headers,
        body: json.encode({'correo': email}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<Map<String, dynamic>> requestPasswordReset(
    String password,
    String token,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/password-recovery/auth/reset-password'),
        headers: _headers,
        body: json.encode({'nuevaContraseña': password, 'token': token}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<Map<String, dynamic>> requestValidateToken(
    String token,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/password-recovery/validate-token'),
        headers: _headers,
        body: json.encode({ 'token': token}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
