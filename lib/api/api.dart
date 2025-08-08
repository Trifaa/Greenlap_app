import 'dart:convert';
import 'package:greenlab_app/model/model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<TeamData?> fetchTeamMovements(String scannedCode) async {
  final url = Uri.parse('$baseUrl/team-get-movements/$scannedCode');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final jsonMap = jsonDecode(response.body);

    if (jsonMap['data'] != null) {
      return TeamData.fromJson(jsonMap['data']);
    } else {
      print('⚠️ No se encontró clave "data" en la respuesta');
      return null;
    }
  } else {
    throw Exception('Error al obtener movimientos: ${response.statusCode}');
  }
}

  Future<void> sendTeamId(String teamId) async {
    final url = Uri.parse('$baseUrl/team-received/$teamId');

    try {
      final response = await http.get(url); // O .post si es POST

      if (response.statusCode == 200) {
        print("✅ Team ID enviado correctamente");
        // puedes hacer algo con response.body si quieres
      } else {
        print("❌ Error al enviar el team ID: ${response.statusCode}");
      }
    } catch (e) {
      print("❗ Error en la solicitud: $e");
    }
  }
}