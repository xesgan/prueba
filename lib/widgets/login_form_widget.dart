import 'package:borrar2/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('email') ?? '';
    final savedPassword = prefs.getString('password') ?? '';
    final rememberMe = prefs.getBool('rememberMe') ?? false;

    if (rememberMe) {
      _emailController.text = savedEmail;
      _passwordController.text = savedPassword;
      setState(() {
        _rememberMe = true;
      });
    }
  }

  Future<void> _login() async {
    final prefs = await SharedPreferences.getInstance();

    if (_rememberMe) {
      await prefs.setString('email', _emailController.text);
      await prefs.setString('password', _passwordController.text);
      await prefs.setBool('rememberMe', true);
    } else {
      await prefs.remove('email');
      await prefs.remove('password');
      await prefs.setBool('rememberMe', false);
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(email: _emailController.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(
            Icons.lock_open_rounded,
            size: 64,
            color: Colors.tealAccent,
          ),
          const SizedBox(height: 20),
          const Text(
            'Acceso Seguro',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Correo electrónico'),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Introduce tu correo';
              }
              final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
              if (!emailRegex.hasMatch(value.trim())) {
                return 'Correo no válido';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Contraseña'),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Introduce tu contraseña';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Checkbox(
                value: _rememberMe,
                onChanged: (value) {
                  setState(() {
                    _rememberMe = value ?? false;
                  });
                },
              ),
              const Text(
                'Recordar sesión',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _login();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.tealAccent,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Acceder', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
