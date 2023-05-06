import 'package:flutter/material.dart';
import 'package:flutter_chat_socket/global/environment.dart';
import 'package:flutter_chat_socket/models/mensajes_response.dart';
import 'package:flutter_chat_socket/models/usuario.dart';
import 'package:flutter_chat_socket/services/auth_service.dart';
import 'package:http/http.dart' as http;

class ChatService with ChangeNotifier {
  late Usuario usuarioPara; // TODO: Importante para el chat privado

  Future<List<Mensaje>> getChat(String usuarioID) async {
    final uri = Uri.parse('${Environment.apiUrl}/mensajes/$usuarioID');
    final resp = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      'x-token': await AuthService.getToken() as String,
    });

    final mensajesResp = mensajesResponseFromJson(resp.body);

    return mensajesResp.mensajes;
  }
}
