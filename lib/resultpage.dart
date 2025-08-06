import 'package:flutter/material.dart';
import 'package:greenlab_app/api/api.dart';
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
  late Future<List<TeamMovement>> _infoscanner;
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

  @override
  void initState() {
    super.initState();

    final baseUrl = dotenv.env['VITE_API_URL'];
    print('🔗 Base URL cargada: $baseUrl');

    _infoscanner = _apiService.fetchTeamMovements(widget.code);
    _infoscanner
        .then((movements) {
          print(
            '📦 Resultado del API: ${movements.length} movimientos encontrados',
          );
          if (movements.isNotEmpty) {
            final item = movements.first;
            print('eres un kbro de mrd ');
            print("dotenv.env['VITE_API_URL");

            setState(() {
              nombreProducto = item.movement.description ?? '';
              descripcion = item.movement.description ?? '';
              stock = item.amount ?? 0;
              boton = item.teamId ?? 0;
              diaEntrega = item.movement.deliveryDate ?? '';
              direccionEntrega = item.movement.deliveryDate ?? '';
              diaRegreso = item.movement.deliveryDate ?? '';
              compania = item.movement.description ?? '';
              estado = item.movement.status ?? '';
              isLoading = false;
            });
          } else {
            setState(() => isLoading = false);
          }
        })
        .catchError((error) {
          setState(() => isLoading = false);
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
            Row(
              children: [
                const Text(
                  '✅ Estado: ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                EstadoEtiqueta(estado: "en uso"),
              ],
            ),
            Row(
              children: [
                const Text(
                  '✅ Estado: ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                EstadoEtiqueta(estado: "disponible"),
              ],
            ),
            Row(
              children: [
                const Text(
                  '✅ Estado: ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                EstadoEtiqueta(estado: "malogrado"),
              ],
            ),
            InfoRow(label: '📦 cantidad', value: '$stock unidades'),
            InfoRow(label: '📅 Día de entrega', value: diaEntrega),
            InfoRow(label: '📦 Dirección de entrega', value: direccionEntrega),
            InfoRow(label: '📆 Día de devolución', value: diaRegreso),
            InfoRow(label: '🏢 Empresa', value: compania),
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

                if (movements.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✅ Producto marcado como recibido'),
                    ),
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
