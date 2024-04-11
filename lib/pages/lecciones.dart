import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:astroguide_flutter/services/lecciones_service.dart';
import 'package:get_storage/get_storage.dart';
// Importa la primera página para la navegación

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const Lecciones());
}

class Lecciones extends StatelessWidget {
  const Lecciones({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lecciones'),
      ),
      body: LeccionesList(),
    );
  }
}

class LeccionesList extends StatefulWidget {
  @override
  _LeccionesListState createState() => _LeccionesListState();
}

class _LeccionesListState extends State<LeccionesList> {
  final ScrollController _scrollController = ScrollController();

  List<dynamic> _leccionesData = [];

  @override
  void initState() {
    super.initState();
    _cargarLecciones();
  }

  Future<void> _cargarLecciones() async {
    try {
      var storage = GetStorage();
      var token = storage.read('token');
      final List<dynamic> leccionesData =
          await LeccionesService.obtenerLecciones(token);
      setState(() {
        _leccionesData = leccionesData;
      });
    } catch (e) {
      print('Error al cargar las lecciones: $e');
    }
  }

  Future<void> _desbloquearLeccion(int id) async {
    try {
      var storage = GetStorage();
      var token = storage.read('token');
      await LeccionesService.desbloquearQuiz(token, id);
      await _cargarLecciones();
    } catch (e) {
      print('Error al cargar las lecciones: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    print(_leccionesData);
    return Scrollbar(
      controller: _scrollController,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _leccionesData.length,
        itemBuilder: (context, index) {
          final bool desbloqueada =
              _leccionesData[index]["desbloqueda"] ?? false;

          return GestureDetector(
            onTap: () {
              if (desbloqueada || index == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LeccionDetalle(
                      leccionData: _leccionesData[index],
                    ),
                  ),
                );
                _desbloquearLeccion(_leccionesData[index]["id"]);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                      '¡La lección está bloqueada! Debes completar las anteriores.'),
                ));
              }
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color:
                    desbloqueada ? Colors.white : Colors.grey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 5),
                    color:
                        const Color.fromARGB(255, 104, 51, 155).withOpacity(.2),
                    spreadRadius: 2,
                    blurRadius: 10,
                  )
                ],
              ),
              child: Text(
                '${_leccionesData[index]['Nombre_de_la_leccion'] ?? ''}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class LeccionDetalle extends StatelessWidget {
  final dynamic leccionData;

  const LeccionDetalle({Key? key, required this.leccionData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(leccionData['nombre'] ?? 'Detalle de la lección'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                  'Nombre de la lección: ${leccionData['Nombre_de_la_leccion'] ?? ''}'),
              SizedBox(height: 10),
              Text('Tipo de lección: ${leccionData['Tipo_de_leccion'] ?? ''}'),
              SizedBox(height: 10),
              Text('Contenido: ${leccionData['Contenido'] ?? ''}'),
            ],
          ),
        ),
      ),
    );
  }
}
