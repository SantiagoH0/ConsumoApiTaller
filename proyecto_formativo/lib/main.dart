import 'package:flutter/material.dart';
import 'package:proyecto_formativo/screen_views/compras_home.dart';
import 'package:proyecto_formativo/screen_views/home.dart';
import 'package:proyecto_formativo/screen_views/login.dart';
import 'package:proyecto_formativo/screen_views/proveedores_home.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tu App',
      theme: ThemeData(
        primarySwatch: Colors.orange
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/homeCompras': (context) => const HomeCompras(),
        '/homeProveedores': (context) => const Home(),
        '/home':(context) => const Menu()
      },
    );
  }
}
