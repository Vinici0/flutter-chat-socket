import 'package:flutter/material.dart';
import 'package:flutter_chat_socket/screen/chat_screen.dart';
import 'package:flutter_chat_socket/screen/loading_screen.dart';
import 'package:flutter_chat_socket/screen/login_screen.dart';
import 'package:flutter_chat_socket/screen/register_screen.dart';
import 'package:flutter_chat_socket/screen/usuarios_screen.dart';
import 'package:flutter_chat_socket/services/auth_service.dart';
import 'package:flutter_chat_socket/services/chat_service.dart';
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
        ChangeNotifierProvider(create: (_) => SocketService()),
        ChangeNotifierProvider(create: (_) => ChatService()),
      ],
      child: MaterialApp(
        title: 'Material App',
        initialRoute: LoadingScreen.loadingroute,
        debugShowCheckedModeBanner: false,
        routes: {
          ChatScreen.chatroute: (context) => const ChatScreen(),
          LoadingScreen.loadingroute: (context) => const LoadingScreen(),
          LoginScreen.loginroute: (context) => const LoginScreen(),
          RegisterScreen.registerroute: (context) => const RegisterScreen(),
          UsuariosScreen.usuariosroute: (context) => const UsuariosScreen(),
        },
      ),
    );
  }
}
