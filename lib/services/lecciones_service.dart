import 'dart:convert';
import 'package:http/http.dart' as http;

class LeccionesService {
  static Future<List<dynamic>> obtenerLecciones(String token) async {
    final url = 'http://astroguide.api.adsocidm.com/api/lecciones';
    var headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    }; // Reemplaza con tu propia URL de la API Laravel

    try {
      final response = await http.get(
          Uri.parse(
            url,
          ),
          headers: headers);
      if (response.statusCode == 200) {
        // La solicitud fue exitosa, decodifica los datos
        final List<dynamic> leccionesData = json.decode(response.body);
        return leccionesData;
      } else {
        // La solicitud falló, maneja el error de otra manera
        throw Exception('Error al obtener lecciones: ${response.statusCode}');
      }
    } catch (e) {
      // Error de conexión u otro error
      throw Exception('Error: $e');
    }
  }

  static Future<String> desbloquearQuiz(String token, int id) async {
    final url = 'http://astroguide.api.adsocidm.com/api/desbloquearquiz/$id';
    var headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    }; // Reemplaza con tu propia URL de la API Laravel
    try {
      final response = await http.get(
          Uri.parse(
            url,
          ),
          headers: headers);
      print(response.body);
      if (response.statusCode == 200) {
        // La solicitud fue exitosa, decodifica los datos
        final data = response.body;
        return data;
      } else {
        // La solicitud falló, maneja el error de otra manera
        throw Exception('Error al obtener lecciones: ${response.statusCode}');
      }
    } catch (e) {
      // Error de conexión u otro error
      throw Exception('Error: $e');
    }
  }

  static desbloquearleccion(token, int id) {}
}
