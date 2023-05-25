import 'dart:async';
import 'dart:io';

import 'package:app/pages/MenuPage.dart';
import 'package:flutter/material.dart';
import 'package:roslibdart/roslibdart.dart';
import 'dart:convert';
import 'package:holding_gesture/holding_gesture.dart';

String visibility = "default";

class RobotsControlPage extends StatelessWidget {
  const RobotsControlPage({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    String title = 'Control Screen';
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    visibility = arguments['option'];
    print(visibility);
    return MaterialApp(
      title: title,
      home: Control(title: title),
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
  String host = 'ws://127.0.0.1:9090';
  late Ros ros;
  late Topic cmdVelTopic;
  late Topic camera;

  double turnAngularVelocity = 0.5;
  double forwardVelocity = 0.1;

  //Variables visibilidad dialogo
  bool visible1 = true;
  bool visible2 = true;
  bool visible3 = true;
  bool visibleDesactivadoButton = true;

  //Variables cambia color dialogo
  Color co1 = Color.fromARGB(255, 250, 183, 167);
  Color co2 = Color.fromARGB(255, 250, 183, 167);
  Color co3 = Color.fromARGB(255, 250, 183, 167);

  @override
  void initState() {
    if (visibility == "A") {
      visible1 = true;
      visible2 = true;
      visible3 = true;
      visibleDesactivadoButton = true;
      co1 = Color.fromARGB(255, 199, 243, 174);
      co2 = Color.fromARGB(255, 199, 243, 174);
      co3 = Color.fromARGB(255, 199, 243, 174);
    } else if (visibility == "B") {
      visible1 = false;
      visible2 = false;
      visible3 = false;
      visibleDesactivadoButton = false;
      co1 = Color.fromARGB(255, 250, 183, 167);
      co2 = Color.fromARGB(255, 250, 183, 167);
      co3 = Color.fromARGB(255, 250, 183, 167);
    }

    //TOPIC MOVIMIENTO

    ros = Ros(url: host);
    cmdVelTopic = Topic(
        ros: ros,
        name: '/cmd_vel',
        type: "geometry_msgs/msg/Twist",
        reconnectOnClose: true,
        queueLength: 10,
        queueSize: 10);

    //TOPIC CAMERA

    camera = Topic(
      ros: ros,
      name: '/camera/image_raw/compressed',
      type: "sensor_msgs/msg/CompressedImage",
      queueSize: 10,
      queueLength: 10,
    );

    Timer(const Duration(seconds: 1), () async {
      await camera.subscribe(subscribeHandler);
      // await chatter.subscribe();
    });

    ros.connect();
    super.initState();
  }

  Color c1 = Color.fromARGB(255, 56, 158, 241);
  Color c2 = Color.fromARGB(255, 56, 158, 241);
  Color c3 = Color.fromARGB(255, 56, 158, 241);
  Color c4 = Color.fromARGB(255, 56, 158, 241);

  Future<void> subscribeHandler(Map<String, dynamic> msg) async {
    //print(msg);
    setState(() {});
  }

  void destroyConnection() async {
    await camera.unsubscribe();
    await ros.close();
    setState(() {});
  }

  String msgReceived = '';

  var lastDirectionTwist = {};

  void changeColor() {
    c1 = Color.fromARGB(255, 187, 93, 87);
  }

  void stop() {
    c1 = Color.fromARGB(255, 56, 158, 241);
    c2 = Color.fromARGB(255, 56, 158, 241);
    c3 = Color.fromARGB(255, 56, 158, 241);
    c4 = Color.fromARGB(255, 56, 158, 241);
    var linear = {'x': 0.0, 'y': 0.0, 'z': 0.0};
    var angular = {'x': 0.0, 'y': 0.0, 'z': 0};

    var twist = {'linear': linear, 'angular': angular};

    cmdVelTopic.publish(twist);
    lastDirectionTwist = twist;
  }

  void moveForward() {
    c1 = Color.fromARGB(255, 187, 93, 87);
    var linear = {'x': forwardVelocity, 'y': 0.0, 'z': 0.0};
    var angular = {'x': 0.0, 'y': 0.0, 'z': 0};

    var twist = {'linear': linear, 'angular': angular};

    print('Direction to published ' + jsonEncode(twist));
    cmdVelTopic.publish(twist);
    lastDirectionTwist = twist;
  }

  void moveBackward() {
    c4 = Color.fromARGB(255, 187, 93, 87);
    var linear = {'x': -forwardVelocity, 'y': 0.0, 'z': 0.0};
    var angular = {'x': 0.0, 'y': 0.0, 'z': 0};

    var twist = {'linear': linear, 'angular': angular};

    cmdVelTopic.publish(twist);
    lastDirectionTwist = twist;
  }

  void turnRight() {
    c3 = Color.fromARGB(255, 187, 93, 87);
    var linear = {'x': forwardVelocity, 'y': 0.0, 'z': 0.0};
    var angular = {'x': 0.0, 'y': 0.0, 'z': -turnAngularVelocity};

    var twist = {'linear': linear, 'angular': angular};

    cmdVelTopic.publish(twist);
    lastDirectionTwist = twist;
  }

  void turnLeft() {
    c2 = Color.fromARGB(255, 187, 93, 87);
    var linear = {'x': forwardVelocity, 'y': 0.0, 'z': 0.0};
    var angular = {'x': 0.0, 'y': 0.0, 'z': turnAngularVelocity};

    var twist = {'linear': linear, 'angular': angular};

    cmdVelTopic.publish(twist);
    lastDirectionTwist = twist;
  }

  void velocityUp() {
    print(forwardVelocity);
    if (forwardVelocity > 0.09 && forwardVelocity < 1.49) {
      forwardVelocity = forwardVelocity + 0.1;
    }
  }

  void velocityDown() {
    if (forwardVelocity > 0.11 && forwardVelocity < 1.51) {
      forwardVelocity = forwardVelocity - 0.1;
    }
  }

  void changeValue(int option) {
    setState(() {
      if (option == 1) {
        if (visible1 == true) {
          visible1 = false;
          co1 = Color.fromARGB(255, 250, 183, 167);
        } else {
          visible1 = true;
          co1 = Color.fromARGB(255, 199, 243, 174);
        }
      }
      if (option == 2) {
        if (visible2 == true) {
          visible2 = false;
          co2 = Color.fromARGB(255, 250, 183, 167);
        } else {
          visible2 = true;
          co2 = Color.fromARGB(255, 199, 243, 174);
        }
      }
      if (option == 3) {
        if (visible3 == true) {
          visible3 = false;
          co3 = Color.fromARGB(255, 250, 183, 167);
        } else {
          visible3 = true;
          co3 = Color.fromARGB(255, 199, 243, 174);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Visibility(
              visible: visible1,
              child: Container(
                margin: const EdgeInsets.fromLTRB(60, 30, 60, 10),
                alignment: Alignment.center,
                child: StreamBuilder(
                    stream: camera.subscription,
                    builder: (context2, AsyncSnapshot<dynamic> snapshot2) {
                      if (snapshot2.hasData) {
                        return getImagenBase64(snapshot2.data['msg']['data']);
                      } else {
                        return const CircularProgressIndicator();
                      }
                    }),
              )),
          Visibility(
              visible: visible2,
              child: Column(children: [
                Container(
                  height: 30,
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.1),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFF04589A),
                      width: 5,
                    ),
                  ),
                  child: HoldDetector(
                    onTap: changeColor,
                    onHold: moveForward,
                    onCancel: stop,
                    enableHapticFeedback: true,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(c1)),
                      onPressed: () {},
                      child: const Icon(
                        Icons.arrow_circle_up,
                        size: 50,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width / 2,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFF04589A),
                            width: 5,
                          ),
                        ),
                        child: HoldDetector(
                          onHold: turnLeft,
                          onCancel: stop,
                          enableHapticFeedback: true,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(c2)),
                            onPressed: () {},
                            child: const Icon(
                              Icons.arrow_circle_left_outlined,
                              size: 50,
                            ),
                          ),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width / 2,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFF04589A),
                            width: 5,
                          ),
                        ),
                        child: HoldDetector(
                          onHold: turnRight,
                          onCancel: stop,
                          enableHapticFeedback: true,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(c3)),
                            onPressed: () {},
                            child: const Icon(
                              Icons.arrow_circle_right_outlined,
                              size: 50,
                            ),
                          ),
                        )),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.1),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFF04589A),
                      width: 5,
                    ),
                  ),
                  child: HoldDetector(
                    onHold: moveBackward,
                    onCancel: stop,
                    enableHapticFeedback: true,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(c4)),
                      onPressed: () {},
                      child: const Icon(
                        Icons.arrow_circle_down,
                        size: 50,
                      ),
                    ),
                  ),
                ),
              ])),
          Visibility(
            visible: visible3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 30,
                ),
                Container(
                  alignment: Alignment.center,
                  child: const Text(
                    "Velocidad Actual:",
                    style: TextStyle(fontSize: 20, color: Color(0xFF04589D)),
                  ),
                ),
                const SizedBox(
                  //Use of SizedBox
                  height: 10,
                ),
                Container(
                  color: Color.fromARGB(255, 185, 193, 199),
                  margin: const EdgeInsets.only(left: 40, right: 40),
                  alignment: Alignment.center,
                  child: Text(
                    forwardVelocity.toString().substring(0, 3),
                    style: TextStyle(fontSize: 20, color: Color(0xFF04589D)),
                  ),
                ),
                const SizedBox(
                  //Use of SizedBox
                  height: 20,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: velocityUp,
                        child: const Icon(
                          Icons.arrow_upward,
                          size: 40,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: velocityDown,
                        child: const Icon(
                          Icons.arrow_downward,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: visibleDesactivadoButton
            ? null
            : () => showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return AlertDialog(
                          title: const Text("Seleccione las funcionalidades:"),
                          actions: <Widget>[
                            Column(
                              children: [
                                Row(
                                  children: [
                                    HoldDetector(
                                      onHold: () {},
                                      enableHapticFeedback: true,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(co1)),
                                        onPressed: () {
                                          setState(() {});

                                          changeValue(1);
                                        },
                                        child: const Icon(
                                          Icons.camera_alt,
                                          size: 100,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      //Use of SizedBox
                                      width: 10,
                                    ),
                                    HoldDetector(
                                      onHold: () {},
                                      enableHapticFeedback: true,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(co2)),
                                        onPressed: () {
                                          setState(() {});
                                          changeValue(2);
                                        },
                                        child: const Icon(
                                          Icons.wifi_protected_setup_rounded,
                                          size: 100,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  //Use of SizedBox
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    HoldDetector(
                                      onHold: () {},
                                      enableHapticFeedback: true,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(co3)),
                                        onPressed: () {
                                          setState(() {});
                                          changeValue(3);
                                        },
                                        child: const Icon(
                                          Icons.arrow_circle_down,
                                          size: 100,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      //Use of SizedBox
                                      width: 10,
                                    ),
                                  ],
                                ),
                                Container(
                                  //Use of SizedBox
                                  height: 10,
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Hecho"),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

Widget getImagenBase64(String imagen) {
  //print(imagen.substring(0, 200));

  var _imageBase64 = imagen;
  const Base64Codec base64 = Base64Codec();
  var bytes = base64.decode(_imageBase64);

  return Image.memory(
    bytes,
    gaplessPlayback: true,
    height: 480,
    width: 720,
    fit: BoxFit.fitWidth,
  );
}
