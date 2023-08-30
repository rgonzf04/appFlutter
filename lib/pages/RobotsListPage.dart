import 'package:flutter/material.dart';

class RobotsListPage extends StatelessWidget {
  const RobotsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Robots List Screen"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.all(50.0),
            child: TextFormField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'ID:   Para esta simulación: ws://127.0.0.1:9090',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, "/menu",
                  arguments: {'id': controller.text});
            },
            child: const Text(
              'Confirmar ID',
              style: TextStyle(fontSize: 30),
            ),
          ),
        ],
      ),
    );
  }
}

/*
children: [
            TextFormField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'host = "ws://127.0.0.1:9090"',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/menu",
                    arguments: {'id': controller.text});
              },
              child: const Text('Volver al menu'),
            ),
          ],
 */
