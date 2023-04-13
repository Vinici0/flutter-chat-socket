import 'package:flutter_chat_socket/screen/login_screen.dart';
import 'package:flutter_chat_socket/screen/usuarios_screen.dart';
import 'package:flutter_chat_socket/services/auth_service.dart';
import 'package:flutter_chat_socket/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatelessWidget {
  static const String loadingroute = 'loading';
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot) {
          return const Center(
            child: Text('Espere...'),
          );
        },
      ),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context, listen: false);

    final autenticado = await authService.isLoggedIn();

    if (autenticado) {
      // TODO: conectar al socket server
      // Navigator.pushReplacementNamed(context, 'usuarios');
      // ignore: use_build_context_synchronously
      socketService.connect();
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              pageBuilder: (_, __, ___) => UsuariosScreen(),
              transitionDuration: Duration(milliseconds: 0)));
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              pageBuilder: (_, __, ___) => LoginScreen(),
              transitionDuration: Duration(milliseconds: 0)));
    }
  }
}
