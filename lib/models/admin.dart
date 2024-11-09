import 'package:proyectproducts/models/person.dart';

class Admin extends Person {
  String password;
  String role;

  Admin({
    required String name,
    required String nPhone,
    required String license,
    required this.password,
    this.role = 'admin', // El rol por defecto es "admin"
  }) : super(name: name, nPhone: nPhone, license: license);

  // Convertir Admin a un mapa (JSON)
  Map<String, dynamic> toJson() {
    final map = super.toJson();  // Usamos el método toJson de Person
    map['password'] = password;
    map['role'] = role;  // Agregamos el rol
    return map;
  }

  // Crear Admin a partir de un mapa (JSON)
  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      name: json['name'],
      nPhone: json['nPhone'],
      license: json['license'],
      password: json['password'],
      role: json['role'] ?? 'admin', // Si no hay rol, se asigna "admin" por defecto
    );
  }
}
