class Person {
  String name;
  String nPhone;
  String license;

  Person({
    required this.name,
    required this.nPhone,
    required this.license,
  });

  // Convertir Person a un mapa (JSON)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'nPhone': nPhone,
      'license': license,
    };
  }

  // Crear Person a partir de un mapa (JSON)
  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      name: json['name'],
      nPhone: json['nPhone'],
      license: json['license'],
    );
  }
}
