import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:proyecto_formativo/screen_views/home.dart';
import 'package:proyecto_formativo/screen_views/proveedores_edit.dart';
import 'package:proyecto_formativo/screen_views/proveedores_model.dart';
import 'package:proyecto_formativo/screen_views/proveedores_create.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  DataModel? dataFromAPI;

  _getData() async {
    try {
      String url =
          "https://project-valisoft-2559218.onrender.com/api/proveedores";
      http.Response res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        dataFromAPI = DataModel.fromJson(json.decode(res.body));
        _isLoading = false;
        setState(() {});
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _eliminarProveedor(String id) async {
    try {
      final response = await http.delete(
        Uri.parse(
            'https://project-valisoft-2559218.onrender.com/api/proveedores'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({"_id": id}),
      );

      if (response.statusCode == 204) {
        setState(() {
          _getData();
        });
      } else {
        throw Exception('Error al eliminar');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Lista de proveedores"),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(
                        label: Text(
                          'Nombre',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'NIT',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Email',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Teléfono',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Estado',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Categoría',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Acciones',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    rows: dataFromAPI?.proveedors.map((proveedor) {
                      return DataRow(cells: [
                        DataCell(Text(proveedor.nombre.toString())),
                        DataCell(Text(proveedor.nit.toString())),
                        DataCell(Text(proveedor.email.toString())),
                        DataCell(Text(proveedor.telefono.toString())),
                        DataCell(Text(proveedor.estado.toString())),
                        DataCell(
                          Text(
                            proveedor.categoria.toString(),
                          ),
                        ),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProveedorPut(provee: proveedor),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.edit, color: Colors.blue),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                onPressed: () {
                                  _eliminarProveedor(proveedor.id);
                                    Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>const Menu(),
                                    )
                                  );
                                },
                                icon: const Icon(Icons.delete, color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ]);
                    }).toList() ??
                        [],
                  ),
                ),
              ),
            ),
      bottomNavigationBar: const BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  const MyApp(), // Debes definir esta pantalla en otro archivo
            ),
          );
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
    );
  }
}
