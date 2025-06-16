// Importaciones principales
import 'package:borrar2/models/heroe.dart';
import 'package:borrar2/screens/detail_screen.dart';
import 'package:borrar2/screens/heroe_form_screen.dart';
import 'package:borrar2/services/beeceptor_heroe_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppState(initialRoute: 'login'));
}

class AppState extends StatelessWidget {
  final String initialRoute; // Ruta inicial al abrir la app
  const AppState({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BeeceptorHeroeService()),
      ],
      child: MyApp(initialRoute: initialRoute),
    );
  }
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Firebase + SharedPrefs',
      debugShowCheckedModeBanner: false,

      // 🌙 Tema oscuro elegante para toda la app
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.grey[900], // fondo general
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(), // bordes en inputs
          labelStyle: TextStyle(color: Colors.white), // texto de etiquetas
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white), // texto general
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStatePropertyAll(
            Colors.tealAccent,
          ), // color del check
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              Colors.tealAccent,
            ), // fondo botón
            foregroundColor: WidgetStatePropertyAll(
              Colors.black,
            ), // texto botón
          ),
        ),
      ),

      // 🏁 Pantalla inicial al abrir la app
      initialRoute: 'login',

      // 📍 Definición de rutas nombradas
      routes: {
        // 🔐 Login con validación y persistencia
        'login': (_) => const LoginScreen(),

        // 🏠 Home con listado de usuarios. Recibe el email desde login
        'home': (context) {
          final args =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>?;
          final email = args?['email'] ?? '';
          return HomeScreen(email: email);
        },

        // ➕ Formulario para crear o editar usuarios
        'heroe_form': (_) => HeroeFormScreen(),

        // 📖 Detalle de un usuario específico
        'heroe_details': (BuildContext context) {
          final args =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>;
          final heroe = args['heroe'] as Heroe;
          return DetailScreen(heroe: heroe);
        },
      },
    );
  }
}
