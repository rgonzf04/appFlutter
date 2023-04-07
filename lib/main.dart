import 'package:flutter/material.dart';
import 'package:app/pages/LoginPage.dart';
import 'package:app/pages/MenuPage.dart';
import 'package:app/pages/ProfilePage.dart';
import 'package:app/pages/RobotsControlPage.dart';
import 'package:app/pages/RobotsListPage.dart';
import 'package:app/pages/SettingsPage.dart';
import 'package:app/pages/SignUpPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _routes = {
    '/login': (context) => LoginPage(),
    '/menu': (context) => const MenuPage(),
    '/profile': (context) => const ProfilePage(),
    '/robotsControl': (context) => const RobotsControlPage(),
    '/robotsList': (context) => const RobotsListPage(),
    '/settings': (context) => const SettingsPage(),
    '/signUp': (context) => const SignUpPage(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      initialRoute: '/login',
      routes: _routes,
    );
  }
}
