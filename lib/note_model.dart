class NoteModel {
  String? noteId;
  String title;
  String desc;
  int createdAt;

  NoteModel({
    required this.title,
    required this.desc,
    required this.createdAt,
    this.noteId
  });


  // from doc to model
  factory NoteModel.fromDoc({required Map<String, dynamic>doc}){
    return NoteModel(
      noteId: doc["noteId"],
        title: doc["title"],
        desc: doc["desc"],
        createdAt: doc["createdAt"]
    );
  }

  // from model to doc
Map<String, dynamic> toDoc() => {
  "title" : title,
  "desc" : desc,
  "createdAt" : createdAt,
  "noteId" : noteId
};



}