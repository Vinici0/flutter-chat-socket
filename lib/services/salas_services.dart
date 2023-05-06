import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_socket/global/environment.dart';
import 'package:flutter_chat_socket/models/sales_response.dart';
import 'package:flutter_chat_socket/services/auth_service.dart';
import 'package:http/http.dart' as http;

class SalasServices with ChangeNotifier {
  late Sala salaSeleccionada;

  Future<List<Sala>> getSalesAll() async {
    final uri = Uri.parse('${Environment.apiUrl}/salas/obtener-salas-usuario');
    final resp = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      'x-token': await AuthService.getToken() as String,
    });
    final salesResp = SalesResponse.fromJson(resp.body);
    // this.setSalas = salesResp.salas;
    return salesResp.salas;
  }
}
