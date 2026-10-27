import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_projects/firebase_provider.dart';
import 'package:final_projects/note_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget{
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  var titleController = TextEditingController();
  var descController = TextEditingController();

  List<NoteModel> listNotes = [];
  List<String> listWeekDays = [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun",
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseProvider.fetchAllNotes(), builder: (_, snapshot){

            listNotes.clear();

            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator());
            }

            if(snapshot.hasError){
              return Center(child: Text(snapshot.error.toString()));
            }

            if(snapshot.hasData){

              for(QueryDocumentSnapshot<Map<String, dynamic>> eachNote in snapshot.data!.docs){
                listNotes.add(NoteModel.fromDoc(doc: eachNote.data()));

              }

              return listNotes.isNotEmpty ? ListView.builder(
                  itemCount: listNotes.length,
                  itemBuilder: (_, index){

                    var time = DateTime.fromMillisecondsSinceEpoch(listNotes[index].createdAt);
                    var createdAtDate = time.day;
                    var createdAtWeekDay = time.weekday;
                    var createdAtTime = '${time.hour}:${time.minute}';

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                onTap: (){

                                  titleController.text = listNotes[index].title;
                                  descController.text = listNotes[index].desc;

                                  showModalBottomSheet(context: context, builder: (_){
                                    return bottomSheetContent(isUpdate: true, mIndex:  index);
                                  });
                                },
                                leading: Container(
                                  width: 55,
                                  decoration: BoxDecoration(
                                      color: Colors.amber.shade200,
                                      borderRadius: BorderRadius.circular(11)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(listWeekDays[createdAtWeekDay-1]),
                                      Text(createdAtDate.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),

                                    ],
                                  ),
                                ),
                                title: Text(listNotes[index].title),
                                subtitle: Text(createdAtTime),
                                trailing: IconButton(
                                    onPressed: (){

                                  /*listNotes.removeAt(index);
                                  setState(() {

                                  });*/
                                  FirebaseProvider.deleteNote(listNotes[index]);

                                }, icon: Icon(Icons.delete, color: Colors.amber,)),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(listNotes[index].desc),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }) : Center(child: Text("No Notes Yet!", style: TextStyle(fontSize: 21),));
            }

            return Container();

      }),
      floatingActionButton: FloatingActionButton(
        onPressed: (){

          titleController.text = "";
          descController.text = "";

          showModalBottomSheet(
            isScrollControlled: true,
              context: context,
              builder: (_){
            return bottomSheetContent();
          });
        },
        child: Icon(CupertinoIcons.pen),),
    );

  }

  Widget bottomSheetContent({bool isUpdate = false, int mIndex = -1}){
    return Container(
      height: MediaQuery.of(context).size.height*0.5+MediaQuery.of(context).viewInsets.bottom,
      padding: EdgeInsets.only(top: 11, left: 11, right: 11, bottom: 11+MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(
                hint: Text("Enter title here.."),
                label: Text("Title"),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11)
                )
            ),
          ),
          SizedBox(height: 11,),
          TextField(
            controller: descController,
            minLines: 4,
            maxLines: 7,
            decoration: InputDecoration(
                hint: Text("Enter desc here.."),
                label: Text("Desc"),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11)
                )
            ),
          ),
          SizedBox(height: 11,),
          Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(onPressed: (){
                    var mNote = NoteModel(
                      noteId: listNotes[mIndex].noteId,
                        title: titleController.text,
                        desc: descController.text,
                        createdAt: DateTime.now().millisecondsSinceEpoch
                    );


                    if(!isUpdate){
                      FirebaseProvider.addNote(mNote);

                      //listNotes.add(mNote);
                    } else {
                      FirebaseProvider.updateNote(mNote);

                      //listNotes[mIndex] = mNote;
                    }

                    /*setState(() {

                    });*/

                    Navigator.pop(context);
                  }, child: Text( !isUpdate ? "Add" : "Update")),

                  SizedBox(width: 11,),


                  ElevatedButton(onPressed: (){
                    Navigator.pop(context);
                  }, child: Text("Cancel")),
                ])

          ]
      ),
    );
  }

}