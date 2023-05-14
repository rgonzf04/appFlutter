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

  double turnAngularVelocity = 1.5;
  double forwardVelocity = 1.5;

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
    forwardVelocity = forwardVelocity + 10;
  }

  void velocityDown() {
    forwardVelocity = forwardVelocity - 0.1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Row(children: <Widget>[
          Expanded(
            flex: 4,
            child: Container(
              margin: const EdgeInsets.all(100),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Expanded(
                      flex: 4,
                      child: Container(
                        height: double.infinity,
                        width: double.infinity,
                        child: HoldDetector(
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
                      )),
                  Expanded(
                      flex: 4,
                      child: Row(
                        children: [
                          Expanded(
                              flex: 5,
                              child: SizedBox(
                                height: double.infinity,
                                width: double.infinity,
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
                                ),
                              )),
                          Expanded(
                              flex: 5,
                              child: SizedBox(
                                height: double.infinity,
                                width: double.infinity,
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
                                ),
                              )),
                        ],
                      )),
                  Expanded(
                      flex: 4,
                      child: SizedBox(
                        height: double.infinity,
                        width: double.infinity,
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
                      )),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
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
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text("Velocidad Actual:" + forwardVelocity.toString()),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: velocityUp,
                        child: const Icon(
                          Icons.plus_one,
                          size: 50,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: velocityDown,
                        child: const Icon(
                          Icons.motion_photos_auto,
                          size: 50,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]));
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
