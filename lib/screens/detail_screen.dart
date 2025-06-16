import 'package:borrar2/models/heroe.dart';
import 'package:flutter/material.dart'; // Importa el paquete de widgets de Flutter

// Define un widget sin estado llamado DetailScreen
class DetailScreen extends StatelessWidget {
  final Heroe heroe; // Declara una variable final para almacenar el usuario

  // Constructor que recibe un usuario como parámetro requerido
  const DetailScreen({super.key, required this.heroe});

  @override
  Widget build(BuildContext context) {
    // Construye la interfaz de usuario
    return Scaffold(
      appBar: AppBar(
        title: Text(heroe.name),
      ), // Barra superior con el nombre del usuario
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20), // Padding alrededor del contenido
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Alinea los hijos al inicio
            children: [
              // 🖼️ Imagen del usuario
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    10,
                  ), // Bordes redondeados para la imagen
                  child: Image.network(
                    heroe.foto, // URL de la foto del usuario, vacío si es null
                    height: 200, // Altura de la imagen
                    width: 200, // Anchura de la imagen
                    fit: BoxFit.cover, // Ajusta la imagen para cubrir el área
                    errorBuilder:
                        (context, error, stackTrace) => const Icon(
                          Icons.broken_image,
                        ), // Icono si falla la carga de la imagen
                  ),
                ),
              ),
              const SizedBox(height: 20), // Espacio vertical
              // 📋 Información del usuario
              Text(
                'Nombre: ${heroe.name}', // Muestra el nombre del usuario
                style: const TextStyle(fontSize: 18), // Estilo de texto
              ),
              const SizedBox(height: 8), // Espacio vertical
              Text(
                'Tipo: ${heroe.tipo}', // Muestra el correo del usuario
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'Precio: ${heroe.precio}', // Muestra la dirección del usuario
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'Descripción: ${heroe.descripcion}', // Muestra el teléfono del usuario
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
