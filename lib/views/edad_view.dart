import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EdadView extends StatefulWidget {
  const EdadView({super.key});

  @override
  State<EdadView> createState() => _EdadViewState();
}

class _EdadViewState extends State<EdadView> {
  final TextEditingController nombreController = TextEditingController();

  int edad = 0;
  String mensaje = "Escribe un nombre y descubre la edad";
  Color colorFondo = Colors.green.shade50;
  IconData iconoPersona = Icons.cake;
  Color colorIcono = Colors.orange;

  bool cargando = false;
  final Map<String, dynamic> cacheEdad = {};
  Future<void> predecirEdad() async {
    String nombre = nombreController.text.trim().toLowerCase();
    String nombreOriginal = nombreController.text;
    if (nombre.isEmpty) {
      setState(() {
        mensaje = "Por favor inserte un nombre";
        edad = 0;
        iconoPersona = Icons.warning_amber_rounded;
        colorIcono = Colors.orange;
      });
      return;
    }

    if (cargando) return;

    if (cacheEdad.containsKey(nombre)) {
      final data = cacheEdad[nombre];
      mostrarResultado(nombre, data);
      return;
    }

    setState(() {
      cargando = true;
      mensaje = "Consultando";
    });

    try {
      final url = Uri.parse("https://api.agify.io/?name=$nombre");
      final respuesta = await http.get(url);

      final data = jsonDecode(respuesta.body);

      if (data["error"] != null) {
        setState(() {
          mensaje = "Limite de peticiones alcanzado. Intenta mas tarde";
          edad = 0;
          colorFondo = Colors.red.shade100;
          iconoPersona = Icons.error_outline;
          colorIcono = Colors.red;
        });
        return;
      }

      if (respuesta.statusCode == 200) {
        cacheEdad[nombre] = data;
        mostrarResultado(nombreOriginal, data);
      } else {
        setState(() {
          mensaje = "Error al consultar la API";
          colorFondo = Colors.red.shade100;
          iconoPersona = Icons.error_outline;
          colorIcono = Colors.red;
        });
      }
    } catch (e) {
      setState(() {
        mensaje = "Error de conexion";
        edad = 0;
        colorFondo = Colors.red.shade100;
        iconoPersona = Icons.wifi_off;
        colorIcono = Colors.red;
      });
    } finally {
      setState(() {
        cargando = false;
      });
    }
  }

  void mostrarResultado(String nombre, dynamic data) {
    setState(() {
      edad = data["age"] ?? "desconocido";

      if (edad == 0) {
        mensaje = "No se pudo predecir la edad";
        iconoPersona = Icons.help_outline;
        colorFondo = Colors.grey.shade300;
        colorIcono = Colors.grey;
      } else if (edad < 18) {
        mensaje = "$nombre tiene aproximadamente $edad años. Es joven.";
        iconoPersona = Icons.child_care;
        colorFondo = Colors.yellow.shade100;
        colorIcono = Colors.amber;
      } else if (edad < 60) {
        mensaje = "$nombre tiene aproximadamente $edad años. Es adulto.";
        iconoPersona = Icons.person_4;
        colorFondo = Colors.green.shade100;
        colorIcono = Colors.green;
      } else {
        mensaje = "$nombre tiene aproximadamente $edad años. Es viejo.";
        iconoPersona = Icons.elderly_outlined;
        colorFondo = Colors.blue.shade100;
        colorIcono = Colors.blue;
      }
    });
  }

  @override
  void dispose() {
    nombreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      color: colorFondo,
      child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 30),
                Text(
                  "Predictor de edad",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                const Text(
                  "Ingresa un nombre y la app intentara predecir",
                  style: TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 30),

                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: EdgeInsetsGeometry.all(20),
                    child: Column(
                      children: [
                        Icon(iconoPersona, size: 90, color: colorIcono),

                        const SizedBox(height: 20),

                        TextField(
                          controller: nombreController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelText: "Nombre",
                            hintText: "Ejemplo: Juan",
                            prefixIcon: const Icon(Icons.person),
                          ),
                        ),
                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: predecirEdad,
                            icon: Icon(Icons.search),
                            label: Text("Predecir edad"),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              textStyle: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(18),
                    child: Column(
                      children: [
                        Text(
                          mensaje,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 10),

                        if (edad != 0)
                          Text(
                            "[API] Resultado edad: $edad",
                            style: const TextStyle(fontSize: 16),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
