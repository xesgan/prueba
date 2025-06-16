// 🔹 Clase auxiliar para combinar el ID de Firebase con el modelo Usuario
// Firebase guarda los usuarios en nodos con claves únicas generadas automáticamente.
// Estas claves (por ejemplo: "-Nc2FxRud8324abcd") no están dentro del objeto Usuario,
// pero las necesitamos para hacer update o delete.
// Esta clase nos permite trabajar con ambos a la vez.

import 'package:borrar2/models/heroe.dart';

class HeroeConId {
  final String id;
  final Heroe heroe;

  HeroeConId({required this.id, required this.heroe});
}
