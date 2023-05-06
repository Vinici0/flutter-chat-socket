import 'package:flutter/material.dart';
import 'package:flutter_chat_socket/screen/chat_screen.dart';
import 'package:flutter_chat_socket/screen/chatsales_screen.dart';
import 'package:flutter_chat_socket/screen/codigo_sreen.dart';
import 'package:flutter_chat_socket/screen/loading_screen.dart';
import 'package:flutter_chat_socket/screen/login_screen.dart';
import 'package:flutter_chat_socket/screen/register_screen.dart';
import 'package:flutter_chat_socket/screen/sales.screen.dart';
import 'package:flutter_chat_socket/screen/usuarios_screen.dart';
import 'package:flutter_chat_socket/services/auth_service.dart';
import 'package:flutter_chat_socket/services/chat_service.dart';
import 'package:flutter_chat_socket/services/salas_services.dart';
import 'package:flutter_chat_socket/services/socket_service.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ChatService()),
        ChangeNotifierProvider(create: (_) => SalasServices()),
        ChangeNotifierProvider(create: (_) => SocketService()),
        // ChangeNotifierProvider(create: (_) => ChatSalaService()),
      ],
      child: MaterialApp(
        title: 'Material App',
        initialRoute: LoadingScreen.loadingroute,
        debugShowCheckedModeBanner: false,
        routes: {
          ChatSalesScreen.chatsalesroute: (context) => ChatSalesScreen(),
          ChatScreen.chatroute: (context) => const ChatScreen(),
          CodigoGrupoScreen.codigoGruporoute: (context) =>
              const CodigoGrupoScreen(),
          LoadingScreen.loadingroute: (context) => const LoadingScreen(),
          LoginScreen.loginroute: (context) => const LoginScreen(),
          RegisterScreen.registerroute: (context) => const RegisterScreen(),
          SalesScreen.salesroute: (context) => const SalesScreen(),
          UsuariosScreen.usuariosroute: (context) => const UsuariosScreen(),
        },
      ),
    );
  }
}
