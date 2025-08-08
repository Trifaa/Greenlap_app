import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NuevoMovimientoEquipos extends StatefulWidget {
  @override
  _NuevoMovimientoEquiposState createState() => _NuevoMovimientoEquiposState();
}

class _NuevoMovimientoEquiposState extends State<NuevoMovimientoEquipos> {
  String? empresaSeleccionada;
  List<Map<String, dynamic>> empresas = [];
  List<String> equiposSeleccionados = [];
  TextEditingController observacionesController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  bool cargando = false;

  Future<void> buscarEmpresas() async {
    setState(() {
      cargando = true;
    });

    final query = searchController.text.trim();
    final url = Uri.parse(
        'https://greenlabperu.com/api/v1/list-companies-app?search=$query');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List data = jsonData['data']['data'];

        setState(() {
          empresas = data
              .map((empresa) => {
                    "id": empresa["id"],
                    "name": empresa["name"],
                    "ruc": empresa["ruc"]
                  })
              .toList();
        });
      } else {
        print("Error al obtener empresas: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }

    setState(() {
      cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nuevo Movimiento de Equipos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Buscar Empresa
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Buscar Empresa',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              hintText: 'Nombre o RUC',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: buscarEmpresas,
                          child: cargando
                              ? SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text('Buscar'),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: empresaSeleccionada,
                      items: empresas.map((empresa) {
                        final displayName =
                            "${empresa["name"]} (${empresa["ruc"]})";
                        return DropdownMenuItem<String>(
                          value: displayName,
                          child: Text(displayName),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          empresaSeleccionada = newValue;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Seleccionar empresa',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Seleccionar Equipos
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Seleccionar Equipos (${equiposSeleccionados.length} seleccionados)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Container(
                      alignment: Alignment.center,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: equiposSeleccionados.isEmpty
                          ? Text('No hay resultados',
                              style: TextStyle(color: Colors.grey))
                          : ListView(
                              scrollDirection: Axis.horizontal,
                              children: equiposSeleccionados
                                  .map((e) => Chip(label: Text(e)))
                                  .toList(),
                            ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Lógica para seleccionar equipos
                      },
                      child: Text('Equipos seleccionados'),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Observaciones
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Observaciones',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: observacionesController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Detalles adicionales del movimiento...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24),

            // Botón de Guardar
            ElevatedButton(
              onPressed: () {
                print('Empresa: $empresaSeleccionada');
                print('Observaciones: ${observacionesController.text}');
              },
              child: Text('Guardar Movimiento'),
            ),
          ],
        ),
      ),
    );
  }
}

