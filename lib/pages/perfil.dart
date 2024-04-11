import 'package:flutter/material.dart';
import 'package:astroguide_flutter/services/user_service.dart';
import 'package:get_storage/get_storage.dart';
import 'editar_perfil.dart'; // Importa la pantalla de edición de perfil

class UserData {
  final String name;
  final String username;
  final String email;

  UserData({
    required this.name,
    required this.username,
    required this.email,
  });
}

class ProfileScreen extends StatefulWidget {
  final String userId;

  ProfileScreen({required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    var storage = GetStorage();
    var token = storage.read('token');
    final Future<UserData> userData = UserService.obtenerUsuarios(token);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: FutureBuilder<UserData>(
        future: userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final usuario = snapshot.data;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Nombre: ${usuario!.name}',
                    style: const TextStyle(fontSize: 20.0),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    'Usuario: ${usuario.username}',
                    style: const TextStyle(fontSize: 20.0),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    'Email: ${usuario.email}',
                    style: const TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: const Color.fromARGB(255, 2, 40, 255),
                      ),
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditarPerfil()),
                        );
                      },
                      child: const Text(
                        'Editar Perfil',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
