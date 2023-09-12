import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto_formativo/screen_views/compras_edit.dart';
import 'package:proyecto_formativo/screen_views/home.dart';
import 'package:proyecto_formativo/screen_views/compras_model.dart';
import 'package:proyecto_formativo/screen_views/compras_create.dart';

class HomeCompras extends StatefulWidget {
  const HomeCompras({Key? key}) : super(key: key);

  @override
  State<HomeCompras> createState() => _HomeComprasState();
}

class _HomeComprasState extends State<HomeCompras> {
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
          "https://proyecto-formativo-2559218-backend.onrender.com/api/compra";
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
            'https://proyecto-formativo-2559218-backend.onrender.com/api/compra'),
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
        title: const Text("Lista de compras"),
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
                          'Número Compra',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Producto',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Proveedor',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Cantidad',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Precio',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Iva',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Monto Iva',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Subtotal',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Total',
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
                    rows: dataFromAPI?.compras.map((compra) {
                      return DataRow(cells: [
                        DataCell(Text(compra.numeroCompra.toString())),
                        DataCell(Text(compra.producto.toString())),
                        DataCell(Text(compra.proveedor.toString())),
                        DataCell(Text(compra.cantidad.toString())),
                        DataCell(Text(compra.precio.toString())),
                        DataCell(Text(compra.iva.toString())),
                        DataCell(Text(compra.montoIva.toString())),
                        DataCell(Text(compra.subtotal.toString())),
                        DataCell(Text(compra.total.toString())),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ComprasPut(compr: compra),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.edit, color: Colors.blue),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                onPressed: () {
                                  _eliminarProveedor(compra.id);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Menu(),
                                    ),
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
              builder: (context) => const CreateComp(),
            ),
          );
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
    );
  }
}
