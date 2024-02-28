import 'package:flutter/material.dart';
import 'package:google_keep_note_clone/services/db.dart';

import 'colors.dart';
import 'model/myNoteModel.dart';
import 'noteView.dart';

class editNoteView extends StatefulWidget {
  Note note;
  editNoteView({required this.note});

  @override
  State<editNoteView> createState() => _editNoteViewState();
}

class _editNoteViewState extends State<editNoteView> {

  late String newTitle;
  late String newNoteDet;

  @override
  void initState() {
    this.newTitle = widget.note.title.toString();
    this.newNoteDet = widget.note.content.toString();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        backgroundColor: bgColor,
        elevation: 0.0,
        actions: [
          IconButton(splashRadius : 17, onPressed: () async{
            Note newNote = Note(content: newNoteDet, title: newTitle, createdTime: widget.note.createdTime, pin: widget.note.pin, isArchive : widget.note.isArchive, id: widget.note.id);
            await NotesDatabase.instance.updateNote(newNote);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => noteView(note: newNote,)));
          }, icon: Icon(Icons.save_outlined, color: white,))
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            // Form is a kind of widget in which there are many text forms field. it is used becoz in this we have text form where we can fill or add initial value
            Form(child:
            TextFormField(
              initialValue: newTitle,
              cursorColor: white,
              onChanged: (value){
                newTitle = value;
              },
              style: TextStyle(fontSize: 25, color: Colors.white,fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: "Title",
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.withOpacity(0.8)
                  )
              ),
            ),
            ),

            Container(
                height: 300,
                child:
                Form(
                  child: TextFormField(
                    onChanged: (value){
                      newNoteDet = value;
                    },
                    initialValue: newNoteDet,
                    keyboardType: TextInputType.multiline,
                    minLines: 50,
                    maxLines: null,
                    cursorColor: white,

                    style: TextStyle(fontSize: 17, color: Colors.white),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintText: "Note",
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.withOpacity(0.8)
                      ),

                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
