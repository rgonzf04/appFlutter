import 'package:flutter/material.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      appBar: AppBar(
        title: const Text("Help Screen"),
      ),
      body: Center(
        child: Column(children: [
          Container(
            //Use of SizedBox
            height: 20,
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, "/menu");
            },
            child: const Text('Volver al menu', style: TextStyle(fontSize: 20)),
          ),
          Container(
            //Use of SizedBox
            height: 20,
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
            child: Text("¿Quieres añadir funcionaldiades?",
                style: TextStyle(fontSize: 20)),
          ),
        ]),
      ),
    );
  }
}
