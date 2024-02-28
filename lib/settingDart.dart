import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_keep_note_clone/login_screen.dart';
import 'package:google_keep_note_clone/services/login_info.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'colors.dart';

class setting extends StatefulWidget {
  const setting({super.key});

  @override
  State<setting> createState() => _settingState();
}

class _settingState extends State<setting> {
  late bool value;
  getSyncSet() async{
    LocalDataSaver.getSyncSet().then((valueFromDB){
      setState(() {
        value = valueFromDB!;
      });
    });
  }
  @override
  void initState() {
    getSyncSet();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: bgColor,
        elevation: 0.0,
        title: Text(
          "Settings",
          style: TextStyle(color: white),
        ),
        actions: [
          IconButton(onPressed: ()async{
            await GoogleSignIn().signOut();
            FirebaseAuth.instance.signOut();
            LocalDataSaver.saveLoginData(false);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
          }, icon: const Icon(Icons.power_settings_new))
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Sync",
                  style: TextStyle(color: white, fontSize: 18),
                ),
                Spacer(),
                Transform.scale(
                  scale: 1,
                  child: Switch.adaptive(
                      value: value,
                      onChanged: (switchValue) {
                        setState(() {
                          this.value = switchValue;
                          LocalDataSaver.saveSyncSet(switchValue);
                        });
                      }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
