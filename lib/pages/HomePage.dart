import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    //Widgets
    return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.0, 0.0),
            end: Alignment(0.25, 0.75),
            colors: <Color>[
              Color.fromARGB(255, 24, 58, 102),
              Color.fromARGB(255, 141, 213, 247),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Image.asset(
                'rover.png',
                height: 385.0,
                width: 385.0,
                alignment: Alignment.center,
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.all(
                    40.0), // Establece un margin de 10 en todas las direcciones
                alignment: Alignment.center, // Expande horizontalmente y centra
                child: const Text(
                  'Conecta tu robot para poder observar su cámara, controlar su movimiento, velocidad ...',
                  style: TextStyle(
                      fontSize: 30,
                      decoration: TextDecoration.none,
                      fontFamily: 'RobotoMono',
                      color: Colors.white),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.all(
                    80.0), // Establece un margin de 10 en todas las direcciones
                alignment: Alignment.center, // Expande horizontalmente y centra

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(100)),
                  onPressed: () {
                    // sets theme mode to dark

                    Navigator.pushNamed(context, "/menu");
                  },
                  child: const Text(
                    'COMENZAR',
                    style: TextStyle(fontSize: 50),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

/*

*/