import 'dart:async';

import 'package:flutter/material.dart';
import 'package:roslibdart/roslibdart.dart';
import 'dart:convert';
import 'package:holding_gesture/holding_gesture.dart';

class RobotsControlPage extends StatelessWidget {
  const RobotsControlPage({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    String title = 'Control Screen';
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

  @override
  void initState() {
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

  bool visible1 = true;
  bool visible2 = true;
  bool visible3 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Visibility(
                    visible: visible1,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(60, 30, 60, 10),
                      alignment: Alignment.center,
                      child: StreamBuilder(
                          stream: camera.subscription,
                          builder:
                              (context2, AsyncSnapshot<dynamic> snapshot2) {
                            if (snapshot2.hasData) {
                              return getImagenBase64(
                                  snapshot2.data['msg']['data']);
                            } else {
                              return const CircularProgressIndicator();
                            }
                          }),
                    ));
              },
              childCount: 1,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Visibility(
                    visible: visible2,
                    child: Column(children: [
                      Container(
                        height: 30,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.1),
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
                                      backgroundColor:
                                          MaterialStateProperty.all(c2)),
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
                                      backgroundColor:
                                          MaterialStateProperty.all(c3)),
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
                            horizontal:
                                MediaQuery.of(context).size.width * 0.1),
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
                    ]));
              },
              childCount: 1,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Visibility(
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
                          style:
                              TextStyle(fontSize: 20, color: Color(0xFF04589D)),
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
                          style:
                              TextStyle(fontSize: 20, color: Color(0xFF04589D)),
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
                );
              },
              childCount: 1,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => SimpleDialog(
            title: const Text(
              'Selecciona las opciones:',
              style: TextStyle(height: 1, fontSize: 25),
            ),
            children: <Widget>[
              const SimpleDialogOption(
                onPressed: null,
                child: Text(
                  'Mostrar Camara',
                  style: TextStyle(height: 1, fontSize: 15),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  setState(() {
                    visible1 = true;
                  });
                },
                child: const Text('SI'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  setState(() {
                    visible1 = false;
                  });
                },
                child: const Text('NO'),
              ),
              const SimpleDialogOption(
                onPressed: null,
                child: Text(
                  'Mostrar Control Movimiento',
                  style: TextStyle(height: 1, fontSize: 15),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  setState(() {
                    visible2 = true;
                  });
                },
                child: const Text('SI'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  setState(() {
                    visible2 = false;
                  });
                },
                child: const Text('NO'),
              ),
              const SimpleDialogOption(
                onPressed: null,
                child: Text(
                  'Mostrar Velocidad',
                  style: TextStyle(height: 1, fontSize: 15),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  setState(() {
                    visible3 = true;
                  });
                },
                child: const Text('SI'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  setState(() {
                    visible3 = false;
                  });
                },
                child: const Text('NO'),
              ),
            ],
          ),
        ),
        tooltip: 'Increment Counter',
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
