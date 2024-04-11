import 'package:astroguide_flutter/main.dart';
import 'package:astroguide_flutter/pages/logros.dart';
import 'package:astroguide_flutter/pages/post.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:astroguide_flutter/pages/lecciones.dart'; // Importa la página de lecciones
import "package:astroguide_flutter/pages/perfil.dart"; // Importa la página de perfil
import 'package:astroguide_flutter/pages/quiz.dart'; // Importa la página de quizzes
import 'package:astroguide_flutter/controllers/authentication.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(0, 255, 255, 255)));
  runApp(const Menu());
}

class Menu extends StatelessWidget {
  const Menu({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AuthenticationController _authController = AuthenticationController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 50),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                  title: Row(
                    children: [
                      Text(
                        'Hola!',
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            ?.copyWith(color: Colors.white),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.exit_to_app),
                        onPressed: () {
                          _authController.logout();
                        },
                      ),
                    ],
                  ),
                  subtitle: Text('Bienvenido',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          ?.copyWith(color: Colors.white54)),
                ),
                const SizedBox(height: 30)
              ],
            ),
          ),
          Container(
            color: Theme.of(context).primaryColor,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(200))),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 40,
                mainAxisSpacing: 30,
                children: [
                  itemDashboardWithButton('Logros Obtenidos',
                      CupertinoIcons.star, Colors.deepOrange),
                  itemDashboardWithButton(
                      'Perfil',
                      CupertinoIcons.profile_circled,
                      Color.fromARGB(255, 18, 140, 156)),
                  itemDashboardWithButton(
                      'Lecciones', CupertinoIcons.book, Colors.purple),
                  itemDashboardWithButton('Quiz', Icons.quiz, Colors.blue),
                  itemDashboardWithButton('Foro', CupertinoIcons.star,
                      Color.fromARGB(255, 243, 239, 9)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20)
        ],
      ),
    );
  }

  // Resto del código...

  Widget itemDashboardWithButton(
          String title, IconData iconData, Color background) =>
      GestureDetector(
        onTap: () {
          if (title == 'Perfil') {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                        userId: '',
                      )),
            );
          } else if (title == 'Logros Obtenidos') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LogrosPage()),
            );
          } else if (title == 'Foro') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PostPage()),
            );
          } else if (title == 'Quiz') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QuizListPage()),
            );
          } else if (title == 'Lecciones') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Lecciones()),
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    offset: const Offset(0, 5),
                    color: Theme.of(context).primaryColor.withOpacity(.2),
                    spreadRadius: 2,
                    blurRadius: 5)
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: background,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(iconData, color: Colors.white)),
              const SizedBox(height: 8),
              Text(title.toUpperCase(),
                  style: Theme.of(context).textTheme.subtitle1),
              const SizedBox(height: 8),
            ],
          ),
        ),
      );
}
