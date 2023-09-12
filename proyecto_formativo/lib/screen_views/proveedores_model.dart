import 'dart:convert';


DataModel dataModelFromJson(String str) => DataModel.fromJson(json.decode(str));

String dataModelToJson(DataModel data) => json.encode(data.toJson());

class DataModel {
    DataModel({
        required this.proveedors,
    });

    List<ProveedoresVali> proveedors;
  
    factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
        proveedors: List<ProveedoresVali>.from(json["proveedores"].map((x) => ProveedoresVali.fromJson(x))),
        
    );

    Map<String, dynamic> toJson() => {
        "proveedores": List<dynamic>.from(proveedors.map((x) => x.toJson())),
       
    };
}

class ProveedoresVali {
    ProveedoresVali({
        required this.id,
        required this.nombre,
        required this.nit,
        required this.email,
        required this.telefono,
        required this.categoria,
        required this.estado,
        
    });

    String id;
    String nombre;
    int nit;
    String email;
    int telefono;
    String categoria;
    bool estado;
    
    factory ProveedoresVali.fromJson(Map<String, dynamic> json) => ProveedoresVali(
        id: json["_id"],
        nombre: json["nombreProveedor"],
        nit: json["nit"],
        email: json["emailProv"],
        telefono: json["telefonoProv"],
        categoria: json["categoriaProv"],
        estado: json["estadoProv"],
        
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "nombreProveedor": nombre,
        "nit": nit,
        "emailProv": email,
        "telefonoProv": telefono,
        "categoriaProv": categoria,
        "estadoProv": estado,
        
    };
}