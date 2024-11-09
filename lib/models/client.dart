import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:proyectproducts/models/person.dart';

class Client extends Person {
  String password;
  String serviceKind;
  DateTime dateEntry;
  RxString remainingTime;
  String role;

  Client({
    required String name,
    required String nPhone,
    required String license,
    required this.password,
    required this.serviceKind,
    required this.dateEntry,
    required this.remainingTime,
    this.role = 'client', // El rol por defecto es "client"
  }) : super(name: name, nPhone: nPhone, license: license);

  // Convertir Client a un mapa (JSON)
  Map<String, dynamic> toJson() {
    final map = super.toJson(); // Usamos el método toJson de Person
    map['password'] = password;
    map['serviceKind'] = serviceKind;
    map['dateEntry'] = dateEntry.toIso8601String();
    map['remainingTime'] = remainingTime;
    map['role'] = role; // Agregamos el rol
    return map;
  }

  // Crear Client a partir de un mapa (JSON)
  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      name: json['name'],
      nPhone: json['nPhone'],
      license: json['license'],
      password: json['password'],
      serviceKind: json['serviceKind'],
      dateEntry: DateTime.parse(json['dateEntry']),
      remainingTime: json['remainingTime'],
      role: json['role'] ??
          'client', // Si no hay rol, se asigna "client" por defecto
    );
  }
}
