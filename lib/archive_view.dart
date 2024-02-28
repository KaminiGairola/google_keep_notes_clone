import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_keep_note_clone/searchPage.dart';
import 'package:google_keep_note_clone/services/db.dart';
import 'package:google_keep_note_clone/sideMenuBar.dart';
import 'colors.dart';
import 'createNoteView.dart';
import 'model/myNoteModel.dart';
import 'noteView.dart';


class archiveView extends StatefulWidget {
  const archiveView({super.key});

  @override
  State<archiveView> createState() => _archiveViewState();
}

class _archiveViewState extends State<archiveView> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  late List<Note> notesList;
  bool isLoading = true;

  Future getAllNotes() async {
    this.notesList = await NotesDatabase.instance.readAllArchiveNotes();

    if (this.mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  void initState() {
    getAllNotes();
    super.initState();
  }
    String note =
      "THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE THIS IS NOTE ";
  String note1 = "THIS IS NOTE THIS IS NOTE";
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
      backgroundColor: bgColor,
      body: const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    ):Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) =>  createNoteView()));
        },
        backgroundColor: cardColor,
        child: Icon(Icons.add, size: 45, color: white,),

      ),
      endDrawerEnableOpenDragGesture: true,
      key: _drawerKey,
      drawer: const sideMenuBar(),
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  width: MediaQuery.of(context).size.width,
                  height: 55,
                  decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                            color: black.withOpacity(0.2), spreadRadius: 1)
                      ]),
                  child: Row(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {
                                //_drawerKey.currentState!.openDrawer();
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.arrow_back_sharp,
                                color: white,
                              )),
                          const SizedBox(
                            width: 16,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const searchPage()));
                            },
                            // child: Container(
                            //   height: 55,
                            //   width: 200,
                            //   decoration: const BoxDecoration(
                            //       //border : Border.all(color: Colors.white)
                            //       ),
                            //   child: GestureDetector(
                            //     onTap: () {
                            //       Navigator.push(
                            //           context,
                            //           MaterialPageRoute(
                            //               builder: (context) =>
                            //                   const searchPage()));
                            //     },
                            child: Container(
                              height: 55,
                              width: MediaQuery.of(context).size.width/3,
                              child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Search your notes",
                                      style: TextStyle(
                                          color:
                                          white.withOpacity(0.5),
                                          fontSize: 16),
                                    )
                                  ]),
                            ),
                          ),
                          // Container(
                          //   height: 55,
                          //   width: 200,
                          //   decoration: const BoxDecoration(
                          //     //border : Border.all(color: Colors.white)
                          //   ),
                          //   child: Column(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //         Text(
                          //           "Search your notes",
                          //           style: TextStyle(
                          //               color: white.withOpacity(0.5),
                          //               fontSize: 16),
                          //         )
                          //       ]),
                          // )
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: const Row(
                          children: [
                            // TextButton(
                            //     style: ButtonStyle(
                            //         overlayColor:
                            //         MaterialStateColor.resolveWith(
                            //                 (states) => white.withOpacity(0.1)),
                            //         shape: MaterialStateProperty.all<
                            //             RoundedRectangleBorder>(
                            //             RoundedRectangleBorder(
                            //               borderRadius: BorderRadius.circular(50.0),
                            //             ))),
                            //     onPressed: () {},
                            //     child: Icon(
                            //       Icons.grid_view,
                            //       color: white,
                            //     )),
                            // SizedBox(
                            //   width: 9,
                            // ),
                            // CircleAvatar(
                            //   radius: 16,
                            //   backgroundColor: Colors.white,
                            // )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                noteSectionAll(),
                //notesListSection()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget noteSectionAll() {
    return Container(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "ALL",
                  style: TextStyle(
                      color: white.withOpacity(0.5),
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: MasonryGridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: notesList.length,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              shrinkWrap: true,
              gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => noteView(note: notesList[index],)));
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(color: white.withOpacity(0.4)),
                      borderRadius: BorderRadius.circular(7)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notesList[index].title,
                        style: TextStyle(
                            color: white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        notesList[index].content.length > 250
                            ? "${notesList[index].content.substring(0, 250)}...."
                            : notesList[index].content.toString(),
                        style: TextStyle(color: white),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget notesListSection() {
    return Container(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "LIST VIEW",
                  style: TextStyle(
                      color: white.withOpacity(0.5),
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 10,
              shrinkWrap: true,
              itemBuilder: (context, index) => Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: white.withOpacity(0.4)),
                    borderRadius: BorderRadius.circular(7)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "HEADING",
                      style: TextStyle(
                          color: white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      index.isEven
                          ? note.length > 250
                          ? "${note.substring(0, 250)}...."
                          : note
                          : note1,
                      style: TextStyle(color: white),
                    )
                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}

