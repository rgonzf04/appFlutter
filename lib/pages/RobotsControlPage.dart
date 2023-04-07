import 'package:flutter/material.dart';

class RobotsControlPage extends StatelessWidget {
  const RobotsControlPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Robots Control Screen"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, "/menu");
          },
          child: const Text('Volver al menu'),
        ),
      ),
    );
  }
}
