import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_chat_socket/global/environment.dart';

// class ChatSalaService with ChangeNotifier {

//   Future<List<Mensaje>> getChatSala(String salaID) async {
//     final uri = Uri.parse('${Environment.apiUrl}/mensajes/sala/$salaID');
//     final resp = await http.get(uri, headers: {
//       'Content-Type': 'application/json',
//       'x-token': await AuthService.getToken() as String,
//     });

//     final mensajesResp = mensajesResponseFromJson(resp.body);

//     return mensajesResp.mensajes;
//   }
// }
