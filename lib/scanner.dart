import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:greenlab_app/Resultpage.dart';
import 'package:greenlab_app/api/api.dart';
import 'package:greenlab_app/form.dart';
import 'package:greenlab_app/home.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ScannerPage extends StatelessWidget {
  const ScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MobileScanner(
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
          returnImage: true,
        ),
        onDetect: (capture) async {
  final String? value = capture.barcodes.first.rawValue;

  if (value != null) {
    final apiService = ApiService(baseUrl: dotenv.env['VITE_API_URL']!);

    try {
      final teamData = await apiService.fetchTeamMovements(value);

      if (teamData != null && teamData.items.isNotEmpty) {
        // ✅ Datos encontrados → ir a ResultPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ResultPage(code: value),
          ),
        );
      } else {
        // ⚠️ Sin datos → ir a página alternativa
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => NuevoMovimientoEquipos(), // tu widget alternativo
          ),
        );
      }
    } catch (e) {
      // Manejo de error → opcionalmente ir a error page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomePage(),
        ),
      );
    }
  }
}
      ),
    );
  }
}
