import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:ioesolutions/src/classes/note_types.dart';
import 'package:ioesolutions/src/screens/text_note_content.dart';

import '../helper_functions.dart';
class NoteFilesList extends StatelessWidget {
  final String subject_name;
  final String note_type;
  final notes;
  NoteFilesList({Key key,this.subject_name,this.note_type,this.notes}) : super(key: key);
  String _getFileName(filename)
  {
    if(filename.length>50)
    {
       String final_name = filename.substring(0,50);
       return final_name + " ...";
    }
    return filename;
  }
  String _getFileSize(sizeInBytes)
  {
    var filesize = (sizeInBytes/1000000).toStringAsFixed(2);
    return "Size: $filesize mb";
  }
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
     backgroundColor: Color(0xff860000),
      body: SafeArea(
        top: false,
        child: NestedScrollView(
          headerSliverBuilder:(BuildContext context,bool innerBoxIsScrolled){
              return <Widget>[
                  SliverAppBar(
                    iconTheme: IconThemeData(color: Colors.white),
                    expandedHeight: 100+screenHeight/14,
                    floating: true,
                    pinned: true,
                    elevation: 0.0,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(note_type=="text_note"?"CHAPTERS":"NOTES",style: TextStyle(fontSize: 27),),
                      // centerTitle: true,
                      collapseMode: CollapseMode.parallax,
                      background: Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 0,color: Colors.white),
                          color: Colors.white,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xff860000),
                            border: Border.all(
                              width: 2,color: Color(0xff860000)
                            ),
                          ),
                        ),
                      )
                    ),
                    backgroundColor: Color(0xff860000),
                  ),
              ];
          },
          body: Container(
          decoration: BoxDecoration(
         color: Colors.white,
         borderRadius: BorderRadius.only(
           topRight: Radius.circular(40.0),
           topLeft: Radius.circular(40.0),
         )),
          child: 
          ListView(
            physics: AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(30,10,20,10),
                child: Text("$subject_name",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
              ),
              Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(left: 30,right: 20),
                    child: SizedBox(
                      child: Container(
                        width: 120,
                      height: 3,
                      color: Color(0xff860000),
              ),
                    ),
                  ),
                ],
              ),
              ListView.separated(
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.fromLTRB(10.0, 27.0, 10.0, 10.0),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap:()
                    {
                      if(note_type == "text_note")
                      {
                        return Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => TextNoteContent(
                              chapter_name: notes[index]["chapter_name"],
                              chapter_content: notes[index]["content"],
                        )));
                      }
                      return Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => TextNoteContent(
                              chapter_name: notes[index]["chapter_name"],
                              chapter_content: notes[index]["content"],
                        )));
              },
              leading : note_type == "link_note"?Image(
              image: AssetImage("images/pdf_image.jpg"), 
              height: 50.0,
            ):Container(
                height: 34.0,
                width : 34.0,
                decoration: BoxDecoration(
                  borderRadius : BorderRadius.circular(17.0),
                  border: Border.all(color : Color(0xff860000)), 
                ),
              child : Align(
                child: Text(getDecimalToRoman(index+1)), 
                  ),
                ),
              title: note_type == "text_note"? Text(notes[index]["chapter_name"]):Text(_getFileName(notes[index]["filename"])),
              subtitle: note_type == "link_note"? Text(_getFileSize(notes[index]["file_size"])):null,
              trailing: PopupMenuButton(
            // onSelected: _downloadThisFile(notes[index]["file_id"]),
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: "hello",
                child: Column(
                  children: <Widget>[
                    Text(
                      "Update Contents",
                      style: TextStyle(fontSize: 14.0),
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.info,
                          size: 15.0,
                        ),
                        Text(
                          " This will update notes & old questions",
                          style: TextStyle(fontSize: 10.0),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
              // trailing: Icon(Icons.keyboard_arrow_right),
            );
      },
      separatorBuilder: (context, index) {
    return Divider();
  },
    ),
],
    ),
     ),
     ),
      ),  
    );
  }
}

