import 'package:flutter/material.dart';
import 'package:flutter_chat_socket/global/environment.dart';
import 'package:flutter_chat_socket/services/auth_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;

  IO.Socket get socket => this
      ._socket; // Para poder usar el socket en cualquier parte de la app sin necesidad de usar el provider
  Function get emit => this
      ._socket
      .emit; // Emitir eventos al servidor sin necesidad de usar el provider

  void connect() async {
    final token = await AuthService.getToken();

    this._socket = IO.io(Environment.socketUrl, {
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true, //Para que use el ultimo token
      'extraHeaders': {
        //Se enviará el token en el header de la petición
        'x-token': token,
      }
    });

    this._socket.on('connect', (_) {
      print('connect');
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    //Para cambiar el icono de la app cuando se desconecte
    this._socket.on('disconnect', (_) {
      print('disconnect');
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
  }

  void disconnect() {
    this._socket.disconnect();
  }
}
