import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:greenlab_app/home.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class NuevoMovimientoEquipos extends StatefulWidget {
  final String code; // Código escaneado

  const NuevoMovimientoEquipos({super.key, required this.code});

  @override
  _NuevoMovimientoEquiposState createState() => _NuevoMovimientoEquiposState();
}

class _NuevoMovimientoEquiposState extends State<NuevoMovimientoEquipos> {
  int? teamId; // Aquí guardaremos el ID del equipo tras consulta
  bool cargandoTeamId = true;

  String? empresaSeleccionada;
  int? empresaIdSeleccionada;
  DateTime? returnDate;

  List<Map<String, dynamic>> empresas = [];
  TextEditingController observacionesController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  bool cargando = false;

  @override
  void initState() {
    super.initState();
    obtenerTeamId(widget.code);
  }

  Future<void> obtenerTeamId(String code) async {
    setState(() => cargandoTeamId = true);

    final url = Uri.parse(
      "https://greenlabperu.com/api/v1/team-get-movements/$code",
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final team = jsonData['data']['team'];

        setState(() {
          teamId = team['id'];
          cargandoTeamId = false;
        });
      } else {
        print("❌ Error al obtener teamId: ${response.statusCode}");
        setState(() {
          teamId = null;
          cargandoTeamId = false;
        });
      }
    } catch (e) {
      print("❌ Error en la conexión para obtener teamId: $e");
      setState(() {
        teamId = null;
        cargandoTeamId = false;
      });
    }
  }

  Future<void> buscarEmpresas() async {
    setState(() => cargando = true);

    final query = searchController.text.trim();
    final url = Uri.parse(
      'https://greenlabperu.com/api/v1/list-companies-app?search=$query',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List data = jsonData['data']['data'];

        setState(() {
          empresas =
              data
                  .map(
                    (empresa) => {
                      "id": empresa["id"],
                      "name": empresa["name"],
                      "ruc": empresa["ruc"],
                    },
                  )
                  .toList();
        });
      } else {
        print("❌ Error al obtener empresas: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error en la conexión: $e");
    }

    setState(() => cargando = false);
  }

  Future<void> seleccionarFechaRetorno() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        returnDate = picked;
      });
    }
  }

  Future<void> guardarMovimiento() async {
    if (teamId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No se pudo obtener el ID del equipo")),
      );
      return;
    }

    if (empresaIdSeleccionada == null || returnDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Seleccione empresa y fecha de retorno")),
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("user_id");

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Usuario no encontrado, inicie sesión")),
      );
      return;
    }

    final String deliveryDate = DateFormat(
      "yyyy-MM-dd HH:mm:ss",
    ).format(DateTime.now());
    final String returnDateStr = DateFormat(
      "yyyy-MM-dd HH:mm:ss",
    ).format(returnDate!);

    final body = {
      "company_id": empresaIdSeleccionada,
      "user_id": userId,
      "delivery_date": deliveryDate,
      "return_date": returnDateStr,
      "description": observacionesController.text,
    };

    final url = Uri.parse(
      "https://greenlabperu.com/api/v1/movement-store-app/$teamId",
    );

    print("======================================");
    print("📡 URL: $url");
    print("📦 Datos enviados: ${jsonEncode(body)}");
    print("======================================");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Movimiento guardado correctamente")),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error al guardar movimiento")));
      }
    } catch (e) {
      // print("❌ Error en la petición: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error en la conexión con el servidor")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cargandoTeamId) {
      return Scaffold(
        appBar: AppBar(title: Text('Nuevo Movimiento de Equipos')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (teamId == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Nuevo Movimiento de Equipos')),
        body: Center(child: Text('No se encontró el equipo con ese código')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Nuevo Movimiento de Equipos')),
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
                    Text(
                      'Buscar Empresa',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
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
                          child:
                              cargando
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
                    DropdownButtonFormField<int>(
                      value: empresaIdSeleccionada,
                      items:
                          empresas.map((empresa) {
                            return DropdownMenuItem<int>(
                              value: empresa["id"],
                              child: Container(
                                width:
                                    200, // Puedes ajustar el ancho máximo que quieras
                                child: Text(
                                  "${empresa["name"]} (${empresa["ruc"]})",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  softWrap: false,
                                ),
                              ),
                            );
                          }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          empresaIdSeleccionada = newValue;
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

            // Seleccionar fecha de retorno
            Card(
              child: ListTile(
                title: Text(
                  returnDate == null
                      ? "Seleccionar fecha de retorno"
                      : "Retorno: ${DateFormat("yyyy-MM-dd").format(returnDate!)}",
                ),
                trailing: Icon(Icons.calendar_today),
                onTap: seleccionarFechaRetorno,
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
                    Text(
                      'Observaciones',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
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

            // Botón Guardar
            ElevatedButton(
              onPressed: guardarMovimiento,
              child: Text('Guardar Movimiento'),
            ),
          ],
        ),
      ),
    );
  }
}
