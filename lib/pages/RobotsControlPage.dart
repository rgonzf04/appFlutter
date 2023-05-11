import 'package:flutter/material.dart';
import 'package:roslibdart/roslibdart.dart';
import 'dart:async';

class RobotsControlPage extends StatelessWidget {
  const RobotsControlPage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    String title = 'PS Pad';
    return MaterialApp(
      title: title,
      home: RoslibPSPad(title: title),
    );
  }
}

class RoslibPSPad extends StatefulWidget {
  const RoslibPSPad({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<RoslibPSPad> createState() => _RoslibPSPadState();
}

class _RoslibPSPadState extends State<RoslibPSPad> {
  String host = 'ws://127.0.0.1:9090';
  late Ros ros;
  late Topic cmdVelTopic;

  double turnAngularVelocity = 1.5;
  double forwardVelocity = 1.5;

  @override
  void initState() {
    //TOPIC MOVIMIENTO

    ros = Ros(url: host);
    cmdVelTopic = Topic(
        ros: ros,
        name: '/turtle1/cmd_vel',
        type: "geometry_msgs/msg/Twist",
        reconnectOnClose: true,
        queueLength: 10,
        queueSize: 10);

    ros.connect();
    super.initState();
  }

  String msgReceived = '';
  var lastDirectionTwist = {};

  void moveForward() {
    var linear = {'x': forwardVelocity, 'y': 0.0, 'z': 0.0};
    var angular = {'x': 0.0, 'y': 0.0, 'z': 0};

    var twist = {'linear': linear, 'angular': angular};

    cmdVelTopic.publish(twist);
    lastDirectionTwist = twist;
  }

  void moveBackward() {
    var linear = {'x': -forwardVelocity, 'y': 0.0, 'z': 0.0};
    var angular = {'x': 0.0, 'y': 0.0, 'z': 0};

    var twist = {'linear': linear, 'angular': angular};

    cmdVelTopic.publish(twist);
    lastDirectionTwist = twist;
  }

  void turnRight() {
    var linear = {'x': 0.0, 'y': 0.0, 'z': 0.0};
    var angular = {'x': 0.0, 'y': 0.0, 'z': -turnAngularVelocity};

    var twist = {'linear': linear, 'angular': angular};

    cmdVelTopic.publish(twist);
    lastDirectionTwist = twist;
  }

  void turnLeft() {
    var linear = {'x': 0.0, 'y': 0.0, 'z': 0.0};
    var angular = {'x': 0.0, 'y': 0.0, 'z': turnAngularVelocity};

    var twist = {'linear': linear, 'angular': angular};

    cmdVelTopic.publish(twist);
    lastDirectionTwist = twist;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Row(children: [
        Container(
            width: 300,
            height: 300,
            child: Column(children: [
              SizedBox(
                height: 100, //height of button
                width: double.infinity, //width of button equal to parent widget
                child: ElevatedButton(
                  onPressed: moveForward,
                  child: const Icon(
                    Icons.arrow_circle_up,
                    size: 50,
                  ),
                ),
              ),
              Container(
                width: 300,
                height: 100,
                child: Row(children: [
                  ElevatedButton(
                    onPressed: turnRight,
                    child: const Icon(
                      Icons.arrow_circle_left_outlined,
                      size: 50,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: turnLeft,
                    child: const Icon(
                      Icons.arrow_circle_right_outlined,
                      size: 50,
                    ),
                  ),
                ]),
              ),
              SizedBox(
                height: 100, //height of button
                width: double.infinity, //width of button equal to parent widget
                child: ElevatedButton(
                  onPressed: moveBackward,
                  child: const Icon(
                    Icons.arrow_circle_down,
                    size: 50,
                  ),
                ),
              ),
            ])),
      ]),
    );
  }
}
