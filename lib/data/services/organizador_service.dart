
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/organizador_complete_model.dart';


class OrganizadorService {
  // TODO: Cambia esta URL por la de tu servidor
  static const String baseUrl = 'http://localhost:3006/api/auth';
  
  /// Registra un nuevo organizador
  Future<ApiResponse> registrarOrganizador(RegistroOrganizadorRequest request) async {
    try {
      final url = Uri.parse('$baseUrl/registerOrganizador');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      
      // Crear el ApiResponse con los datos recibidos
      final apiResponse = ApiResponse.fromJson(responseData);
      
      // Verificar el código de estado HTTP
      if (response.statusCode == 201) {
        // Registro exitoso
        return apiResponse;
      } else if (response.statusCode == 400) {
        // Error de validación
        return apiResponse;
      } else if (response.statusCode == 409) {
        // Conflicto (dato duplicado)
        return apiResponse;
      } else if (response.statusCode == 500) {
        // Error del servidor
        return apiResponse;
      } else {
        // Otro error
        return ApiResponse(
          success: false,
          message: 'Error inesperado: ${response.statusCode}',
        );
      }
    } catch (e) {
      // Error de conexión u otro error
      return ApiResponse(
        success: false,
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }

  /// Validación básica de CURP (formato)
  bool validarFormatoCURP(String curp) {
    if (curp.length != 18) return false;
    
    final curpRegex = RegExp(
      r'^[A-Z]{4}\d{6}[HM][A-Z]{5}[0-9A-Z]\d$',
      caseSensitive: true,
    );
    
    return curpRegex.hasMatch(curp.toUpperCase());
  }

  /// Validación de formato de correo
  bool validarCorreo(String correo) {
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return emailRegex.hasMatch(correo);
  }

  /// Validación de contraseña
  bool validarContrasenia(String contrasenia) {
    return contrasenia.length >= 8;
  }
}