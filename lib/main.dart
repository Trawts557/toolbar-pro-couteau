import 'package:caja_herramientas/views/acerca_view.dart';
import 'package:caja_herramientas/views/clima_view.dart';
import 'package:caja_herramientas/views/edad_view.dart';
import 'package:caja_herramientas/views/genero_view.dart';
import 'package:caja_herramientas/views/inicio_view.dart';
import 'package:caja_herramientas/views/pokemon_view.dart';
import 'package:caja_herramientas/views/universidades_view.dart';
import 'package:caja_herramientas/views/wordpress_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  String vistaActual = "inicio";

  Widget cambiarVista() {
    switch (vistaActual) {
      case "inicio":
        return const InicioView();

      case "genero":
        return const GeneroView();

      case "edad":
        return const EdadView();

      case "universidad":
        return const UniversidadesView();

      case "clima":
        return const ClimaView();

      case "pokemon":
        return const PokemonView();

      case "wordpress":
        return const WordpressView();

      case "acerca":
        return const AcercaView();

      default:
        return const InicioView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "ToolBar Pro (Couteau)",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.deepOrangeAccent,
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                child: const Text(
                  "Menu de herramientas",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                title: const Text("Inicio", style: TextStyle(fontSize: 20)),
                onTap: () {
                  setState(() {
                    vistaActual = "inicio";
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text(
                  "Predictor de genero",
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {
                  setState(() {
                    vistaActual = "genero";
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text(
                  "Predictor de edad",
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {
                  setState(() {
                    vistaActual = "edad";
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(
                  "Universidades segun pais",
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {
                  setState(() {
                    vistaActual = "universidad";
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text(
                  "Clima en RD",
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {
                  setState(() {
                    vistaActual = "clima";
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text(
                  "Pokemon info",
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {
                  setState(() {
                    vistaActual = "pokemon";
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("WordPress", style: TextStyle(fontSize: 20)),
                onTap: () {
                  setState(() {
                    vistaActual = "wordpress";
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text(
                  "Acerca de - Contratame",
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {
                  setState(() {
                    vistaActual = "acerca";
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: cambiarVista(),
      ),
    );
  }
}
