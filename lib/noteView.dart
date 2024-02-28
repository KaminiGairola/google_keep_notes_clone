import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_keep_note_clone/services/db.dart';

import 'colors.dart';
import 'editNoteView.dart';
import 'home.dart';
import 'model/myNoteModel.dart';

class noteView extends StatefulWidget {
  // noteView({super.key});
  Note note;
  noteView({required this.note});

  @override
  State<noteView> createState() => _noteViewState();
}

class _noteViewState extends State<noteView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: bgColor,
        elevation: 0.0,
        actions: [
          IconButton(
              splashRadius: 17,
               onPressed:
              () async{
                await NotesDatabase.instance.pinNote(widget.note);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => home()));
              },
              icon: Icon(widget.note.pin ? Icons.push_pin :
              Icons.push_pin_outlined,
                  color: white
              )),
          IconButton(
              splashRadius: 17,
              onPressed: () async{
                await NotesDatabase.instance.isArchive(widget.note);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => home()));

              },
              icon: Icon(widget.note.isArchive ? Icons.archive :
              Icons.archive_outlined,
                color: white,
              )),
          IconButton(
              splashRadius: 17,
              onPressed: () async{
                await NotesDatabase.instance.deleteNote(widget.note);

                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => home()));
              },
              icon: Icon(
                Icons.delete_forever_outlined,
                color: white,
              )),
          IconButton(
              splashRadius: 17,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => editNoteView(note: widget.note
                )));
              },
              icon: Icon(
                Icons.edit_outlined,
                color: white,
              ))
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Created On ${DateFormat('dd-MM-yyyy - kk:mm').format(widget.note.createdTime)}", style: TextStyle(color: Colors.white),),
              const SizedBox(height: 10,),
              Text(
                widget.note.title,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 23),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(widget.note.content, style: const TextStyle(color: Colors.white))
            ],
          ),
        ),
      ),
    );
  }
}
