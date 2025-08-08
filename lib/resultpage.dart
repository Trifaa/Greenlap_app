import 'package:flutter/material.dart';
import 'package:greenlab_app/api/api.dart';
import 'package:greenlab_app/home.dart';
import 'package:greenlab_app/model/model.dart';
import 'package:greenlab_app/style/style_login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ResultPage extends StatefulWidget {
  final String code;

  const ResultPage({super.key, required this.code});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late Future<TeamData?> _infoscanner;
  final ApiService _apiService = ApiService(
    baseUrl: dotenv.env['VITE_API_URL']!,
  );
  bool isLoading = true;
  String nombreProducto = '';
  String descripcion = '';
  int stock = 0;
  int? boton = 0;
  String diaEntrega = '';
  String direccionEntrega = '';
  String diaRegreso = '';
  String compania = '';
  String estado = '';
  int? teamId = 0;

  @override
  void initState() {
    super.initState();

    final baseUrl = dotenv.env['VITE_API_URL'];

    _infoscanner = _apiService.fetchTeamMovements(widget.code);
    _infoscanner
        .then((teamData) {

        if (teamData != null) {
      final team = teamData.team;
      final items = teamData.items;

      setState(() {
        // Datos de team
        teamId = team.id;
        nombreProducto = team.description;
        stock = team.stock;
        boton = team.id;
        estado = team.stateCalibration;

        // Datos del primer item (si existe)
        if (items.isNotEmpty) {
          final item = items.first;
          diaEntrega = item.movement.deliveryDate ?? '';
          descripcion = item.movement.description?? '';
          // direccionEntrega = 'Dirección X'; 
          diaRegreso = item.movement.returnDate ?? '';
        }

        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }).catchError((error) {
    setState(() => isLoading = false);
    print('❌ Error: $error');
  });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del Producto')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            InfoRow(label: '📦 Código escaneado', value: widget.code),
            InfoRow(label: '📝 Nombre del Equipo', value: nombreProducto),
            InfoRow(label: '📃 Descripción', value: descripcion),
            InfoRow(label: '✅ Estado', value: estado),
            InfoRow(label: '📦 cantidad', value: '$stock unidades'),
            InfoRow(label: '📅 Día de entrega', value: diaEntrega),
            // InfoRow(label: '📦 Dirección de entrega', value: direccionEntrega),
            InfoRow(label: '📆 Día de devolución', value: diaRegreso),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () async {
              if (boton == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('❌ Error: ID del equipo no disponible'),
                  ),
                );
                return;
              }

              setState(() => isLoading = true);

              try {
                await _apiService.sendTeamId(boton.toString());
                final movements = await _infoscanner;

                if (!mounted) return;

                if (movements?.items?.isNotEmpty ?? false) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✅ Producto marcado como recibido'),
                    ),
                  );
                   Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('⚠️ No se encontró información del equipo'),
                    ),
                  );
                }
              } catch (e) {
                print('❗ Error al enviar recibido: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('❌ Error al marcar como recibido'),
                  ),
                );
              } finally {
                setState(() => isLoading = false);
              }
            },
            child: const Text('Recibido', style: TextStyle(fontSize: 18)),
          ),
        ),
      ),
    );
  }
}
