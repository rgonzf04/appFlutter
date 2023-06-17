import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    //Atributos
    String email = "";
    String password = "";
    //Widgets
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Screen"),
      ),
      body: Center(
        child: IntrinsicWidth(
          stepWidth: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(height: 80),
              TextField(
                  key: const Key('emailTextField'),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Email',
                  ),
                  onChanged: (String value) async {
                    email = value;
                    debugPrint(email.toString());
                  }),
              TextField(
                  key: const Key('passwordTextField'),
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Password',
                  ),
                  onChanged: (String value) async {
                    password = value;
                    debugPrint(password.toString());
                  }),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50)),
                onPressed: () {
                  Navigator.pushNamed(context, "/signUp");
                },
                child: const Text('REGISTRARSE'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50)),
                onPressed: () {
                  // sets theme mode to dark

                  Navigator.pushNamed(context, "/menu");
                },
                child: const Text('INICIAR SESIÓN'),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
