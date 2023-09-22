import 'package:flutter/material.dart';
import 'package:proyecto_formativo/screen_views/picture.dart';
import 'package:proyecto_formativo/screen_views/proveedores_home.dart';
import 'compras_home.dart';

void main() {
  runApp(const Menu());
}

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.orange
      ),
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.orange,
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Compras'),
                Tab(text: 'Proveedores'),
                Tab(text: 'Camara')
              ],
            ),
            title: const Text('VALICOR'),
          ),
          body: const Column(
            children: [
              Expanded(
                child: TabBarView(
                  children: [
                    HomeCompras(),
                    Home(),
                    TakePhoto()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}