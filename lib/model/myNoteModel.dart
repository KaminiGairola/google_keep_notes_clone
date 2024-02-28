
class NotesImpName{
  // static becoz bina obj ke access kr ske
  static final String id = "id";
  static final String pin = "pin";
  static final String title = "title";
  static final String content = "content";
  static final String isArchive = "isArchive";
  static final String createdTime = "createdTime";
  static final String TableName = "Notes";

  static final List<String> values = [id, pin, isArchive, title, content, createdTime];

}
class Note{
  final int? id;
  final bool pin;
  final bool isArchive;
  final String title;
  final String content;
  final DateTime createdTime;

  const Note({
    this.id,
    required this.pin,
    required this.isArchive,
    required this.title,
    required this.content,
    required this.createdTime
  }
      );



  Note copy({
    int? id,
    bool? pin,
    bool? isArchive,
    String? title,
    String? content,
    DateTime? createdTime
  }){
    return Note(id : id?? this.id,
        pin : pin?? this.pin,
        isArchive : isArchive?? this.isArchive,
        title : title?? this.title,
        content : content?? this.content,
        createdTime : createdTime?? this.createdTime);
  }

  // Converts json data to map data
  static Note fromJson(Map<String, Object?> json){
    return Note(id: json[NotesImpName.id] as int?,
        pin: json[NotesImpName.pin] == 1,
        isArchive : json[NotesImpName.isArchive] ==1,
        title: json[NotesImpName.title] as String,
        content: json[NotesImpName.content] as String,
        createdTime: DateTime.parse(json[NotesImpName.createdTime] as String));
  }
  // Converts map to json
  Map<String,Object?> toJson(){
    return{
      NotesImpName.id : id,
      NotesImpName.pin : pin? 1 : 0,
      NotesImpName.isArchive : isArchive? 1 :0,
      NotesImpName.title : title,
      NotesImpName.content : content,
      NotesImpName.createdTime : createdTime.toIso8601String()
    };
  }
}