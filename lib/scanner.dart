import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:greenlab_app/Resultpage.dart';
import 'package:greenlab_app/api/api.dart';
import 'package:greenlab_app/form.dart';
import 'package:greenlab_app/home.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  bool _isProcessing = false;
  final MobileScannerController scannerController = MobileScannerController();

  Future<void> _handleDetection(String value) async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    scannerController.stop();

    final apiService = ApiService(baseUrl: dotenv.env['VITE_API_URL']!);

    try {
      final teamData = await apiService.fetchTeamMovements(value);

      if (!mounted) return;

      if (teamData != null && teamData.items.isNotEmpty) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResultPage(code: value),
          ),
        );
      } else {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NuevoMovimientoEquipos(code: value),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
    } finally {
      scannerController.start();
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            controller: MobileScannerController(
              detectionSpeed: DetectionSpeed.noDuplicates,
              returnImage: true,
            ),
            onDetect: (capture) {
              final String? value = capture.barcodes.first.rawValue;
              if (value != null) {
                _handleDetection(value);
              }
            },
          ),
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}