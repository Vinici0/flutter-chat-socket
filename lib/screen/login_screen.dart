import 'package:flutter/material.dart';
import 'package:flutter_chat_socket/helpers/mostrar_alerta.dart';
import 'package:flutter_chat_socket/services/auth_service.dart';
import 'package:flutter_chat_socket/witget/boton_login.dart';
import 'package:flutter_chat_socket/witget/custom_input.dart';
import 'package:flutter_chat_socket/witget/labels_login.dart';
import 'package:flutter_chat_socket/witget/logo_login.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  static final String loginroute = 'login';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Container(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                margin: const EdgeInsets.all(30),
                height: MediaQuery.of(context).size.height * 0.9,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Logo(text: "Seguridad Espe"),
                      _From(),
                      Labels(
                          ruta: 'register',
                          text: "¿No tienes cuenta?",
                          text2: "Crea una"),
                      SizedBox(height: 10),
                      Text("Terminos y condiciones de uso",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Color.fromRGBO(0, 0, 0, 0.782)))
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _From extends StatefulWidget {
  const _From({super.key});

  @override
  State<_From> createState() => __FromState();
}

class __FromState extends State<_From> {
  //provider

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Container(
      child: Column(children: [
        CustonInput(
          icon: Icons.mail_outline,
          placeholder: "Email",
          keyboardType: TextInputType.emailAddress,
          textController: emailController,
        ),
        CustonInput(
          icon: Icons.lock_outline,
          placeholder: "Password",
          textController: passwordController,
          isPassword: true,
        ),
        BotonForm(
            text: "Ingresar",
            onPressed: authService.autenticando
                ? () {}
                : () async {
                    FocusScope.of(context).unfocus();
                    final loginOk = await authService.login(
                        emailController.text.trim(),
                        passwordController.text.trim());
                    if (loginOk) {
                      // TODO: Conectar a nuestro socket server
                      Navigator.pushReplacementNamed(context, 'usuarios');
                    } else {
                      // Mostrar alerta
                      mostrarAlerta(context, 'Login incorrecto',
                          'Revise sus credenciales');
                    }
                  }),
      ]),
    );
  }
}
