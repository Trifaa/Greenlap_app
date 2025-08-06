import 'dart:convert';
import 'package:greenlab_app/model/model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<List<TeamMovement>> fetchTeamMovements(String scannedCode) async {
    final url = Uri.parse('$baseUrl/team-get-movements/$scannedCode');
    print('🌐 Solicitando: $url');
    final response = await http.get(url);
    print('📥 Response status: ${response.statusCode}');
    print('📥 Response body: ${response.body}');
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      // Verifica que 'data' existe y es una lista
      if (json['data'] != null && json['data'] is List) {
        return (json['data'] as List)
            .map((item) => TeamMovement.fromJson(item))
            .toList();
      } else {
        print('⚠️ No se encontró una lista válida en la clave "data"');
        return []; // o lanza error si prefieres
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