import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ClimaView extends StatefulWidget {
  const ClimaView({super.key});

  @override
  State<ClimaView> createState() => _ClimaViewState();
}

class _ClimaViewState extends State<ClimaView> {
  int temperature = 0;
  int weatherCode = 0;
  String mensaje = "";
  String estadoClima = "";
  IconData iconoClima = Icons.cloud;
  Color colorIcono = Colors.black54;
  bool cargando = false;
  // final Map<String, dynamic> cacheClima = {};
  Future<void> consultarClima() async {
    if (cargando) return;

    setState(() {
      cargando = true;
      mensaje = "Consultando";
    });

    try {
      final url = Uri.parse(
        "https://api.open-meteo.com/v1/forecast?latitude=18.4861&longitude=-69.9312&current=temperature_2m,weather_code",
      );
      final respuesta = await http.get(url);

      final data = jsonDecode(respuesta.body);

      if (data["error"] != null) {
        setState(() {
          mensaje = "Limite de peticiones alcanzadas. Intenta mas tarde.";
          temperature = 0;
          weatherCode = 0;
        });
        return;
      }

      if (respuesta.statusCode == 200) {
        setState(() {
          final current = data["current"];

          mostrarClima(current);
        });
      }
    } catch (e) {
      setState(() {
        mensaje = "Hubo un error al hacer la peticion al API";
        temperature = 0;
        weatherCode = 0;
      });
    } finally {
      setState(() {
        cargando = false;
      });
    }
  }

  void mostrarClima(dynamic data) {
    temperature = data["temperature_2m"].round();
    weatherCode = data["weather_code"];
    mensaje = "La temperatura actual en RD es de $temperature grados celsius";

    if (weatherCode == 0) {
      estadoClima = "Soleado";
      iconoClima = Icons.sunny;
      colorIcono = Colors.yellow;
    } else if (weatherCode <= 3) {
      estadoClima = "Parcialmente nublado";
      iconoClima = Icons.cloud;
      colorIcono = Colors.grey;
    } else if (weatherCode >= 51 && weatherCode <= 65) {
      estadoClima = "Lluvioso";
      iconoClima = Icons.water_drop;
      colorIcono = Colors.blue;
    } else if (weatherCode == 95) {
      estadoClima = "Tormenta";
      colorIcono = Colors.deepPurple;
      iconoClima = Icons.thunderstorm;
    } else {
      estadoClima = "Desconocido";
      iconoClima = Icons.help_outline;
      colorIcono = Colors.black54;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 30),

              const Text(
                "¿Como está el clima en RD?",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              const Text("Averigualo ahora clickeando el boton debajo."),

              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: consultarClima,
                icon: Icon(Icons.sunny),
                label: Text("Mostrar temperatura y clima"),
              ),

              SizedBox(height: 30),

              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [ 
                      Icon(iconoClima, size: 100, color: colorIcono),

                      SizedBox(height: 10),

                      Text(
                        "Clima: $estadoClima",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 10),

                      Text(
                        "Temperatura: $temperature °C",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
