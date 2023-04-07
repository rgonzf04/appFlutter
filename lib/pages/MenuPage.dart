import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu Screen"),
      ),
      body: Center(
        child: Column(
          children: [
            Container(height: 20.0),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/login");
                },
                child: const Text('Cerrar sesión'),
              ),
            ),
            Container(height: 20.0),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/profile");
                },
                child: const Text('Ver perfil'),
              ),
            ),
            Container(height: 20.0),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/robotsList");
                },
                child: const Text('Conectar robot'),
              ),
            ),
            Container(height: 20.0),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/robotsControl");
                },
                child: const Text('Controlar robot'),
              ),
            ),
            Container(height: 20.0),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/settings");
                },
                child: const Text('Ajustes'),
              ),
            ),
            Container(height: 20.0),
          ],
        ),
      ),
    );
  }
}
