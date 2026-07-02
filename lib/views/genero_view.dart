import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GeneroView extends StatefulWidget {
  const GeneroView({super.key});

  @override
  State<GeneroView> createState() => _GeneroViewState();
}

class _GeneroViewState extends State<GeneroView> {
  final TextEditingController nombreController = TextEditingController();

  String genero = "";
  String mensaje = "Escribe un nombre y descubre el genero probable";
  Color colorFondo = Colors.orange.shade50;
  IconData iconoGenero = Icons.person_search;
  Color colorIcono = Colors.orange;

  bool cargando = false;
  final Map<String, dynamic> cacheGenero = {};
  Future<void> predecirGenero() async {
    String nombre = nombreController.text.trim().toLowerCase();

    if (nombre.isEmpty) {
      setState(() {
        mensaje = "Por favor inserte un nombre";
        genero = "";
        colorFondo = Colors.orange.shade50;
        iconoGenero = Icons.warning_amber_rounded;
        colorIcono = Colors.orange;
      });
      return;
    }

    if (cargando) return;

    if (cacheGenero.containsKey(nombre)) {
      final data = cacheGenero[nombre];
      mostrarResultado(nombre, data);
      return;
    }

    setState(() {
      cargando = true;
      mensaje = "Consultando";
    });

    try {
      final url = Uri.parse("https://api.genderize.io/?name=$nombre");
      final respuesta = await http.get(url);

      final data = jsonDecode(respuesta.body);

      if (data["error"] != null) {
        setState(() {
          mensaje = "Limite de peticiones alcanzado. Intenta mas tarde";
          genero = "";
          colorFondo = Colors.red.shade100;
          iconoGenero = Icons.error_outline;
          colorIcono = Colors.red;
        });
        return;
      }

      if (respuesta.statusCode == 200) {
        cacheGenero[nombre] = data;
        mostrarResultado(nombre, data);
      } else {
        setState(() {
          mensaje = "Error al consultar la API";
          genero = "";
          colorFondo = Colors.red.shade100;
          iconoGenero = Icons.error_outline;
          colorIcono = Colors.red;
        });
      }
    } catch (e) {
      setState(() {
        mensaje = "Error de conexion";
        genero = "";
        colorFondo = Colors.red.shade100;
        iconoGenero = Icons.wifi_off;
        colorIcono = Colors.red;
      });
    }
    finally{
      setState(() {
        cargando = false;
      });
    }
  }

  void mostrarResultado(String nombre, dynamic data) {
    setState(() {
      genero = data["gender"] ?? "desconocido";

      if (genero == "male") {
        mensaje = "El género probable de $nombre es masculino";
        colorFondo = Colors.blue.shade100;
        iconoGenero = Icons.male;
        colorIcono = Colors.blue;
      } else if (genero == "female") {
        mensaje = "El género probable de $nombre es femenino";
        colorFondo = Colors.pink.shade100;
        iconoGenero = Icons.female;
        colorIcono = Colors.pink;
      } else {
        mensaje = "No se pudo encontrar el género";
        colorFondo = Colors.grey.shade300;
        iconoGenero = Icons.help_outline;
        colorIcono = Colors.grey;
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
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      color: colorFondo,
      child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 30),
                Text(
                  "Predictor de genero",
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
                        Icon(iconoGenero, size: 90, color: colorIcono),

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
                            onPressed: cargando ? null : predecirGenero,
                            icon: Icon(Icons.search),
                            label: Text(cargando ? "Consultando API":"Predecir genero"),
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

                        if (genero.isNotEmpty)
                          Text(
                            "[API] Resultado genero: $genero",
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
