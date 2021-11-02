import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

void main() async {
WidgetsFlutterBinding.ensureInitialized(); //
await Firebase.initializeApp(); //
FirebaseMessaging.onBackgroundMessage(_handleMessage);

runApp(MyApp());
}

Future<void> _handleMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
  
  print(message.notification!.body);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FirebaseMessaging messaging;

  @override
  void initState(){
    super.initState();
    messaging = FirebaseMessaging.instance;

    messaging.getToken().then((value) {
      print('token is: $value');
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage event) { 
      print('message is received');
      print('message is: ${event.notification!.body}');

      showDialog(context: context, builder: (BuildContext context){
        return AlertDialog(
          title: Text('Notification from Firebase!'),
          content: Text(event.notification!.body!),
          actions: [
            TextButton(onPressed: (){
              Navigator.of(context).pop();
            }, child: Text('OK'))
          ],
        );
      });
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print('Notification is clicked');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.teal.shade300,
                  Colors.blue.shade700,
                ],
              )
          ),) // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
