import 'package:flutter/material.dart';

class RobotsListPage extends StatelessWidget {
  const RobotsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Robots List Screen"),
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
