import 'package:borrar2/models/heroe_con_id.dart';
import 'package:borrar2/services/beeceptor_heroe_service.dart';
import 'package:borrar2/widgets/heroe_card_widget.dart';
import 'package:flutter/material.dart';

// Servicio de conexión con Firebase
// Widget que muestra cada usuario con botones de acción

// Pantalla principal tras login. Muestra la lista de usuarios.
class HomeScreen extends StatefulWidget {
  final String email; // Se recibe desde login para mostrarlo si se desea
  const HomeScreen({super.key, required this.email});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<HeroeConId>> _heroesFuture;

  @override
  void initState() {
    super.initState();
    _heroesFuture = _loadHeroes();
  }

  Future<List<HeroeConId>> _loadHeroes() async {
    final service =
        BeeceptorHeroeService(); // o Provider.of(...) si lo inyectas
    return await service.fetchHeroes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Heroes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                'login',
                (route) => false,
              );
            },
          ),
        ],
      ),
      // 📦 Carga de usuarios desde Firebase usando FutureBuilder
      body: FutureBuilder<List<HeroeConId>>(
        future: _heroesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay heroes disponibles'));
          }

          final heroes = snapshot.data!;

          return ListView.builder(
            itemCount: heroes.length,
            itemBuilder: (context, index) {
              return HeroeCardWidget.HeroesCardWidget(
                heroe: heroes[index].heroe,
                id: heroes[index].id,
                onRefresh:
                    () => setState(() {
                      _heroesFuture = _loadHeroes(); // 🔄 refresca la lista
                    }),
              );
            },
          );
        },
      ),

      // ➕ Botón flotante para añadir nuevo usuario
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, 'heroe_form').then((_) {
            setState(() {
              _heroesFuture =
                  _loadHeroes(); // 🔁 recarga al volver del formulario
            });
          });
        },
        backgroundColor: Colors.tealAccent,
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
    );
  }
}
