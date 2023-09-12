import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar sesión'),
        backgroundColor: Colors.orange, 
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20.0), 
            Image.network(
              'https://static.vecteezy.com/system/resources/thumbnails/007/407/996/small/user-icon-person-icon-client-symbol-login-head-sign-icon-design-vector.jpg', 
              width: 200, 
              height: 200, 
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20.0), 
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: LoginForm(),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // ignore: unused_field
  bool _isAuthenticated = false;

  void _authenticate() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username == 'user1' && password == '123') {
      setState(() {
        _isAuthenticated = true;
      });
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error de autenticación'),
            content: const Text('Usuario o contraseña incorrectos.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Aceptar'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextFormField(
          controller: _usernameController,
          decoration: const InputDecoration(
            labelText: 'Usuario',
            icon: Icon(Icons.person), // Icono para el campo de usuario
          ),
        ),
        TextFormField(
          controller: _passwordController,
          decoration: const InputDecoration(
            labelText: 'Contraseña',
            icon: Icon(Icons.lock), // Icono para el campo de contraseña
          ),
          obscureText: true,
        ),
        const SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: _authenticate,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                Colors.orange, // Cambia el color del botón a naranja
          ),
          child: const Text('Iniciar sesión'),
        ),
      ],
    );
  }
}
