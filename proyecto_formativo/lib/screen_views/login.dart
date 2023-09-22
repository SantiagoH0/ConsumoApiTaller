import 'package:flutter/material.dart';
import 'package:proyecto_formativo/screen_views/home.dart';
import 'package:proyecto_formativo/screen_views/login_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  bool isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final String validEmail = 'jaua@sa.com';
  final String validPassword = 'sasa';

  @override
  void initState() {
    super.initState();
    _getUsuarios();
  }

  DataModelUsuario? _dataModelUsuario;

  _getUsuarios() async {
    setState(() {
      isLoading = true;
    });

    try {
      String url = 'https://coff-v-art-api.onrender.com/api/user';
      http.Response res = await http.get(Uri.parse(url));

      if (res.statusCode == 200) {
        _dataModelUsuario = DataModelUsuario.fromJson(json.decode(res.body));
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error en la solicitud: ${res.statusCode}'),
          ),
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar los usuarios: $e'),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: Container(
        color: const Color.fromARGB(192, 244, 245, 245),
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                'https://th.bing.com/th/id/OIP.1NnSdHyJzQknI_uULOkoxgAAAA?pid=ImgDet&rs=1',
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Usuario',
                  icon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa tu usuario';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  icon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa tu contraseña';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final enteredEmail = _emailController.text.trim();
                    final enteredPassword = _passwordController.text.trim();
                    int positionUsuario = -1;

                    for (int i = 0;
                        i < _dataModelUsuario!.usuarios.length;
                        i++) {
                      if (_dataModelUsuario!.usuarios[i].email ==
                              enteredEmail &&
                          _dataModelUsuario!.usuarios[i].password ==
                              enteredPassword) {
                        positionUsuario = i;
                        break;
                      }
                    }

                    if (positionUsuario != -1) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const Menu(),
                      ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Correo o contraseña errados')),
                      );
                    }
                  }
                },
                child: const Text('Ingresar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
