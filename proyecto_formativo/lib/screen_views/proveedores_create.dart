import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

Future<Proveed> createProveedor(
  String nombreProveedor,
  String nit,
  String emailProv,
  String telefonoProv,
  String categoriaProv,
  String estadoProv,
) async {
  final response = await http.post(
    Uri.parse('https://project-valisoft-2559218.onrender.com/api/proveedores'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "nombreProveedor": nombreProveedor,
      "nit": nit,
      "emailProv": emailProv,
      "telefonoProv": telefonoProv,
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

class Proveed {
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

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _nombreProveedor = TextEditingController();
  final TextEditingController _nit = TextEditingController();
  final TextEditingController _emailProv = TextEditingController();
  final TextEditingController _telefonoProv = TextEditingController();
  final TextEditingController _categoriaProv = TextEditingController();
  final TextEditingController _estadoProv = TextEditingController();
  Future<Proveed>? _futureProveed;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crear Proveedores',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.orange,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: const Text('Crear Proveedor'),
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
          child: (_futureProveed == null) ? buildForm() : buildFutureBuilder(),
        ),
      ),
    );
  }

  Column buildForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        buildTextField(_nombreProveedor, 'Nombre', Icons.person),
        buildTextField(_nit, 'Nit', Icons.confirmation_number),
        buildTextField(_emailProv, 'Email', Icons.email),
        buildTextField(_telefonoProv, 'Teléfono', Icons.phone),
        buildTextField(_categoriaProv, 'Categoría', Icons.category),
        buildTextField(_estadoProv, 'Estado', Icons.check),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _futureProveed = createProveedor(
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
            backgroundColor: Colors.orange,
          ),
          child: const Text('Crear Proveedor'),
        ),
      ],
    );
  }

  Widget buildTextField(
    TextEditingController controller,
    String labelText,
    IconData icon,
  ) {
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

  FutureBuilder<Proveed> buildFutureBuilder() {
    return FutureBuilder<Proveed>(
      future: _futureProveed,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!.nombreProveedor);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const CircularProgressIndicator();
      },
    );
  }
}
