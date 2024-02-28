import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_keep_note_clone/archive_view.dart';
import 'package:google_keep_note_clone/services/db.dart';
import 'package:google_keep_note_clone/settingDart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'colors.dart';

class sideMenuBar extends StatefulWidget {
  const sideMenuBar({super.key});

  @override
  State<sideMenuBar> createState() => _sideMenuBarState();
}

class _sideMenuBarState extends State<sideMenuBar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(color: bgColor),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
                  child: Text(
                    "Google Keep",
                    style: TextStyle(
                        color: white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  )),
              Divider(
                color: white.withOpacity(0.3),
              ),
              sectionOne(),
              const SizedBox(height: 5,),
              sectionTwo(),
              const SizedBox(height: 5,),
              sectionSetting()
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionOne() {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: TextButton(
        style: ButtonStyle(
            backgroundColor:
            MaterialStateProperty.all(Colors.orangeAccent.withOpacity(0.3)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        bottomRight: Radius.circular(50))))),
        onPressed: () {},
        child: Container(
          padding: const EdgeInsets.all(5),
          child: Row(
            children: [
              Icon(
                Icons.lightbulb,
                size: 25,
                color: white.withOpacity(0.7),
              ),
              const SizedBox(
                width: 27,
              ),
              Text(
                "Notes",
                style: TextStyle(color: white.withOpacity(0.7), fontSize: 18),
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget sectionTwo() {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: TextButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        bottomRight: Radius.circular(50))))),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => archiveView()));
        },
        child: Container(
          padding: const EdgeInsets.all(5),
          child: Row(
            children: [
              Icon(
                Icons.archive_outlined,
                size: 25,
                color: white.withOpacity(0.7),
              ),
              const SizedBox(
                width: 27,
              ),
              Text(
                "Archive",
                style: TextStyle(color: white.withOpacity(0.7), fontSize: 18),
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget sectionSetting() {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: TextButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        bottomRight: Radius.circular(50))))),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => setting()));
        },
        child: Container(
          padding: const EdgeInsets.all(5),
          child: Row(
            children: [
              Icon(
                Icons.settings_outlined,
                size: 25,
                color: white.withOpacity(0.7),
              ),
              const SizedBox(
                width: 27,
              ),
              Text(
                "Settings",
                style: TextStyle(color: white.withOpacity(0.7), fontSize: 18),
              )
            ],
          ),
        ),
      ),
    );
  }

  }
