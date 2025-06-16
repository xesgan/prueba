import 'package:borrar2/models/heroe.dart';
import 'package:borrar2/services/beeceptor_heroe_service.dart';
import 'package:flutter/material.dart';

// 🧾 Pantalla que sirve para crear o editar usuarios
class HeroeFormScreen extends StatefulWidget {
  const HeroeFormScreen({super.key});

  @override
  State<HeroeFormScreen> createState() => _HeroeFormScreenState();
}

class _HeroeFormScreenState extends State<HeroeFormScreen> {
  // 🔧 Clave del formulario y controladores para cada campo
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _nameController = TextEditingController();
  final _tipoController = TextEditingController();
  final _precioController = TextEditingController();
  final _photoController = TextEditingController();
  // Introducir 2 campos mas

  String? _heroeId; // 🔁 Si esto no es null, estamos editando un usuario

  // 📦 Recupera los argumentos pasados por Navigator (si los hay)
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      _heroeId = args['id']; // se guarda el id para hacer update

      // Rellenamos los campos con los datos del usuario existente
      if (args.containsKey('heroe') && args['heroe'] != null) {
        final Heroe heroe = args['heroe'];
        _descriptionController.text = heroe.descripcion;
        _nameController.text = heroe.name;
        _tipoController.text = heroe.tipo;
        _precioController.text = heroe.precio.toString();
        _photoController.text = heroe.foto;
      }
    }
  }

  // ✅ Función que valida y guarda el usuario (nuevo o editado)
  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final newHeroe = Heroe(
        descripcion: _descriptionController.text.trim(),
        name: _nameController.text.trim(),
        tipo: _tipoController.text.trim(),
        precio: _precioController.text.trim(),
        foto: _photoController.text.trim(),
      );

      // ➕ Crear
      if (_heroeId == null) {
        await BeeceptorHeroeService().createHeroe(newHeroe);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Heroe creado')));
      }
      // 📝 Actualizar
      else {
        await BeeceptorHeroeService().updateHeroe(_heroeId!, newHeroe);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Heroe actualizado')));
      }

      Navigator.pop(context); // 🔙 Volver a la pantalla anterior
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _heroeId != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Editar Heroe' : 'Nuevo Heroe')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(_nameController, 'Nombre', true),
              const SizedBox(height: 12),
              _buildTextField(_descriptionController, 'Descripción', false),
              const SizedBox(height: 12),
              _buildTextField(_tipoController, 'Tipo', true),
              const SizedBox(height: 12),
              _buildTextField(_precioController, 'Precio', true),
              const SizedBox(height: 12),
              _buildTextField(_photoController, 'URL de la foto', false),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                child: Text(isEditing ? 'Actualizar' : 'Crear'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🧱 Método que construye campos reutilizables con validación
  Widget _buildTextField(
    TextEditingController controller,
    String label,
    bool required, {
    bool email = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      validator: (value) {
        if (required && (value == null || value.trim().isEmpty)) {
          return 'Este campo es obligatorio';
        }
        if (email) {
          final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
          if (!emailRegex.hasMatch(value!)) {
            return 'Correo no válido';
          }
        }
        return null;
      },
    );
  }
}
