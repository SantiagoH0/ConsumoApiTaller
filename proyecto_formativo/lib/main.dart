import 'package:flutter/material.dart';
import 'package:proyecto_formativo/screen_views/compras_home.dart';
import 'package:proyecto_formativo/screen_views/home.dart';
import 'package:proyecto_formativo/screen_views/login.dart';
import 'package:proyecto_formativo/screen_views/picture.dart';
import 'package:proyecto_formativo/screen_views/proveedores_home.dart';


void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tu App',
      theme: ThemeData(
        primarySwatch: Colors.orange
      ),
      initialRoute: '/login',
      routes: {
        '/home':(context) => const Menu(),
        '/login': (context) => const LogIn(),
        '/homeCompras': (context) => const HomeCompras(),
        '/homeProveedores': (context) => const Home(),
        '/picture': (context) => const TakePhoto()
      },
    );
  }
}