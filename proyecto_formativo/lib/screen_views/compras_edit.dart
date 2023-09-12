import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:proyecto_formativo/screen_views/home.dart';
import 'package:proyecto_formativo/screen_views/compras_model.dart';
import 'package:http/http.dart' as http;

final Color formBackgroundColor = Colors.grey[200]!;
const Color formLabelColor = Colors.black;
const Color formHintColor = Colors.grey;
const Color formButtonColor =
    Colors.orange; // Cambiar el color del botón a naranja

Future<Compras> updateCompras(
    String id,
    String numeroCompra,
    String producto,
    String proveedor,
    String cantidad,
    String precio,
    String iva,
    String montoIVa,
    String subtotal,
    String total) async {
  final response = await http.put(
    Uri.parse(
        'https://proyecto-formativo-2559218-backend.onrender.com/api/compra'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      "_id": id,
      "numeroCompra": int.parse(numeroCompra),
      "producto": producto,
      "proveedor": proveedor,
      "cantidad": int.parse(cantidad),
      "precio": double.parse(precio),
      "iva": double.parse(iva),
      "montoIva": double.parse(montoIVa),
      "subtotal": double.parse(subtotal),
      "total": double.parse(total),
    }),
  );

  if (response.statusCode == 201) {
    return Compras.fromJson(jsonDecode(response.body));
  } else {
    throw Exception(response.body);
  }
}

class Compras {
  Compras({
    required this.id,
    required this.numeroCompra,
    required this.producto,
    required this.proveedor,
    required this.cantidad,
    required this.precio,
    required this.iva,
    required this.fecha,
    required this.montoIva,
    required this.subtotal,
    required this.total,
  });

  final String id;
  final int numeroCompra;
  final String producto;
  final String proveedor;
  final int cantidad;
  final double precio;
  final double iva;
  final String fecha;
  final double montoIva;
  final double subtotal;
  final double total;

  factory Compras.fromJson(Map<String, dynamic> json) {
    return Compras(
        id: json["_id"],
        numeroCompra: json["numeroCompra"] as int,
        producto: json["producto"],
        proveedor: json["proveedor"],
        cantidad: json["cantidad"] as int,
        precio: json["precio"] as double,
        iva: json["iva"],
        fecha: json["fecha"],
        montoIva: json["montoIva"] as double,
        subtotal: json["subtotal"] as double,
        total: json["total"] as double);
  }
}

class ComprasPut extends StatefulWidget {
  final ComprasVali compr;

  const ComprasPut({required this.compr, Key? key}) : super(key: key);

  @override
  State<ComprasPut> createState() {
    return _ComprasPutState();
  }
}

class _ComprasPutState extends State<ComprasPut> {
  final TextEditingController _numeroCompra = TextEditingController();
  final TextEditingController _producto = TextEditingController();
  final TextEditingController _proveedor = TextEditingController();
  final TextEditingController _cantidad = TextEditingController();
  final TextEditingController _precio = TextEditingController();
  final TextEditingController _iva = TextEditingController();
  final TextEditingController _montoIva = TextEditingController();
  final TextEditingController _subtotal = TextEditingController();
  final TextEditingController _total = TextEditingController();

  Future<Compras>? _futureCompra;

  @override
  void initState() {
    super.initState();
    _numeroCompra.text = widget.compr.numeroCompra.toString();
    _producto.text = widget.compr.producto;
    _proveedor.text = widget.compr.proveedor;
    _cantidad.text = widget.compr.cantidad.toString();
    _precio.text = widget.compr.precio.toString();
    _iva.text = widget.compr.iva.toString();
    _montoIva.text = widget.compr.montoIva.toString();
    _subtotal.text = widget.compr.subtotal.toString();
    _total.text = widget.compr.total.toString();
  }

  ComprasVali? dataFromAPI;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Modificar Compra',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Modificar Compra'),
          backgroundColor:
              Colors.orange, // Cambiar el color del AppBar a naranja
        ),
        body: Container(
          color: formBackgroundColor,
          padding: const EdgeInsets.all(16),
          child: (_futureCompra == null) ? buildColumn() : buildFutureBuilder(),
        ),
      ),
    );
  }

  Column buildColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildTextField(_numeroCompra, 'Numero Compra',
            Icons.person), // Agregar icono para Nombre
        const SizedBox(height: 20),
        _buildTextField(_producto, 'Producto',
            Icons.confirmation_number), // Agregar icono para Nit
        const SizedBox(height: 20),
        _buildTextField(
            _proveedor, 'proveedor', Icons.email), // Agregar icono para Email
        const SizedBox(height: 20),
        _buildTextField(
            _cantidad, 'cantidad', Icons.phone), // Agregar icono para Teléfono
        const SizedBox(height: 20),
        _buildTextField(
            _precio, 'precio', Icons.category), // Agregar icono para Categoría
        const SizedBox(height: 20),
        _buildTextField(
            _iva, 'iva', Icons.check_circle), // Agregar icono para Estado
        const SizedBox(height: 20),
        _buildTextField(_montoIva, 'montoIva',
            Icons.check_circle), // Agregar icono para Estado
        const SizedBox(height: 20),
        _buildTextField(_subtotal, 'subtotal',
            Icons.check_circle), // Agregar icono para Estado
        const SizedBox(height: 20),
        _buildTextField(
            _total, 'total', Icons.check_circle), // Agregar icono para Estado
        const SizedBox(height: 20),
        Container(
          margin: const EdgeInsets.only(
              bottom: 38.0), // Añadir un margen inferior de 38px
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _futureCompra = updateCompras(
                    widget.compr.id,
                    _numeroCompra.text,
                    _producto.text,
                    _proveedor.text,
                    _cantidad.text,
                    _precio.text,
                    _iva.text,
                    _montoIva.text,
                    _subtotal.text,
                    _total.text);
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: formButtonColor,
            ),
            child: const Text('Actualizar'),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hintText, IconData? icon) {
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
        icon: icon != null
            ? Icon(icon)
            : null, // Mostrar el icono si está presente
      ),
    );
  }

  FutureBuilder<Compras> buildFutureBuilder() {
    return FutureBuilder<Compras>(
      future: _futureCompra,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Text(
                'Compra registrada: ${snapshot.data!.numeroCompra}',
                style: const TextStyle(color: Colors.green),
              ),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Menu(),
                    ),
                  );
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
            children: [
              Text(
                '${snapshot.error}',
                style: const TextStyle(color: Colors.orange),
              ),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Menu(),
                    ),
                  );
                },
                child: const Text('Regresar'),
              ),
            ],
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
