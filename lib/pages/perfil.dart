import 'package:astroguide_flutter/services/logros_service.dart';
import 'package:flutter/material.dart';

import 'package:astroguide_flutter/utils/app_assets.dart';
import 'package:astroguide_flutter/utils/screen_size.dart';
import 'package:astroguide_flutter/services/user_service.dart';
import 'package:astroguide_flutter/controllers/authentication.dart';
import 'package:astroguide_flutter/pages/widgets/profile_image.dart';
import 'editar_perfil.dart'; // Importa la pantalla de edición de perfil

import 'package:get_storage/get_storage.dart';

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

  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthenticationController _authController = AuthenticationController();
  var storage = GetStorage();
  String token = '';
  late Future<UserData> userData;
  List logros = [];
  bool isLoaded = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (isLoaded) return;
    isLoaded = true;
    token = storage.read('token');
    userData = UserService.obtenerUsuarios(token);
    logros = await LogrosService.getLogros(token);
  }

  @override
  Widget build(BuildContext context) {
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
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: ScreenSize.absoluteHeight * 0.02,
                ),
                ProfileImage(
                  avatars: AppAssets.avatarList,
                ),
                Text(
                  usuario!.email,
                  style: const TextStyle(fontSize: 20.0),
                ),
                SizedBox(
                  height: ScreenSize.absoluteHeight * 0.05,
                ),
                Text(
                  'Nombre: ${usuario.name}',
                  style: const TextStyle(fontSize: 20.0),
                ),
                const SizedBox(height: 10.0),
                Text(
                  'Usuario: ${usuario.username}',
                  style: const TextStyle(fontSize: 20.0),
                ),
                logros.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: ScreenSize.absoluteHeight * 0.35,
                          child: SingleChildScrollView(
                            child: Wrap(
                              children: List.generate(
                                logros.length,
                                (index) => Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Chip(
                                    avatar: const Icon(Icons.star),
                                    backgroundColor:
                                        Colors.amber.withOpacity(0.8),
                                    label: Text(
                                      logros[index]['Nombre_del_Logro'],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Text('Aun no hay logros....'),
                Column(
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            const MaterialStatePropertyAll(Colors.deepPurple),
                        padding: MaterialStatePropertyAll(
                          EdgeInsets.symmetric(
                            horizontal: ScreenSize.width * 0.215,
                            vertical: ScreenSize.absoluteHeight * 0.015,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EditarPerfil()),
                        );
                      },
                      child: Text(
                        'Editar Perfil',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenSize.width * 0.037,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        padding: MaterialStatePropertyAll(
                          EdgeInsets.symmetric(
                            horizontal: ScreenSize.width * 0.2,
                            vertical: ScreenSize.absoluteHeight * 0.015,
                          ),
                        ),
                        backgroundColor:
                            const MaterialStatePropertyAll(Colors.deepPurple),
                      ),
                      onPressed: () {
                        _authController.logout();
                      },
                      child: Text(
                        'Cerrar Sesion',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenSize.width * 0.037,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
