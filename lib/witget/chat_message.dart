import 'package:flutter/material.dart';
import 'package:flutter_chat_socket/services/auth_service.dart';
import 'package:provider/provider.dart';

class ChatMessage extends StatelessWidget {
  final String texto;
  final String uid;
  final String nombre;

  final AnimationController animationController;

  const ChatMessage(
      {Key? key,
      required this.texto,
      required this.uid,
      required this.nombre,
      required this.animationController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor:
            CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        child: Container(
          child: this.uid == authService.usuario!.uid
              ? _myMessage()
              : _notMyMessage(),
        ),
      ),
    );
  }

  Widget _myMessage() {
    return Align(
        //Para alinear el mensaje al lado derecho
        alignment: Alignment.centerRight,
        child: Container(
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.only(right: 5, bottom: 5, left: 50
              //muy important el left para que no se sobreponga con el otro mensaje
              ),
          child: Text(
            this.texto,
            style: TextStyle(color: Colors.white),
          ),
          decoration: BoxDecoration(
              color: Color(0xff4D9EF6),
              borderRadius: BorderRadius.circular(20)),
        ));
  }

  Widget _notMyMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              this.nombre,
              style: TextStyle(color: Colors.black87, fontSize: 10),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            margin: EdgeInsets.only(left: 5, bottom: 5, right: 50),
            child: Text(
              this.texto,
              style: TextStyle(color: Colors.black87),
            ),
            decoration: BoxDecoration(
                color: Color(0xffE4E5E8),
                borderRadius: BorderRadius.circular(20)),
          )
        ],
      ),
    );
  }
}
