import 'package:flutter/material.dart';

class InicioView extends StatelessWidget {
  const InicioView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "Bienvenido a la caja de herramientas",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              width: 300,
              child: Image.asset("assets/herramientas.png"),
            ),
          ],
        ),
      ),
    );
  }
}
