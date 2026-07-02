import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UniversidadesView extends StatefulWidget {
  const UniversidadesView({super.key});

  @override
  State<UniversidadesView> createState() => _UniversidadesViewState();
}

class _UniversidadesViewState extends State<UniversidadesView> {
  final TextEditingController paisController = TextEditingController();

  bool cargando = false;
  String mensaje = "";
  List<dynamic> universidades = [];
  bool buscado = false;

  int paginaActual = 0;
  int universidadesPorPagina = 10;

  List<dynamic> get universidadesPaginadas {
    int inicio = paginaActual * universidadesPorPagina;
    int fin = inicio + universidadesPorPagina;

    if (fin > universidades.length) {
      fin = universidades.length;
    }

    return universidades.sublist(inicio, fin);
  }

  int get totalPaginas {
    if (universidades.isEmpty) return 0;

    return (universidades.length / universidadesPorPagina).ceil();
  }

  Future<void> buscarUniversidades() async {
    String pais = paisController.text.trim();

    if (pais.isEmpty) {
      setState(() {
        mensaje = "Escriba un pais en ingles";
        universidades = [];
        buscado = false;
      });
      return;
    }

    setState(() {
      cargando = true;
      mensaje = "Buscando universidades";
      universidades = [];
      buscado = true;
    });

    try {
      String paisFormateado = pais.replaceAll(" ", "+");

      final url = Uri.parse(
        "https://adamix.net/proxy.php?country=$paisFormateado",
      );

      final respuesta = await http.get(url);

      if (respuesta.statusCode == 200) {
        final data = jsonDecode(respuesta.body);
        setState(() {
          universidades = data;
          paginaActual = 0;

          mensaje = universidades.isEmpty
              ? "No se encontraron universidades para $pais"
              : "Se encontraron ${universidades.length} universidades";
        });
      } else {
        setState(() {
          mensaje = "Error al consultar la API";
        });
      }
    } catch (e) {
      setState(() {
        mensaje = "Error de conexion";
      });
    } finally {
      setState(() {
        cargando = false;
      });
    }
  }

  @override
  void dispose() {
    paisController.dispose();
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
                "Encuentra tu universidad",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10),

              Text(
                "Inserta el nombre de un pais para ver sus universidades.",
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 20),

              TextField(
                controller: paisController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5)
                  ),
                  labelText: "Nombre del pais en inlges",
                  hintText: "Ejemplo: Dominican Republic",
                  prefixIcon: Icon(Icons.public),
                ),
              ),

              SizedBox(height: 30),

              ElevatedButton.icon(
                icon: Icon(Icons.search),
                onPressed: buscarUniversidades,
                label: Text("Buscar universidades"),
              ),

              SizedBox(height: 20),

              Text(
                mensaje,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              if (cargando) const CircularProgressIndicator(),

              if (universidades.isNotEmpty)
                Column(
                  children: universidadesPaginadas.map((universidad) {
                    final String nombre = universidad["name"] ?? "Sin nombre";

                    final String dominio = universidad["domains"].isNotEmpty
                        ? universidad["domains"][0]
                        : "Sin dominio";

                    final String web = universidad["web_pages"].isNotEmpty
                        ? universidad["web_pages"][0]
                        : "Sin pagina web";

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: const Icon(Icons.school),
                        title: Text(
                          nombre,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Dominio $dominio"),
                            Text("Web: $web"),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),

              if (universidades.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: paginaActual > 0
                            ? () {
                                setState(() {
                                  paginaActual--;
                                });
                              }
                            : null,
                        child: const Text("Anterior"),
                      ),

                      Text(
                        "Página ${paginaActual + 1} de $totalPaginas",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      ElevatedButton(
                        onPressed: paginaActual < totalPaginas - 1
                            ? () {
                                setState(() {
                                  paginaActual++;
                                });
                              }
                            : null,
                        child: const Text("Siguiente"),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
