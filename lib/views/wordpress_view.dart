import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WordpressView extends StatefulWidget {
  const WordpressView({super.key});

  @override
  State<WordpressView> createState() => _WordpressViewState();
}

class _WordpressViewState extends State<WordpressView> {
  bool cargando = false;
  String mensaje = "Presiona el boton para cargar las ultimas noticias.";
  List<dynamic> noticias = [];

  Future<void> mostrarNoticias() async {
    if (cargando) return;

    setState(() {
      cargando = true;
      mensaje = "Cargando noticias...";
      noticias = [];
    });

    try {
      final url = Uri.parse("https://ma.tt/wp-json/wp/v2/posts?per_page=3");
      final respuesta = await http.get(url);

      if (respuesta.statusCode == 200) {
        final data = jsonDecode(respuesta.body);

        setState(() {
          noticias = data;
          mensaje = "Ultimas 3 noticias de Matt Blog";
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

  String limpiarHtml(String texto) {
    return texto
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll("&#8217;", "'")
        .replaceAll("&nbsp;", " ")
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 30),

              SizedBox(
                height: 180,
                width: 280,
                child: Image.asset("assets/matt.jpg"),
              ),

              const SizedBox(height: 20),

              const Text(
                "Matt Blog - ma.tt",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              Text(mensaje, textAlign: TextAlign.center),

              const SizedBox(height: 10),

              ElevatedButton.icon(
                onPressed: mostrarNoticias,
                icon: const Icon(Icons.article),
                label: Text("Mostrar noticias"),
              ),
              if (cargando) const CircularProgressIndicator(),

              if (noticias.isNotEmpty)
                Column(
                  children: noticias.map((noticia) {
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              noticia["title"]["rendered"],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 10),

                            Text(
                              limpiarHtml(noticia["excerpt"]["rendered"]),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
