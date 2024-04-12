import 'package:astroguide_flutter/pages/menu.dart';

import 'package:flutter/material.dart';
import 'package:astroguide_flutter/services/user_service.dart';
import 'package:get_storage/get_storage.dart';

class EditarPerfil extends StatefulWidget {
  const EditarPerfil({super.key});

  @override
  EditarPerfilState createState() => EditarPerfilState();
}

class EditarPerfilState extends State<EditarPerfil> {
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;

  late String _nombreActual;
  late String _usernameActual;
  late String _emailActual;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();

    obtenerDatosActuales();
  }

  void _actualizarUsuario() async {
    var storage = GetStorage();
    var token = storage.read('token');
    await UserService.actualizarUsuario(token, {
      "name": _nameController.text.trim(),
      "username": _usernameController.text.trim(),
      "email": _emailController.text.trim(),
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Menu()),
    );
  }

  Future<void> obtenerDatosActuales() async {
    var storage = GetStorage();
    var token = storage.read('token');
    final userData = await UserService.obtenerUsuarios(token);

    setState(() {
      _nombreActual = userData.name;
      _usernameActual = userData.username;
      _emailActual = userData.email;

      _nameController.text = _nombreActual;
      _usernameController.text = _usernameActual;
      _emailController.text = _emailActual;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildTextField("Nombre", _nameController),
            _buildTextField("Nombre de usuario", _usernameController),
            _buildTextField("Correo electrónico", _emailController),
            const SizedBox(height: 20.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: const Color.fromARGB(255, 2, 40, 255),
              ),
              onPressed: _actualizarUsuario,
              child: const Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(color: Color.fromARGB(255, 22, 22, 22))),
        TextField(
          controller: controller,
          style: const TextStyle(color: Color.fromARGB(255, 145, 145, 145)),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
