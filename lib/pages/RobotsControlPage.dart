import 'dart:async';
import 'dart:io';

import 'package:app/pages/MenuPage.dart';
import 'package:flutter/material.dart';
import 'package:roslibdart/roslibdart.dart';
import 'dart:convert';
import 'package:holding_gesture/holding_gesture.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';

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
  late Topic description;

  double turnAngularVelocity = 0.5;
  double forwardVelocity = 0.1;

  //Variables visibilidad dialogo
  bool visible1 = true;
  bool visible2 = true;
  bool visible3 = true;
  bool visible4 = false;
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
      visible4 = false;
      visibleDesactivadoButton = true;
      co1 = Color.fromARGB(255, 199, 243, 174);
      co2 = Color.fromARGB(255, 199, 243, 174);
      co3 = Color.fromARGB(255, 199, 243, 174);
    } else if (visibility == "B") {
      visible1 = false;
      visible2 = false;
      visible3 = false;
      visible4 = false;
      visibleDesactivadoButton = false;
      co1 = Color.fromARGB(255, 250, 183, 167);
      co2 = Color.fromARGB(255, 250, 183, 167);
      co3 = Color.fromARGB(255, 250, 183, 167);
    } else if (visibility == "C") {
      visible1 = true;
      visible2 = false;
      visible3 = false;
      visible4 = true;
      visibleDesactivadoButton = true;
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

    //TOPIC DEESCRIPTION

    description = Topic(
      ros: ros,
      name: '/robot_description',
      type: "std_msgs/msg/String",
      queueSize: 10,
      queueLength: 10,
    );

    Timer(const Duration(seconds: 1), () async {
      await camera.subscribe(subscribeHandler);
      // await chatter.subscribe();
    });

    Timer(const Duration(seconds: 1), () async {
      await description.subscribe(subscribeHandler2);
      // await chatter.subscribe();
    });

    ros.connect();
    super.initState();
  }

  @override
  void dispose() {
    // Limpia el controlador cuando el Widget se descarte
    controllerlx.dispose();
    controllerly.dispose();
    controllerlz.dispose();
    controllerax.dispose();
    controlleray.dispose();
    controlleraz.dispose();
    super.dispose();
  }

  Color c1 = Color.fromARGB(255, 56, 158, 241);
  Color c2 = Color.fromARGB(255, 56, 158, 241);
  Color c3 = Color.fromARGB(255, 56, 158, 241);
  Color c4 = Color.fromARGB(255, 56, 158, 241);

  Future<void> subscribeHandler(Map<String, dynamic> msg) async {
    //print(msg);
    setState(() {});
  }

  String msgReceived = '';
  String robotDescription1 = "No value";
  String robotDescription2 = "No value";

  Future<void> subscribeHandler2(Map<String, dynamic> msg) async {
    print("HOLA");
    msgReceived = json.encode(msg);
    String datos = msg['data'];

    //ROBOT NAME
    int inicio = datos.indexOf('robot name="') + 12;
    int fin = datos.indexOf('"', inicio);
    robotDescription1 = datos.substring(inicio, fin);

    //ROBOT NAME
    inicio = datos.indexOf('limit effort=') + 13;
    fin = datos.indexOf('>', inicio);
    robotDescription2 = datos.substring(inicio, fin);

    setState(() {});
  }

  void destroyConnection() async {
    await camera.unsubscribe();
    await description.unsubscribe();
    await ros.close();
    setState(() {});
  }

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
  }

  void moveForward() {
    c1 = Color.fromARGB(255, 187, 93, 87);
    var linear = {'x': forwardVelocity, 'y': 0.0, 'z': 0.0};
    var angular = {'x': 0.0, 'y': 0.0, 'z': 0};

    var twist = {'linear': linear, 'angular': angular};

    //print('Direction to published ' + jsonEncode(twist));
    cmdVelTopic.publish(twist);
  }

  void moveBackward() {
    c4 = Color.fromARGB(255, 187, 93, 87);
    var linear = {'x': -forwardVelocity, 'y': 0.0, 'z': 0.0};
    var angular = {'x': 0.0, 'y': 0.0, 'z': 0};

    var twist = {'linear': linear, 'angular': angular};

    cmdVelTopic.publish(twist);
  }

  void turnRight() {
    c3 = Color.fromARGB(255, 187, 93, 87);
    var linear = {'x': forwardVelocity, 'y': 0.0, 'z': 0.0};
    var angular = {'x': 0.0, 'y': 0.0, 'z': -turnAngularVelocity};

    var twist = {'linear': linear, 'angular': angular};

    cmdVelTopic.publish(twist);
  }

  void turnLeft() {
    c2 = Color.fromARGB(255, 187, 93, 87);
    var linear = {'x': forwardVelocity, 'y': 0.0, 'z': 0.0};
    var angular = {'x': 0.0, 'y': 0.0, 'z': turnAngularVelocity};

    var twist = {'linear': linear, 'angular': angular};

    cmdVelTopic.publish(twist);
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

  void technicalMove(String linearx, String lineary, String linearz,
      String angularx, String angulary, String angularz) {
    if (double.tryParse(linearx) != null &&
        double.tryParse(lineary) != null &&
        double.tryParse(linearz) != null &&
        double.tryParse(angularx) != null &&
        double.tryParse(angulary) != null &&
        double.tryParse(angularz) != null) {
      var linear = {
        'x': double.parse(linearx),
        'y': double.parse(lineary),
        'z': double.parse(linearz)
      };
      var angular = {
        'x': double.parse(angularx),
        'y': double.parse(angulary),
        'z': double.parse(angularz)
      };

      var twist = {'linear': linear, 'angular': angular};

      //print("Velocidad: $twist");
      cmdVelTopic.publish(twist);
    } else {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Exception'),
          content: const Text('The value of the fields must be double'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  final controllerlx = TextEditingController();
  final controllerly = TextEditingController();
  final controllerlz = TextEditingController();
  final controllerax = TextEditingController();
  final controlleray = TextEditingController();
  final controlleraz = TextEditingController();

  String salidaComando = "";

  final pages = [
    PageViewModel(
      pageColor: Color(0xFF03A9F4),
      // iconImageAssetPath: 'assets/air-hostess.png',
      //bubble: Image.asset('assets/air-hostess.png'),
      body: Text(
        'En primer lugar debes localizar el nombre y tipo del Topic, para ello existen diversas formas como el software rqt o el comadno "ros2 topic list -t"',
      ),
      mainImage: Image.asset(
        'tutorial1.png',
        height: 385.0,
        width: 385.0,
        alignment: Alignment.center,
      ),
      title: Text(
        'Localizar el topic',
      ),
      titleTextStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
      bodyTextStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
    ),
    PageViewModel(
      pageColor: Color.fromARGB(255, 60, 192, 253),
      // iconImageAssetPath: 'assets/air-hostess.png',
      //bubble: Image.asset('assets/air-hostess.png'),
      body: Text(
        'Con el uso de la librería roslibdart crearemos un objeto de tipo Topic especificando su nombre y tipo.',
      ),
      mainImage: Image.asset(
        'tutorial2.png',
        height: 385.0,
        width: 385.0,
        alignment: Alignment.center,
      ),
      title: Text(
        'Crear objeto',
      ),
      titleTextStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
      bodyTextStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
    ),
    PageViewModel(
      pageColor: Color.fromARGB(255, 118, 204, 245),
      // iconImageAssetPath: 'assets/air-hostess.png',
      //bubble: Image.asset('assets/air-hostess.png'),
      body: Text(
        'Por último nuevamente gracias a la librería roslibdart podremos suscribirnos al Topic y obetener su información.',
      ),
      mainImage: Image.asset(
        'tutorial3.png',
        height: 385.0,
        width: 385.0,
        alignment: Alignment.center,
      ),
      title: Text(
        'Obtener información del topic',
      ),
      titleTextStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
      bodyTextStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            alignment: Alignment.center,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(20.0),
                textStyle: const TextStyle(fontSize: 30),
              ),
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Robot Information'),
                  content: Text('Robots name: $robotDescription1'
                      '\n'
                      'Robots features: $robotDescription2'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ),
              child: const Text('-> Robot Information <-'),
            ),
          ),
          Visibility(
              visible: visible1,
              child: Container(
                margin: const EdgeInsets.fromLTRB(25, 0, 25, 10),
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
          Visibility(
              visible: visible4,
              child: Container(
                  margin: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      const Text(
                        'Linear velocity',
                      ),
                      TextFormField(
                        controller: controllerlx,
                        decoration: const InputDecoration(
                          labelText: 'eje x',
                        ),
                      ),
                      TextFormField(
                          controller: controllerly,
                          decoration: const InputDecoration(
                            labelText: 'eje y',
                          )),
                      TextFormField(
                          controller: controllerlz,
                          decoration: const InputDecoration(
                            labelText: 'eje z',
                          )),
                      const Text(
                        'Angular velocity',
                      ),
                      TextFormField(
                          controller: controllerax,
                          decoration: const InputDecoration(
                            labelText: 'eje x',
                          )),
                      TextFormField(
                          controller: controlleray,
                          decoration: const InputDecoration(
                            labelText: 'eje y',
                          )),
                      TextFormField(
                          controller: controlleraz,
                          decoration: const InputDecoration(
                            labelText: 'eje z',
                          )),
                      TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(5.0),
                            textStyle: const TextStyle(fontSize: 15),
                          ),
                          onPressed: () {
                            technicalMove(
                                controllerlx.text,
                                controllerly.text,
                                controllerlz.text,
                                controllerax.text,
                                controlleray.text,
                                controlleraz.text);
                          },
                          child: const Text("ACEPTAR"))
                    ],
                  ))),
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
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => IntroViewsFlutter(
                                          pages,
                                          doneText: Text("Finalizar"),
                                          onTapDoneButton: () {
                                            Navigator.pop(
                                                context); // Cerrar el tutorial cuando se hace clic en "Finalizar"
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  child:
                                      Text("¿Quieres añadir funcionaldiades?"),
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
    height: 320,
    width: 720,
    fit: BoxFit.fitWidth,
  );
}
