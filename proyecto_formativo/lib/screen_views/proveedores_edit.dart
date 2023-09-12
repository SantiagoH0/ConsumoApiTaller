import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:proyecto_formativo/screen_views/home.dart';
import 'package:proyecto_formativo/screen_views/proveedores_model.dart';
import 'package:http/http.dart' as http;

final Color formBackgroundColor = Colors.grey[200]!;
const Color formLabelColor = Colors.black;
const Color formHintColor = Colors.grey;
const Color formButtonColor = Colors.orange; // Cambiar el color del botón a naranja

Future<Proveed> updateProveedor(String id, String nombreProveedor, String nit, String emailProv, String telefonoProv, String categoriaProv, String estadoProv) async {
  final response = await http.put(
    Uri.parse('https://project-valisoft-2559218.onrender.com/api/proveedores'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
       "_id": id,
      "nombreProveedor": nombreProveedor,
      "nit": int.parse(nit),
      "emailProv": emailProv,
      "telefonoProv": int.parse(telefonoProv),
      "categoriaProv": categoriaProv,
      "estadoProv": estadoProv,
    }),
  );

  if (response.statusCode == 201) {
    return Proveed.fromJson(jsonDecode(response.body));
  } else {
    throw Exception(response.body);
  }
}

class Proveed{
  final String id;
  final String nombreProveedor;
  final int nit;
  final String emailProv;
  final int telefonoProv;
  final String categoriaProv;
  final bool estadoProv;

  const Proveed({
    required this.id,
    required this.nombreProveedor,
    required this.nit,
    required this.emailProv,
    required this.telefonoProv,
    required this.categoriaProv,
    required this.estadoProv,
  });

  factory Proveed.fromJson(Map<String, dynamic> json) {
    return Proveed(
      id: json["_id"],
        nombreProveedor: json["nombreProveedor"],
        nit: json["nit"],
        emailProv: json["emailProv"],
        telefonoProv: json["telefonoProv"],
        categoriaProv: json["categoriaProv"],
        estadoProv: json["estadoProv"],
       );
  }
}


class ProveedorPut extends StatefulWidget {
  final ProveedoresVali provee;

  const ProveedorPut({required this.provee, Key? key}) : super(key: key);

  @override
  State<ProveedorPut> createState() {
    return _ProveedorPutState();
  }
}

class _ProveedorPutState extends State<ProveedorPut> {
  final TextEditingController _nombreProveedor = TextEditingController();
  final TextEditingController _nit = TextEditingController();
  final TextEditingController _emailProv = TextEditingController();
  final TextEditingController _telefonoProv = TextEditingController();
  final TextEditingController _categoriaProv = TextEditingController();
  final TextEditingController _estadoProv = TextEditingController();

  Future<Proveed>? _futureProveed;

  @override
  void initState() {
    super.initState();
    _nombreProveedor.text = widget.provee.nombre;
    _nit.text = widget.provee.nit.toString();
    _emailProv.text = widget.provee.email;
    _telefonoProv.text = widget.provee.telefono.toString();
    _categoriaProv.text = widget.provee.categoria;
    _estadoProv.text = widget.provee.estado.toString();
  }

 ProveedoresVali? dataFromAPI;


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Modificar Proveedores',
      
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Modificar'),
          backgroundColor: Colors.orange, // Cambiar el color del AppBar a naranja
        ),
        body: Container(
          color: formBackgroundColor,
          padding: const EdgeInsets.all(16),
          child: (_futureProveed == null) ? buildColumn() : buildFutureBuilder(),
        ),
      ),
    );
  }

  Column buildColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildTextField(_nombreProveedor, 'Nombre', Icons.person), // Agregar icono para Nombre
        const SizedBox(height: 20),
        _buildTextField(_nit, 'Nit', Icons.confirmation_number), // Agregar icono para Nit
        const SizedBox(height: 20),
        _buildTextField(_emailProv, 'Email', Icons.email), // Agregar icono para Email
        const SizedBox(height: 20),
        _buildTextField(_telefonoProv, 'Teléfono', Icons.phone), // Agregar icono para Teléfono
        const SizedBox(height: 20),
        _buildTextField(_categoriaProv, 'Categoría', Icons.category), // Agregar icono para Categoría
        const SizedBox(height: 20),
        _buildTextField(_estadoProv, 'Estado', Icons.check_circle), // Agregar icono para Estado
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _futureProveed = updateProveedor(
                widget.provee.id,
                _nombreProveedor.text,
                _nit.text,
                _emailProv.text,
                _telefonoProv.text,
                _categoriaProv.text,
                _estadoProv.text,
              );
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: formButtonColor, // Cambiar el color del botón a naranja
          ),
          child: const Text('Actualizar'),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, IconData? icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: formHintColor),
        labelText: hintText,
        labelStyle: const TextStyle(color: formLabelColor),
        filled: true,
        fillColor: Colors.white,
        border: const OutlineInputBorder(),
        icon: icon != null ? Icon(icon) : null, // Mostrar el icono si está presente
      ),
    );
  }

  FutureBuilder<Proveed> buildFutureBuilder() {
    return FutureBuilder<Proveed>(
      future: _futureProveed,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Text(
                'Proveedor registrado: ${snapshot.data!.nombreProveedor}',
                style: const TextStyle(color: Colors.green),
              ),
              const SizedBox(height: 40,),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                        MaterialPageRoute(
                          builder: (context) => const Menu(),),);          
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: formButtonColor,
                ),
                child: const Text('Regresar'),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Column(
            children : [
              Text(
                '${snapshot.error}',
                style: const TextStyle(color: Colors.orange),
              ),
              const SizedBox(height: 40,),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(
                      builder: (context) => const Menu(),),);           
                }, child: const Text('Regresar'),
              ),
            ],
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
