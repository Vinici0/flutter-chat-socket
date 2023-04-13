import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_socket/services/auth_service.dart';
import 'package:flutter_chat_socket/services/chat_service.dart';
import 'package:flutter_chat_socket/services/socket_service.dart';
import 'package:flutter_chat_socket/witget/chat_message.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  static final String chatroute = 'chat';
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  ChatService chatService = ChatService();
  SocketService socketService = SocketService();
  AuthService authService = AuthService();

  List<ChatMessage> _messages = [];

  bool _estaEscribiendo = false;

  @override
  void initState() {
    super.initState();
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);

    socketService.socket.on('mensaje-personal', _escucharMensaje);
  }

  void _escucharMensaje(dynamic payload) {
    ChatMessage message = ChatMessage(
      texto: payload['mensaje'],
      uid: payload['de'],
      animationController: AnimationController(
          vsync: this, duration: const Duration(milliseconds: 300)),
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
          children: [
            CircleAvatar(
              child: Text(chatService.usuarioPara.nombre.substring(0, 2),
                  style: TextStyle(fontSize: 12)),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            SizedBox(height: 3),
            Text(
              chatService.usuarioPara.nombre,
              style: TextStyle(color: Colors.black87, fontSize: 12),
            )
          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              //Flexible es para que el ListView se adapte al espacio que le queda
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (_, i) => _messages[i],
                itemCount: _messages.length,
                reverse: true,
              ),
            ),
            Divider(height: 1),
            _inputChat()
          ],
        ),
      ),
    );
  }

  SafeArea _inputChat() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        color: Colors.white,
        height: 50,
        child: Row(
          children: [
            Flexible(
              child: TextField(
                  decoration: const InputDecoration.collapsed(
                      hintText: "Enviar mensaje"),
                  focusNode: _focusNode,
                  controller: _textController,
                  onSubmitted: _handleSubmit,
                  onChanged: (String texto) {
                    setState(() {
                      if (texto.trim().length > 0) {
                        _estaEscribiendo = true;
                      } else {
                        _estaEscribiendo = false;
                      }
                    });
                  }),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Platform.isIOS
                  ? CupertinoButton(
                      child: const Text("Enviar"),
                      onPressed: () {},
                    )
                  : IconTheme(
                      data: IconThemeData(color: Colors.blue[400]),
                      child: IconButton(
                        icon: Icon(Icons.send),
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onPressed: _estaEscribiendo
                            ? () => _handleSubmit(_textController.text.trim())
                            : null,
                      ),
                    ),
            )
            //Boton de enviar
          ],
        ),
      ),
    );
  }

  _handleSubmit(String texto) {
    if (texto.length == 0) return;
    _textController.clear();
    _focusNode.requestFocus();
    //Para que el cursor se quede en el TextField y no en el boton
    final newMessage = ChatMessage(
        uid: authService.usuario!.uid,
        texto: texto,
        animationController: AnimationController(
            vsync: this, duration: const Duration(milliseconds: 200)));
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();
    setState(() {
      _estaEscribiendo = false;
      //Enviamos el mensaje al servidor
      print(authService.usuario?.uid);
      this.socketService.socket.emit('mensaje-personal', {
        'de': authService.usuario?.uid,
        'para': chatService.usuarioPara.uid,
        'mensaje': texto
      });
    });
  }

  @override
  void dispose() {
    //Importante el socket en off y el dispose de los controllers para que no se queden en memoria y no se acumulen los mensajes
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    //TODO: off del socket - sirve para que no se queden escuchando los mensajes
    this.socketService.socket.off('mensaje-personal');
    super.dispose();
  }
}
