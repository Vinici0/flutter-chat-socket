import 'package:flutter/material.dart';
import 'package:flutter_chat_socket/models/sales_response.dart';
import 'package:flutter_chat_socket/models/usuario.dart';
import 'package:flutter_chat_socket/screen/login_screen.dart';
import 'package:flutter_chat_socket/screen/sales.screen.dart';
import 'package:flutter_chat_socket/services/auth_service.dart';
import 'package:flutter_chat_socket/services/chat_service.dart';
import 'package:flutter_chat_socket/services/salas_services.dart';
import 'package:flutter_chat_socket/services/socket_service.dart';
import 'package:flutter_chat_socket/services/usuarios_service.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsuariosScreen extends StatefulWidget {
  static final String usuariosroute = 'usuarios';

  const UsuariosScreen({Key? key}) : super(key: key);

  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final usuuarioService = new UsuariosService();
  final salaService = new SalasServices();

  List<Usuario> usuarios = [];
  List<Sala> salas = [];

  @override
  void initState() {
    this._cargarUsuarios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(authService.usuario!.nombre,
            style: TextStyle(color: Colors.black87)),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.exit_to_app, color: Colors.black87),
          onPressed: () {
            socketService.disconnect();
            authService.logout();
            Navigator.pushReplacementNamed(context, LoginScreen.loginroute);
          },
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: (socketService.serverStatus == ServerStatus.Online)
                ? const Icon(Icons.check_circle, color: Colors.blue)
                : const Icon(Icons.offline_bolt, color: Colors.red),
          )
        ],
      ),
      body: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          onRefresh: _cargarUsuarios,
          header: WaterDropHeader(),
          child: _listViewUsuarios()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, SalesScreen.salesroute);
        },
        // backgroundColor: Colors.green,
        child: const Icon(Icons.group_add),
      ),
    );
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (_, i) => _usuarioListTitle(usuarios[i]),
      separatorBuilder: (_, i) => const Divider(),
      itemCount: usuarios.length,
    );
  }

  ListTile _usuarioListTitle(Usuario usuario) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(usuario.nombre.substring(0, 2)),
        backgroundColor: Colors.blue[100],
      ),
      title: Text(usuario.nombre),
      subtitle: Text(usuario.email),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: usuario.online ? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(100)),
      ),
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.usuarioPara = usuario;
        Navigator.pushNamed(context, 'chat');
      },
    );
  }

  _cargarUsuarios() async {
    usuarios = await usuuarioService.getUsuarios();
    setState(() {});
    _refreshController.refreshCompleted();
  }
}
