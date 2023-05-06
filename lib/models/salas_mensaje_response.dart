// To parse this JSON data, do
//
//     final salasMensajeResponse = salasMensajeResponseFromMap(jsonString);

import 'dart:convert';

SalasMensajeResponse salasMensajeResponseFromMap(String str) =>
    SalasMensajeResponse.fromMap(json.decode(str));

String salasMensajeResponseToMap(SalasMensajeResponse data) =>
    json.encode(data.toMap());

class SalasMensajeResponse {
  bool ok;
  Sala sala;

  SalasMensajeResponse({
    required this.ok,
    required this.sala,
  });

  factory SalasMensajeResponse.fromMap(Map<String, dynamic> json) =>
      SalasMensajeResponse(
        ok: json["ok"],
        sala: Sala.fromMap(json["sala"]),
      );

  Map<String, dynamic> toMap() => {
        "ok": ok,
        "sala": sala.toMap(),
      };
}

class Sala {
  List<String> usuarios;
  List<Mensaje> mensajes;
  String nombre;
  String codigo;
  String createdAt;
  String updatedAt;
  String uid;

  Sala({
    required this.usuarios,
    required this.mensajes,
    required this.nombre,
    required this.codigo,
    required this.createdAt,
    required this.updatedAt,
    required this.uid,
  });

  factory Sala.fromMap(Map<String, dynamic> json) => Sala(
        usuarios: List<String>.from(json["usuarios"].map((x) => x)),
        mensajes:
            List<Mensaje>.from(json["mensajes"].map((x) => Mensaje.fromMap(x))),
        nombre: json["nombre"],
        codigo: json["codigo"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        uid: json["uid"],
      );

  Map<String, dynamic> toMap() => {
        "usuarios": List<dynamic>.from(usuarios.map((x) => x)),
        "mensajes": List<dynamic>.from(mensajes.map((x) => x.toMap())),
        "nombre": nombre,
        "codigo": codigo,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "uid": uid,
      };
}

class Mensaje {
  String id;
  String mensaje;
  String usuario;
  String createdAt;
  String updatedAt;
  int v;

  Mensaje({
    required this.id,
    required this.mensaje,
    required this.usuario,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Mensaje.fromMap(Map<String, dynamic> json) => Mensaje(
        id: json["_id"],
        mensaje: json["mensaje"],
        usuario: json["usuario"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        v: json["__v"],
      );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "mensaje": mensaje,
        "usuario": usuario,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "__v": v,
      };
}
