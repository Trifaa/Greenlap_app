import 'package:flutter/material.dart';

class NuevoMovimientoEquipos extends StatefulWidget {
  @override
  _NuevoMovimientoEquiposState createState() => _NuevoMovimientoEquiposState();
}

class _NuevoMovimientoEquiposState extends State<NuevoMovimientoEquipos> {
  String? empresaSeleccionada;
  List<String> empresas = ['Empresa A', 'Empresa B', 'Empresa C'];
  List<String> equiposSeleccionados = [];
  TextEditingController observacionesController = TextEditingController();

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
            // Empresa Dropdown
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Empresa', style: TextStyle(fontWeight: FontWeight.bold)),
                    DropdownButtonFormField<String>(
                      value: empresaSeleccionada,
                      items: empresas.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          empresaSeleccionada = newValue;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Seleccionar',
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
                    Text('Seleccionar Equipos (${equiposSeleccionados.length} seleccionados)',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Container(
                      alignment: Alignment.center,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: equiposSeleccionados.isEmpty
                          ? Text('No hay resultados', style: TextStyle(color: Colors.grey))
                          : ListView(
                              scrollDirection: Axis.horizontal,
                              children: equiposSeleccionados
                                  .map((e) => Chip(label: Text(e)))
                                  .toList(),
                            ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Aquí puedes implementar la lógica para seleccionar equipos
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
                    Text('Observaciones', style: TextStyle(fontWeight: FontWeight.bold)),
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
                // Aquí podrías manejar el guardado del formulario
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
