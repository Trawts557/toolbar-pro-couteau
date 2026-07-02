import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AcercaView extends StatelessWidget {
  const AcercaView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                "Contrátame",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 220,
                height: 260,
                child: Image.asset("assets/stwart.png", fit: BoxFit.cover),
              ),
              const Text(
                "Stwart Amarante Nuñez",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),

              const Text(
                "Desarrollador .NET Junior | ASP.NET Core | React | Blazor | SQL Server ",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15),

              const Text(
                "Email: samarante2717rt@gmail.com",
                style: TextStyle(fontSize: 20),
              ),

              SizedBox(height: 5),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => irALink("https://wa.link/j2tvz0"),
                child: Text("WhatsApp"),
              ),
              SizedBox(height: 5),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => irALink(
                  "https://www.linkedin.com/in/stwart-amarante-nu%C3%B1ez-9707432a0/",
                ),
                child: Text("Linkedin"),
              ),
              SizedBox(height: 5),
              const Text(
                "Instituto Tecnológico de las Americas",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> irALink(String url) async {
    final Uri link = Uri.parse(url);

    if (!await launchUrl(link, mode: LaunchMode.externalApplication)) {
      throw Exception("No se pudo abrir el link");
    }
  }
}
