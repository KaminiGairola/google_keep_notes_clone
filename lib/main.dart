import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_keep_note_clone/services/login_info.dart';
import 'package:google_keep_note_clone/login_screen.dart';
import 'package:google_keep_note_clone/firebase_options.dart';
import 'home.dart';

  void main()async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const MyApp());
  }
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLogin = false;

  getLoggedInState() async{
    await LocalDataSaver.getLogData().then((value){

      setState(() {
        isLogin = value.toString() == "null";
      });
    });
  }
  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: isLogin ? const LoginScreen(): const home(),
    );
  }

}


