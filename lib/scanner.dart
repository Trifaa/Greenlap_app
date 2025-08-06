import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:greenlab_app/Resultpage.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

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
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          final String? value = barcodes.first.rawValue;
          
          for (final barcode in barcodes) {
            print('Funciona ${barcode.rawValue}');
          }
          if (value != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ResultPage(code: value),
              ),
            );
          }
        },
      ),
    );
  }
}
