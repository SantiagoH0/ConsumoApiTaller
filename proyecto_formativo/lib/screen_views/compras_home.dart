// ignore_for_file: unused_field, prefer_const_constructors
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto_formativo/screen_views/home.dart';
import 'compras_create.dart';
import 'compras_edit.dart';
import 'compras_model.dart';

class HomeCompras extends StatefulWidget {
  const HomeCompras({Key? key}) : super(key: key);

  @override
  State<HomeCompras> createState() => _HomeComprasState();
}

class _HomeComprasState extends State<HomeCompras> {
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  List<ComprasVali> filteredCompras = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  _getData() async {
    try {
      String url =
          "https://proyecto-formativo-2559218-backend.onrender.com/api/compra";
      http.Response res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);
        setState(() {
          dataFromAPI = DataModel.fromJson(jsonData);
          filteredCompras = dataFromAPI!.compras;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  DataModel? dataFromAPI;

  void _eliminarCompra(String id) async {
    try {
      final response = await http.delete(
        Uri.parse(
            'https://proyecto-formativo-2559218-backend.onrender.com/api/compra/'),
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
        title: const Text('Lista de Compras'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Centra verticalmente
              children: [
                SingleChildScrollView(
                  child: DataTable(
                    headingTextStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    columns: const [
                      DataColumn(label: Text('Número de Compra')),
                      DataColumn(label: Text('Producto')),
                      DataColumn(label: Text('Proveedor')),
                      DataColumn(label: Text('Cantidad')),
                      DataColumn(label: Text('Precio')),
                      DataColumn(label: Text('IVA')),
                      DataColumn(label: Text('Monto de IVA')),
                      DataColumn(label: Text('Subtotal')),
                      DataColumn(label: Text('Total')),
                      DataColumn(label: Text('Acciones')),
                    ],
                    rows: filteredCompras.map((compras) {
                      return DataRow(cells: [
                        DataCell(Text(compras.numeroCompra.toString())),
                        DataCell(Text(compras.producto)),
                        DataCell(Text(compras.proveedor)),
                        DataCell(Text(compras.cantidad.toString())),
                        DataCell(Text(compras.precio.toString())),
                        DataCell(Text(compras.iva.toString())),
                        DataCell(Text(compras.montoIva.toString())),
                        DataCell(Text(compras.subtotal.toString())),
                        DataCell(Text(compras.total.toString())),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ComprasPut(compr: compras),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.edit, color: Colors.blue),
                              ),
                              SizedBox(width: 8),
                              IconButton(
                                onPressed: () async {
                                  _eliminarCompra(compras.id);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Menu(),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.delete, color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ]);
                    }).toList(),
                  ),
                ),
                FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CreateComp(),
                      ),
                    );
                  },
                  child: Icon(Icons.add),
                  backgroundColor: Colors.orange,
                ),
              ],
            ),
    );
  }
}

class _SearchDelegate extends SearchDelegate<String> {
  final List<ComprasVali> comprasList;

  _SearchDelegate(this.comprasList);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = comprasList
        .where((compra) =>
            compra.producto.toLowerCase().contains(query.toLowerCase()) ||
            compra.proveedor.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final compra = results[index];
        return ListTile(
          title: Text(compra.producto),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = comprasList
        .where((compra) =>
            compra.producto.toLowerCase().contains(query.toLowerCase()) ||
            compra.proveedor.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final compra = suggestions[index];
        return ListTile(
          title: Text(compra.producto),
          onTap: () {
            close(context, compra.producto);
          },
        );
      },
    );
  }
}
