class OrganizadorModel{
  final String id;
  final String claveOrganizacion;
  final String correo;
  final String nombre;
  final String apellidoP;
  final String apellidoM;
  final String nombreOrganizacion;
  final String estado;

  OrganizadorModel({
    required this.id,
    required this.claveOrganizacion,
    required this.correo,
    required this.nombre,
    required this.apellidoP,
    required this.apellidoM,
    required this.nombreOrganizacion,
    required this.estado,


  });

  String get nombreCompleto => '$nombre $apellidoP $apellidoM';

  factory OrganizadorModel.fromJson(Map<String, dynamic>json){
return OrganizadorModel(
      id: json['id'] ?? '',
      claveOrganizacion: json['clave_organizacion'] ?? '',
      correo: json['correo'] ?? '',
      nombre: json['nombre'] ?? '',
      apellidoP: json['apellido_p'] ?? '',
      apellidoM: json['apellido_m'] ?? '',
      nombreOrganizacion: json['nombre_organizacion'] ?? '',
      estado: json['estado'] ?? '',
    );

  }
  Map<String, dynamic>toJson(){
    return{
      'id': id,
      'clave_organizacion': claveOrganizacion,
      'correo': correo,
      'nombre': nombre,
      'apellido_p': apellidoP,
      'apellido_m': apellidoM,
      'nombre_organizacion': nombreOrganizacion,
      'estado': estado,
    };

  }


}