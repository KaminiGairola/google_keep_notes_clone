import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_keep_note_clone/services/login_info.dart';
import 'package:google_keep_note_clone/searchPage.dart';
import 'package:google_keep_note_clone/services/db.dart';
import 'package:google_keep_note_clone/sideMenuBar.dart';
import 'colors.dart';
import 'createNoteView.dart';
import 'model/myNoteModel.dart';
import 'noteView.dart';

class home extends StatefulWidget {
  const home({Key? key});

  @override
  State<home> createState() => _HomeState();

}

class _HomeState extends State<home> {
  late String? imageUrl;
  bool isLoading = true;
  List<Note> activeNotes = [];
  List<Note> archivedNotes = [];
  bool isStaggered= true;
  bool isSync=false;
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  Future createEntry(Note note) async {
    await NotesDatabase.instance.InsertEntry(note);
  }


  Future getAllNotes() async {
    LocalDataSaver.getImg().then((value) {
      if (this.mounted) {
        imageUrl = value;
      }
    });
    final List<Note> allNotes = await NotesDatabase.instance.readAllNotes();
    setState(() {
      activeNotes = allNotes.where((note) => !note.isArchive).toList();
      archivedNotes = allNotes.where((note) => note.isArchive).toList();
    });
    if (this.mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future getOneNote(int id) async {
    await NotesDatabase.instance.readOneNote(id);
  }

  Future updateOneNote(Note note) async {
    await NotesDatabase.instance.updateNote(note);
  }
  Future deleteNote(Note note) async {
    await NotesDatabase.instance.deleteNote(note);
  }

  Future archiveNoteById(int id) async {
    await NotesDatabase.instance.archiveNoteById(id);

    // Call the callback to notify the home page
    getAllNotes();
  }

   Future<void> getSyncState() async {
    final bool? syncState = await LocalDataSaver.getSyncSet();
    if (syncState != null) {
      setState(() {
        isSync = syncState;
      });
    }
  }

  //Updating Note List Ui when the note is going to the archive page and from archive page
  void updateNotesList(Note note) {
    setState(() {
      if (note.isArchive) {
        activeNotes.removeWhere((element) => element.id == note.id);
        archivedNotes.add(note);
      } else {
        archivedNotes.removeWhere((element) => element.id == note.id);
        activeNotes.add(note);
      }
    });
  }


  @override
  void initState() {
    getAllNotes();
    // LocalDataSaver.saveSyncSet(false);
    getSyncState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: CircularProgressIndicator(
          color: white,
        ),
      ),
    )
        : Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const createNoteView()));
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        backgroundColor: bgColor,
        elevation: 1,
        foregroundColor: white,
        child: const Icon(
          Icons.add,
          size: 40,
        ),
      ),
      endDrawerEnableOpenDragGesture: true,
      key: _drawerKey,
      drawer: const sideMenuBar(),
      backgroundColor: bgColor,
      body: RefreshIndicator(
        onRefresh: () => Future.delayed(Duration(seconds: 1)),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    //Search container
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 3)
                      ],
                      borderRadius: BorderRadius.circular(10),
                      color: cardColor,
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                _drawerKey.currentState!.openDrawer();
                              },
                              child: Icon(
                                Icons.menu,
                                color: white,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const searchPage()));
                              },
                              child: Container(
                                height: 50,
                                width: 200,
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Search Your Notes",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: white.withOpacity(0.5)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        //second Row
                        Container(
                          padding: const EdgeInsets.only(right: 5),
                          child: Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    isStaggered=!isStaggered;
                                  });
                                },
                                child: Icon(
                                  Icons.grid_view,
                                  color: white,
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              CircleAvatar(
                                onBackgroundImageError: (object,StackTrace){
                                  print("ok");
                                },
                                radius: 19,
                                backgroundImage: NetworkImage(
                                  imageUrl.toString(),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  isStaggered?
                  noteSectionAll():
                  noteListSection(),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget noteSectionAll() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Column(
            children: [
              Text(
                "All",
                style: TextStyle(
                    color: white.withOpacity(0.5),
                    fontSize: 13,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: MasonryGridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemCount: activeNotes.length,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            shrinkWrap: true,
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            noteView(note: activeNotes[index])));
              },
              child: Container(
                padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: white.withOpacity(0.4),
                    ),
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activeNotes[index].title,
                      style: TextStyle(
                          color: white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      activeNotes[index].content.length > 250
                          ? "${activeNotes[index].content.substring(0, 250)}....."
                          : activeNotes[index].content,
                      style: TextStyle(color: white, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }


  Widget noteListSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Column(
            children: [
              Text(
                "All",
                style: TextStyle(
                    color: white.withOpacity(0.5),
                    fontSize: 13,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activeNotes.length,
            shrinkWrap: true,
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            noteView(note: activeNotes[index])));
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 15),
                padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: white.withOpacity(0.4),
                    ),
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activeNotes[index].title,
                      style: TextStyle(
                          color: white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      activeNotes[index].content.length > 250
                          ? "${activeNotes[index].content.substring(0, 250)}....."
                          : activeNotes[index].content,
                      style: TextStyle(color: white, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
