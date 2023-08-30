import 'package:flutter/material.dart';
import 'package:holding_gesture/holding_gesture.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    String robotID = "";
    if (arguments.isNotEmpty) {
      robotID = arguments['id'];
      //print(robotID);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu Screen"),
      ),
      body: Column(
        children: [
          Container(height: 20.0),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/robotsList");
              },
              child: const Text(
                'Conectar robot',
                style: TextStyle(fontSize: 30),
              ),
            ),
          ),
          Container(height: 20.0),
          Expanded(
            child: ElevatedButton(
              onPressed: () => showDialog(
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return AlertDialog(
                        title: const Text("SELECCIONE EL LAYOUT:",
                            textAlign: TextAlign.center),
                        actions: <Widget>[
                          Column(
                            children: [
                              const Text(
                                "~ LAYOUT POR DEFECTO ~",
                                style: TextStyle(fontSize: 15),
                              ),
                              Container(
                                //Use of SizedBox
                                height: 5,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                child: HoldDetector(
                                  onHold: () {},
                                  enableHapticFeedback: true,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (robotID == "") {
                                      } else {
                                        Navigator.pushNamed(
                                          context,
                                          "/robotsControl",
                                          arguments: {
                                            'option': "A",
                                            'id': robotID
                                          },
                                        );
                                      }
                                    },
                                    child: const Icon(
                                      Icons.maps_home_work,
                                      size: 100,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                //Use of SizedBox
                                height: 20,
                              ),
                              const Text(
                                "~ LAYOUT PERSONALIZABLE ~",
                                style: TextStyle(fontSize: 15),
                              ),
                              Container(
                                //Use of SizedBox
                                height: 5,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                child: HoldDetector(
                                  onHold: () {},
                                  enableHapticFeedback: true,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (robotID == "") {
                                      } else {
                                        Navigator.pushNamed(
                                          context,
                                          "/robotsControl",
                                          arguments: {
                                            'option': "B",
                                            'id': robotID
                                          },
                                        );
                                      }
                                    },
                                    child: const Icon(
                                      Icons.lan,
                                      size: 100,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                //Use of SizedBox
                                height: 20,
                              ),
                              const Text(
                                "~ LAYOUT TÉCNICO ~",
                                style: TextStyle(fontSize: 15),
                              ),
                              Container(
                                //Use of SizedBox
                                height: 5,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                child: HoldDetector(
                                  onHold: () {},
                                  enableHapticFeedback: true,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (robotID == "") {
                                      } else {
                                        Navigator.pushNamed(
                                          context,
                                          "/robotsControl",
                                          arguments: {
                                            'option': "C",
                                            'id': robotID
                                          },
                                        );
                                      }
                                    },
                                    child: const Icon(
                                      Icons.science,
                                      size: 100,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              child: const Text(
                'Controlar robot',
                style: TextStyle(fontSize: 30),
              ),
            ),
          ),
          Container(height: 20.0),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/settings");
              },
              child: const Text(
                '       Ajustes       ',
                style: TextStyle(fontSize: 30),
              ),
            ),
          ),
          Container(height: 20.0),
        ],
      ),
    );
  }
}
