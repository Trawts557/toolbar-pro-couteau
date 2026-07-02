import 'package:flutter/material.dart';

class InicioView extends StatelessWidget {
  const InicioView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              "Bienvenido a la caja de herramientas",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),     
            SizedBox(
              height: 400,
              width: 400,
              child: Image.asset("assets/herramientas.png"),
            ),
          ],
        ),
      ),
    );
  }
}
