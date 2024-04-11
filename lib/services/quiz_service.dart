import 'dart:convert';
import 'package:http/http.dart' as http;

class QuizService {
  static Future<List<dynamic>> getQuiz(String token) async {
    final url = 'https://astroguide.api.adsocidm.com/api/quiz';
    var headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    }; // URL del endpoint del backend

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        // Si la solicitud fue exitosa, devuelve los datos decodificados
        final res = response.body;
        print(res);
        return json.decode(response.body);
      } else {
        // Si la solicitud falló, maneja el error
        throw Exception('Error al obtener quizs: ${response.statusCode}');
      }
    } catch (e) {
      // Error de conexión u otro error
      throw Exception('Error: $e');
    }
  }

  static Future<bool> saveQuiz(String token, Map<String, dynamic> data) async {
    const url =
        'https://astroguide.api.adsocidm.com/api/quiz/validarTerminacion';
    var headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };
    print(data);
    try {
      final response = await http.post(Uri.parse(url),
          body: jsonEncode(data), headers: headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        // Si la solicitud fue exitosa, devuelve los datos decodificados
        return data["message"];
      } else {
        // Si la solicitud falló, maneja el error
        throw Exception('Error al obtener quizs: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
