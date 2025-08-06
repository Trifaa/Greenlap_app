import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greenlab_app/form.dart';
import 'package:greenlab_app/scanner.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Centrado vertical
          children: [
            SizedBox(
              width: 250.w,
              height: 70.h,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ScannerPage()),
                  );
                },
                icon: const Icon(Icons.barcode_reader, size: 30),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.secondary,
                  foregroundColor: colorScheme.onSecondary,
                  textStyle: TextStyle(fontSize: 20.sp),
                ),
                label: Text('Escanear codigo'),
              ),
            ),
            SizedBox(
              width: 250.w,
              height: 70.h,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NuevoMovimientoEquipos()),
                  );
                },
                icon: const Icon(Icons.barcode_reader, size: 30),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.secondary,
                  foregroundColor: colorScheme.onSecondary,
                  textStyle: TextStyle(fontSize: 20.sp),
                ),
                label: Text('Escanear codigo'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
