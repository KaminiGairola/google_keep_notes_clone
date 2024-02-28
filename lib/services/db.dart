import 'package:google_keep_note_clone/model/myNoteModel.dart';
import 'package:google_keep_note_clone/services/firestore.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class NotesDatabase {


  static final NotesDatabase instance = (NotesDatabase._init());
  static Database? _database;

  NotesDatabase._init();

  Future<Database?> get database async {
    // if (_database != null) return _database;
    // _database = await _initializeDB('Notes.db');
    if(_database != null) return _database;
    _database = await _initializeDB('NewNotes.db');
    return _database;
  }

  Future<Database> _initializeDB(String filepath) async {
    final dbpath = await getDatabasesPath();
    final path = join(dbpath, filepath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // oncreate - table raw db raw sql yhn run kraenge
  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final boolType = 'BOOLEAN NOT NULL';
    final textType = 'TEXT NOT NULL';
    await db.execute('''
    CREATE TABLE Notes(
    ${NotesImpName.id} $idType,
    ${NotesImpName.pin} $boolType,
    ${NotesImpName.isArchive} $boolType,
    ${NotesImpName.title} $textType,
    ${NotesImpName.content} $textType,
    ${NotesImpName.createdTime} $textType
     )
    ''');
  }

// Insert note
  Future<Note?> InsertEntry(Note note) async {
    final db = await instance.database;
    final id = await db!.insert(NotesImpName.TableName, note.toJson());
    await FireDB().createNewNoteFirestore(note,id.toString());
    return note.copy(id: id);
  }

  //Read all notes
  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;
    final orderBy = '${NotesImpName.createdTime} ASC';
    final query_result = await db!.query(
        NotesImpName.TableName, orderBy: orderBy);
    return query_result.map((json) => Note.fromJson(json)).toList();
  }

  Future<List<Note>> readAllArchiveNotes() async {
    final db = await instance.database;
    final orderBy = '${NotesImpName.createdTime} ASC';
    final query_result = await db!.query(
        NotesImpName.TableName, orderBy: orderBy, where: '${NotesImpName.isArchive} = 1' );
    return query_result.map((json) => Note.fromJson(json)).toList();
  }

  // To read specific note
  Future<Note?> readOneNote(int id) async {
    final db = await instance.database;
    final map = await db!.query(NotesImpName.TableName,
        columns: NotesImpName.values,
        // Sql injection prob occurs in this where: 'id = 5'
        where: '${NotesImpName.id} = ?',
        whereArgs: [id]

    );
    if (map.isNotEmpty) {
      return Note.fromJson(map.first);
    }
    else {
      return null;
    }
  }

  // Update note
  Future updateNote(Note note) async {
     await FireDB().updateNoteFirestore(note);
    final db = await instance.database;
    await db!.update(
        NotesImpName.TableName, note.toJson(), where: '${NotesImpName.id} = ?',
        whereArgs: [note.id]);
  }

  Future pinNote(Note note) async {
    final db = await instance.database;
    await db!.update(
        NotesImpName.TableName, {NotesImpName.pin : !note.pin ? 1 : 0}, where: '${NotesImpName.id} = ?',
        whereArgs: [note.id]);
  }

  Future isArchive(Note note) async {
    final db = await instance.database;
    await db!.update(
        NotesImpName.TableName, {NotesImpName.isArchive : !note.isArchive ? 1 : 0}, where: '${NotesImpName.id} = ?',
        whereArgs: [note.id]);
  }

  // Delete note
  Future deleteNote(Note note) async{
     await FireDB().deleteNoteFirestore(note);
    final db = await instance.database;
    await db!.delete(NotesImpName.TableName , where: '${NotesImpName.id} = ?', whereArgs: [note.id] );

    //await NotesDatabase.instance.deleteNote(3);
  }


  Future<void> archiveNoteById(int id) async {
    // Open the database
    final db = await instance.database;

    // Update the note's status to 'archived'
    await db!.update(
      'notes',
      {'status': 'archived'},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  Future closeDB() async{
    final db = await instance.database;
    db!.close();
  }
  Future<List<int>> getNoteString(String query) async {
    final db = await instance.database;
    final result = await db!.query(NotesImpName.TableName);
    List<int> resultIds = [];
    result.forEach((element) {
      if (element["title"].toString().toLowerCase().contains(query) ||
          element["content"].toString().toLowerCase().contains(query)) {
        resultIds.add(element["id"] as int);
      }
    });
    return resultIds;
  }
}
