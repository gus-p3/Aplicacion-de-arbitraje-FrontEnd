
class DatosPersonales {
  final String correo;
  final String contrasenia;
  final String nombre;
  final String apellidoP;
  final String apellidoM;
  final DateTime fechaNacimiento;
  final String curp;
  final String ine;
  final String sexo; // 'H' o 'M'

  DatosPersonales({
    required this.correo,
    required this.contrasenia,
    required this.nombre,
    required this.apellidoP,
    required this.apellidoM,
    required this.fechaNacimiento,
    required this.curp,
    required this.ine,
    required this.sexo,
  });

  Map<String, dynamic> toJson() {
    return {
      'correo': correo,
      'contraseña': contrasenia,
      'nombre': nombre,
      'apellido_p': apellidoP,
      'apellido_m': apellidoM,
      'fecha_nacimiento': fechaNacimiento.toIso8601String(),
      'curp': curp,
      'ine': ine,
      'sexo': sexo,
    };
  }
}

class DatosOrganizacion {
  final String? nombreOrganizacion;
  final String? tipoOrganizacion;
  final String? descripcion;
  final DateTime? fechaCreacionOrganizacion;  // Opcional

  DatosOrganizacion({
    this.nombreOrganizacion,
    this.tipoOrganizacion,
    this.descripcion,
    this.fechaCreacionOrganizacion,
  });

  Map<String, dynamic> toJson() {
    return {
      if (nombreOrganizacion != null) 'nombre_organizacion': nombreOrganizacion,
      if (tipoOrganizacion != null) 'tipo_organizacion': tipoOrganizacion,
      if (descripcion != null) 'descripcion': descripcion,
      // Solo incluir si existe
      if (fechaCreacionOrganizacion != null)
        'fecha_creacion_organizacion': fechaCreacionOrganizacion!.toIso8601String(),
    };
  }
}

class Contacto {
  final String telefonoPrincipal;
  final String? redesSociales;

  Contacto({
    required this.telefonoPrincipal,
    this.redesSociales,
  });

  Map<String, dynamic> toJson() {
    return {
      'telefono_principal': telefonoPrincipal,
      'redes_sociales': redesSociales,
    };
  }
}

class Configuracion {
  final bool? notificaciones;
  final String? idioma;

  Configuracion({
    this.notificaciones,
    this.idioma,
  });

  Map<String, dynamic> toJson() {
    return {
      'notificaciones': notificaciones,
      'idioma': idioma,
    };
  }
}

class RegistroOrganizadorRequest {
  final DatosPersonales datosPersonales;
  final DatosOrganizacion datosOrganizacion;
  final Contacto contacto;
  final Configuracion? configuracion;

  RegistroOrganizadorRequest({
    required this.datosPersonales,
    required this.datosOrganizacion,
    required this.contacto,
    this.configuracion,
  });

  Map<String, dynamic> toJson() {
    return {
      'datos_personales': datosPersonales.toJson(),
      'datos_organizacion': datosOrganizacion.toJson(),
      'contacto': contacto.toJson(),
      if (configuracion != null) 'configuracion': configuracion!.toJson(),
    };
  }
}

class ApiResponse {
  final bool success;
  final String message;
  final dynamic data;
  final List<String>? errores;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.errores,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'],
      errores: json['errores'] != null 
          ? List<String>.from(json['errores']) 
          : null,
    );
  }
}