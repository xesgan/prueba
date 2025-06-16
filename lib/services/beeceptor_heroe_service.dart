import 'dart:convert';
import 'package:borrar2/models/heroe.dart';
import 'package:borrar2/models/heroe_con_id.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// 🧩 Servicio que gestiona la conexión con Beeceptor CRUD
// Se encarga de realizar todas las operaciones CRUD sobre el nodo "heroes"

class BeeceptorHeroeService extends ChangeNotifier {
  // 🌐 URL base del nodo de heroes (sin .json final)
  final String _baseUrl =
      'https://ca88f92acf9858949765.free.beeceptor.com/api/heroes';

  // 🔸 READ: Obtener todos los usuarios desde Firebase
  // Devuelve una lista de objetos HeroesConId (id + heroe)
  Future<List<HeroeConId>> fetchHeroes() async {
    final response = Uri.parse(_baseUrl);
    final res = await http.get(response);

    if (res.statusCode != 200) {
      throw Exception('Error al cargar heroes desde la API');
    }

    // ✅ CAMBIO: Beeceptor CRUD responde con una lista [], no un mapa {}
    final List<dynamic> data = json.decode(res.body);
    final List<HeroeConId> fetched = [];

    for (var item in data) {
      // ✅ CAMBIO: Se usa el campo 'id' que Beeceptor agrega automáticamente
      final heroe = Heroe.fromMap(item);
      final id = item['id'];
      fetched.add(HeroeConId(id: id, heroe: heroe));
    }

    return fetched;
  }

  // 🔸 CREATE: Añadir un nuevo usuario
  // Firebase genera automáticamente un ID único para este usuario
  Future<void> createHeroe(Heroe heroe) async {
    final url = Uri.parse(_baseUrl);
    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: heroe.toJson(),
    );

    // Firebase puede devolver 200 o 201 en función del entorno
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('Error al crear heroe');
    }
    notifyListeners();
  }

  // 🔸 UPDATE: Modificar un usuario existente
  // Se necesita el ID del usuario en Firebase (clave del nodo)
  Future<void> updateHeroe(String id, Heroe heroe) async {
    final url = Uri.parse('$_baseUrl/$id');
    final res = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: heroe.toJson(),
    );

    if (res.statusCode != 200) {
      throw Exception('Error al actualizar heroe');
    }

    // Notificar a los listeners que se ha actualizado un heroe
    notifyListeners();
  }

  // 🔸 DELETE: Eliminar un usuario
  // Se necesita el ID del usuario para borrar su nodo
  Future<void> deleteHeroe(String id, Heroe heroe) async {
    print('[DELETE] Heroe: $id, ${heroe.name}');

    final url = Uri.parse('$_baseUrl/$id');
    final res = await http.delete(url);

    print('[DELETE] status: ${res.statusCode}, body: ${res.body}');

    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception('Error al eliminar heroe');
    }
    notifyListeners();
  }
}
