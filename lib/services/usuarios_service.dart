import 'package:flutter_chat_socket/global/environment.dart';
import 'package:flutter_chat_socket/models/usuario.dart';
import 'package:flutter_chat_socket/models/usuarios_response.dart';
import 'package:flutter_chat_socket/services/auth_service.dart';
import 'package:http/http.dart' as http;

class UsuariosService {
  Future<List<Usuario>> getUsuarios() async {
    final token = await AuthService.getToken();

    try {
      final uri = Uri.parse('${Environment.apiUrl}/usuarios');
      final resp = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'x-token': token!,
      });

      final usuariosResponse = usuariosResponseFromJson(resp.body);

      return usuariosResponse.usuarios;
    } catch (e) {
      return [];
    }
  }
}
