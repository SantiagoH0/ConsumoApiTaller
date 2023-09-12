import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//https://frontendhbs.onrender.com/
Future<Compras> createCompra(String numeroCompra, String producto, String proveedor, String cantidad, String precio, String iva, String montoIva, String subtotal, String total) async {
  final response = await http.post(
    Uri.parse('https://proyecto-formativo-2559218-backend.onrender.com/api/compra'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
        "numeroCompra": numeroCompra,
        "producto": producto,
        "proveedor": proveedor,
        "cantidad": cantidad,
        "precio": precio,
        "iva": iva,
        "montoIva" : montoIva,
        "subtotal" : subtotal,
        "total" : total,
    }),
  );

  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return Compras.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception(response.body);
  }
}

class Compras {
  final String id;
  final int numeroCompra;
  final String producto;
  final String proveedor;
  final int cantidad;
  final double precio;
  final double iva;
  final double montoIva;
  final double subtotal;
  final double total;

  const Compras({required this.id, required this.numeroCompra, required this.producto, required this.proveedor, required this.cantidad, required this.precio, required this.iva, required this.montoIva, required this.subtotal, required this.total});

  factory Compras.fromJson(Map<String, dynamic> json) {
    return Compras(
      id: json["_id"],
        numeroCompra: int.parse(json["numeroCompra"]),
        producto: json["producto"],
        proveedor: json["proveedor"],
        cantidad: int.parse(json["cantidad"]),
        precio: double.parse(json["precio"]),
        iva: double.parse(json["iva"]),
        montoIva: double.parse(json["montoIVa"]),
        subtotal: double.parse(json["subtotal"]),
        total:double.parse(json["total"])
    );
  }
}


void main() {
  runApp(const CreateComp());
}

class CreateComp extends StatefulWidget {
  const CreateComp({Key? key}) : super(key: key);

  @override
  State<CreateComp> createState() {
    return _CreateCompState();
  }
}

class _CreateCompState extends State<CreateComp> {
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
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crear Compra',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.orange,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: const Text("Crear Compra"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16),
          child: (_futureCompra == null) ? buildForm() : buildFutureBuilder(),
        ),
      ),
    );
  }

  Widget buildForm() {
    return ListView(
      children: <Widget>[
        buildTextField(_numeroCompra, 'Número de compra', Icons.confirmation_number),
        buildTextField(_producto, 'Producto', Icons.shopping_cart),
        buildTextField(_proveedor, 'Proveedor', Icons.person),
        buildTextField(_cantidad, 'Cantidad', Icons.layers),
        buildTextField(_precio, 'Precio', Icons.attach_money),
        buildTextField(_iva, 'IVA', Icons.local_taxi),
        buildTextField(_montoIva, 'Monto del IVA', Icons.money),
        buildTextField(_subtotal, 'Subtotal', Icons.money_off),
        buildTextField(_total, 'Total', Icons.attach_money),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _futureCompra = createCompra(
                _numeroCompra.text,
                _producto.text,
                _proveedor.text,
                _cantidad.text,
                _precio.text,
                _iva.text,
                _montoIva.text,
                _subtotal.text,
                _total.text,
              );
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
          ),
          child: const Text('Crear Compra'),
        ),
      ],
    );
  }

  Widget buildTextField(TextEditingController controller, String labelText, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  FutureBuilder<Compras> buildFutureBuilder() {
    return FutureBuilder<Compras>(
      future: _futureCompra,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!.producto);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const CircularProgressIndicator();
      },
    );
  }
}