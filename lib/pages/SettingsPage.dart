import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    String title = 'Settings Screen';

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
        title: title,
        home: Control(title: title),
      ),
    );
  }
}

class Control extends StatefulWidget {
  const Control({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Control> createState() => _Control();
}

class _Control extends State<Control> {
  bool option1 = false;

  onChangeOption1(bool newValue) {
    setState(() {
      option1 = newValue;
      if (option1 == true) {
        AdaptiveTheme.of(context).setDark();
      } else {
        AdaptiveTheme.of(context).setLight();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Screen"),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Row(
            children: const [
              SizedBox(
                width: 10,
              ),
              Icon(Icons.cloud_outlined),
              SizedBox(
                width: 5,
              ),
              Text(
                "Theme",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              )
            ],
          ),
          Divider(height: 20, thickness: 1),
          buildOptions("Dark Theme", option1, onChangeOption1),
          buildOptions("Dark Theme", option1, onChangeOption1)
        ],
      ),
    );
  }

  Padding buildOptions(String name, bool value, Function onChange) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
                value: value,
                onChanged: (bool newValue) {
                  onChange(newValue);
                }),
          )
        ],
      ),
    );
  }
}
