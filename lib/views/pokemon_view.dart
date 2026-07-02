import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PokemonView extends StatefulWidget {
  const PokemonView({super.key});

  @override
  State<PokemonView> createState() => _PokemonViewState();
}

class _PokemonViewState extends State<PokemonView> {
  final TextEditingController pokemonController = TextEditingController();
  final AudioPlayer audioPlayer = AudioPlayer();

  String mensaje = "Inserta el nombre de un Pokemon para buscarlo";
  String nombrePokemon = "";
  String imagenPokemon = "";
  String sonidoPokemon = "";
  int experienciaBase = 0;
  List<dynamic> habilidades = [];
  bool cargando = false;

  Future<void> buscarPokemon() async {
    String pokemon = pokemonController.text.trim();

    if (pokemon.isEmpty) {
      setState(() {
        mensaje = "Por favor escribe el nombre de un Pokemon. ";
        nombrePokemon = "";
        imagenPokemon = "";
        sonidoPokemon = "";
        experienciaBase = 0;
        habilidades = [];
      });
      return;
    }

    setState(() {
      cargando = true;
      mensaje = "Buscando Pokemon...";
    });

    try {
      final url = Uri.parse("https://pokeapi.co/api/v2/pokemon/$pokemon");
      final respuesta = await http.get(url);

      if (respuesta.statusCode == 200) {
        final data = jsonDecode(respuesta.body);

        setState(() {
          nombrePokemon = data["name"];
          experienciaBase = data["base_experience"];
          imagenPokemon =
              data["sprites"]["other"]["official-artwork"]["front_default"] ??
              "";
          sonidoPokemon = data["cries"]["latest"] ?? "";
          habilidades = data["abilities"];

          mensaje = "Pokemon encontrado";
        });
      } else {
        mensaje = "No se encontro ese Pokemon";
        nombrePokemon = "";
        experienciaBase = 0;
        imagenPokemon = "";
        sonidoPokemon = "";
        habilidades = [];
      }
    } catch (e) {
      mensaje = "Error de conexion";
    } finally {
      setState(() {
        cargando = false;
      });
    }
  }

  Future<void> reproducirSonido() async {
    if (sonidoPokemon.isNotEmpty) {
      await audioPlayer.play(UrlSource(sonidoPokemon));
    }
  }

  @override
  void dispose() {
    pokemonController.dispose();

    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 30),

              Text(
                "Pokemon Finder",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10),

              Text(
                "Busca un Pokemon y descubre su imagen, experiencia, habilidades y sonido",
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 20),

              TextField(
                controller: pokemonController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  prefixIcon: Icon(Icons.catching_pokemon),
                  label: Text("Nombre del pokemon"),
                  hintText: "Pikachu",
                ),
              ),

              SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: buscarPokemon,
                icon: Icon(Icons.search),
                label: Text("Buscar Pokemon"),
              ),

              SizedBox(height: 20),

              Text(mensaje, style: TextStyle(fontWeight: FontWeight.bold)),

              if (nombrePokemon.isNotEmpty)
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        if (imagenPokemon.isNotEmpty)
                          SizedBox(
                            height: 220,
                            width: 220,
                            child: Image.network(
                              imagenPokemon,
                              height: 100,
                              fit: BoxFit.contain,
                            ),
                          ),

                        if (nombrePokemon.isNotEmpty)
                          Text(
                            nombrePokemon.toUpperCase(),
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                        if (experienciaBase != 0)
                          Text("Experiencia base: $experienciaBase"),

                        if (sonidoPokemon.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: ElevatedButton.icon(
                              onPressed: reproducirSonido,
                              icon: const Icon(Icons.volume_up),
                              label: const Text("Reproducir sonido"),
                            ),
                          ),

                        if (habilidades.isNotEmpty)
                          Column(
                            children: [
                              const SizedBox(height: 20),

                              const Text(
                                "Habilidades",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 10),

                              ...habilidades.map((habilidad) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: Text(
                                    habilidad["ability"]["name"],
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                );
                              }),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
