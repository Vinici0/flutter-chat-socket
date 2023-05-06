import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_socket/services/auth_service.dart';
import 'package:flutter_chat_socket/services/chat_service.dart';
import 'package:flutter_chat_socket/services/salas_services.dart';
import 'package:flutter_chat_socket/services/socket_service.dart';
import 'package:flutter_chat_socket/witget/chat_message.dart';
import 'package:provider/provider.dart';

class ChatSalesScreen extends StatefulWidget {
  static const String chatsalesroute = 'chatsales';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

//TickerProviderStateMixin - Es para la animacion del boton de enviar
class _ChatScreenState extends State<ChatSalesScreen>
    with TickerProviderStateMixin {
  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();
  List<ChatMessage> _messages = [];
  bool _estaEscribiendo = false;

  /*

    TODO: Cominicacion con el socket - de aqui para hacer la tesis
    TODO: Paso 2 - Ir al _handleSubmit y enviar el mensaje al socket

  */
  SalasServices salaService = SalasServices();
  SocketService socketService = SocketService();
  AuthService authService = AuthService();

  @override
  void initState() {
    //TODO: Jamas ubicar el listen en true
    this.salaService = Provider.of<SalasServices>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);

    socketService.socket.emit('join-room', {
      'codigo': salaService.salaSeleccionada.uid,
    });
    
    socketService.socket.on('mensaje-grupal', _escucharMensaje);

    super.initState();
  }

  void _escucharMensaje(dynamic payload) {
    ChatMessage message = ChatMessage(
      nombre: payload['nombre'],
      texto: payload['mensaje'],
      uid: payload['de'],
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 300)),
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: <Widget>[
            CircleAvatar(
              child: Text(salaService.salaSeleccionada.nombre.substring(0, 2),
                  style: TextStyle(fontSize: 12)),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            SizedBox(height: 3),
            Text(salaService.salaSeleccionada.nombre,
                style: TextStyle(color: Colors.black87, fontSize: 12))
          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
                child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: _messages.length,
              itemBuilder: (_, i) => _messages[i],
              reverse: true,
            )),

            Divider(height: 1),

            // TODO: Caja de texto
            Container(
              color: Colors.white,
              child: _inputChat(),
            )
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
        child: Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Flexible(
              child: TextField(
            controller: _textController,
            onSubmitted: _handleSubmit,
            onChanged: (texto) {
              setState(() {
                if (texto.trim().length > 0) {
                  _estaEscribiendo = true;
                } else {
                  _estaEscribiendo = false;
                }
              });
            },
            decoration: InputDecoration.collapsed(hintText: 'Enviar mensaje'),
            focusNode: _focusNode,
          )),

          // Botón de enviar
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            child: Platform.isIOS
                ? CupertinoButton(
                    child: Text('Enviar'),
                    onPressed: _estaEscribiendo
                        ? () => _handleSubmit(_textController.text.trim())
                        : null,
                  )
                : Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    child: IconTheme(
                      data: IconThemeData(color: Colors.blue[400]),
                      child: IconButton(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        icon: Icon(Icons.send),
                        onPressed: _estaEscribiendo
                            ? () => _handleSubmit(_textController.text.trim())
                            : null,
                      ),
                    ),
                  ),
          )
        ],
      ),
    ));
  }

  _handleSubmit(String texto) {
    if (texto.length == 0) return;

    print(texto);
    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessage(
      uid: authService.usuario!.uid,
      texto: texto,
      nombre: authService.usuario!.nombre,
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 200)),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      _estaEscribiendo = false;
    });

    this.socketService.socket.emit('mensaje-grupal', {
      'de': this.authService.usuario?.uid,
      //TODO: Paso 3 - Enviar el mensaje al socket con el uid de la sala seleccionada para que el socket lo envie a todos los usuarios de la sala
      'para': this.salaService.salaSeleccionada.uid,
      'nombre': this.authService.usuario?.nombre,
      'mensaje': texto
    });
  }

  @override
  void dispose() {
    //TODO: Off del socket

    for (ChatMessage message in _messages) {
      //Para evitar fugas de memoria en la animacion del boton de enviar mensaje
      //Una vwz que se cierra se limpia la animacion del boton de enviar mensaje para evitar fugas de memoria
      message.animationController.dispose();
    }

    super.dispose();
  }
}
