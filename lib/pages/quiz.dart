import 'package:astroguide_flutter/pages/menu.dart';
import 'package:flutter/material.dart';
import 'package:astroguide_flutter/services/quiz_service.dart';
import 'package:get_storage/get_storage.dart';

class QuizListPage extends StatefulWidget {
  @override
  _QuizListPageState createState() => _QuizListPageState();
}

class _QuizListPageState extends State<QuizListPage> {
  List<dynamic> quizzes = [];
  List<dynamic> respuestaP1 = [];
  List<dynamic> respuestaP2 = [];
  List<dynamic> respuestaP3 = [];

  @override
  void initState() {
    super.initState();
    var storage = GetStorage();
    var token = storage.read('token');
    obtenerQuizzes(token);
  }

  Future<void> obtenerQuizzes(String token) async {
    try {
      final List<dynamic> listaQuizzes = await QuizService.getQuiz(token);
      setState(() {
        quizzes = listaQuizzes;
      });
    } catch (e) {
      // Manejar errores
      print('Error al obtener quizzes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quizzes'),
      ),
      body: ListView.builder(
        itemCount: quizzes.length,
        itemBuilder: (context, index) {
          final quiz = quizzes[index];
          final bool bloqueada = quiz["bloqueada"] == 0 ? false : true;
          print(bloqueada);
          return GestureDetector(
            onTap: () {
              if (bloqueada) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      '¡El quiz está bloqueado! Debes completar la lección correspondiente.'),
                ));
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizDetailPage(quiz: quiz),
                  ),
                );
              }
            },
            child: Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: !bloqueada ? Colors.white : Colors.grey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 5),
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quiz['Titulo'] ?? '',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    quiz['pregunta'] ?? '',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Menu()));
        },
        child: Icon(Icons.arrow_back),
      ),
    );
  }
}

class QuizDetailPage extends StatefulWidget {
  final dynamic quiz;

  const QuizDetailPage({super.key, required this.quiz});

  @override
  _QuizDetailPageState createState() => _QuizDetailPageState(quiz);
}

class _QuizDetailPageState extends State<QuizDetailPage> {
  String? selectedAnswer1;
  String? selectedAnswer2;
  String? selectedAnswer3;
  int correctAnswersCount = 0;

  late dynamic quiz;

  List<dynamic> respuestaP1 = [];
  List<dynamic> respuestaP2 = [];
  List<dynamic> respuestaP3 = [];

  _QuizDetailPageState(dynamic _quiz) {
    quiz = _quiz;

    respuestaP1 = [
      quiz['RespuestaCorrecta'],
      quiz['Respuesta2'],
      quiz['Respuesta3'],
      quiz['Respuesta4'],
    ]..shuffle();

    respuestaP2 = [
      quiz['RespuestaCorrecta2'],
      quiz['Respuesta5'],
      quiz['Respuesta6'],
      quiz['Respuesta7'],
    ]..shuffle();

    respuestaP3 = [
      quiz['RespuestaCorrecta3'],
      quiz['Respuesta8'],
      quiz['Respuesta9'],
      quiz['Respuesta10'],
    ]..shuffle();
  }

  void enviarRespuesta() async {
    // Verificar si todas las preguntas han sido respondidas
    print("object");
    if (selectedAnswer1 != null &&
        selectedAnswer2 != null &&
        selectedAnswer3 != null) {
      GetStorage storage = GetStorage();
      final token = storage.read("token");
      Map<String, dynamic> data = {
        "quiz_id": widget.quiz["id"],
        "respuestas_clientes": [
          selectedAnswer1,
          selectedAnswer2,
          selectedAnswer3
        ]
      };
      final resposnse = await QuizService.saveQuiz(token, data);
      // Verificar si todas las respuestas son correctas
      if (resposnse) {
        /*if (selectedAnswer1 == widget.quiz['RespuestaCorrecta'] &&
            selectedAnswer2 == widget.quiz['RespuestaCorrecta2'] &&
            selectedAnswer3 == widget.quiz['RespuestaCorrecta3']) {*/
        // Navegar a la página de aprobación
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => QuizPassedPage()),
        );
      } else {
        // Mostrar un diálogo de respuesta incorrecta
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Respuestas Incorrectas'),
              content: Text('Por favor, intenta nuevamente.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz['titulo'] ?? ''),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.quiz['Pregunta'] ?? '',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var answer in respuestaP1)
                    RadioListTile<String>(
                      title: Text(answer ?? ''),
                      value: answer,
                      groupValue: selectedAnswer1,
                      onChanged: (value) {
                        setState(() {
                          selectedAnswer1 = value;
                        });
                      },
                    ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                widget.quiz['Pregunta2'] ?? '',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var answer in respuestaP2)
                    RadioListTile<String>(
                      title: Text(answer ?? ''),
                      value: answer,
                      groupValue: selectedAnswer2,
                      onChanged: (value) {
                        setState(() {
                          selectedAnswer2 = value;
                        });
                      },
                    ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                widget.quiz['Pregunta3'] ?? '',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var answer in respuestaP3)
                    RadioListTile<String>(
                      title: Text(answer ?? ''),
                      value: answer,
                      groupValue: selectedAnswer3,
                      onChanged: (value) {
                        setState(() {
                          selectedAnswer3 = value;
                        });
                      },
                    ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: enviarRespuesta,
                child: Text('Enviar respuestas'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuizPassedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('¡Felicidades!'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100,
            ),
            SizedBox(height: 20),
            Text(
              '¡Has pasado el quiz!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => QuizListPage()));
              },
              child: Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }
}
