import 'package:flutter/material.dart';
import 'package:app/pages/LoginPage.dart';
import 'package:app/pages/MenuPage.dart';
import 'package:app/pages/ProfilePage.dart';
import 'package:app/pages/RobotsControlPage.dart';
import 'package:app/pages/RobotsListPage.dart';
import 'package:app/pages/SettingsPage.dart';
import 'package:app/pages/SignUpPage.dart';

import 'package:adaptive_theme/adaptive_theme.dart';

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
    return AdaptiveTheme(
      light: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.red,
        accentColor: Colors.amber,
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
        accentColor: Colors.amber,
      ),
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        theme: theme,
        darkTheme: darkTheme,
        title: 'Material App',
        initialRoute: '/login',
        routes: _routes,
      ),
    );
  }
}
