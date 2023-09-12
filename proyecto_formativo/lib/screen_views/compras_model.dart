import 'dart:convert';

DataModel dataModelFromJson(String str) => DataModel.fromJson(json.decode(str));

String dataModelToJson(DataModel data) => json.encode(data.toJson());

class DataModel {
    DataModel({
        required this.compras,
    });

    List<ComprasVali> compras;
  
    factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
        compras: List<ComprasVali>.from(json["compras"].map((x) => ComprasVali.fromJson(x))),
        
    );

    Map<String, dynamic> toJson() => {
        "compras": List<dynamic>.from(compras.map((x) => x.toJson())),
       
    };
}

class ComprasVali {
    ComprasVali({
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

    String id;
    int numeroCompra;
    String producto;
    String proveedor;
    int cantidad;
    double precio;
    double iva;
    String fecha;
    double montoIva;
    double subtotal;
    double total;
    
    factory ComprasVali.fromJson(Map<String, dynamic> json) => ComprasVali(
        id: json["_id"],
        numeroCompra: json["numeroCompra"] as int,
        producto: json["producto"],
        proveedor: json["proveedor"],
        cantidad: json["cantidad"] as int,
        precio: json["precio"]as double,
        iva: json["iva"],
        fecha: json["fecha"],
        montoIva: json["montoIva"] as double,
        subtotal: json["subtotal"] as double,
        total: json["total"] as double
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "numeroCompra": numeroCompra,
        "producto": producto,
        "proveedor": proveedor,
        "cantidad": cantidad,
        "precio": precio,
        "iva": iva,
        "fecha" : fecha,
        "montoIva" : montoIva,
        "subtotal" : subtotal,
        "total" : total
    };
}