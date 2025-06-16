import 'dart:convert';

class Heroe {
  String name;
  String descripcion;
  String tipo;
  String precio;
  String foto;

  Heroe({
    required this.name,
    required this.descripcion,
    required this.tipo,
    required this.precio,
    required this.foto,
  });

  factory Heroe.fromJson(String str) => Heroe.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Heroe.fromMap(Map<String, dynamic> json) => Heroe(
    name: json["name"],
    descripcion: json["descripcion"],
    tipo: json["tipo"],
    precio: json["precio"],
    foto: json["foto"],
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "descripcion": descripcion,
    "tipo": tipo,
    "precio": precio,
    "foto": foto,
  };
}
