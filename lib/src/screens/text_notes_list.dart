import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:ioesolutions/src/classes/note_types.dart';
import 'package:ioesolutions/src/screens/text_note_content.dart';

import '../helper_functions.dart';
class TextNotesList extends StatelessWidget {
  final String subject_name;
  final notes;
  TextNotesList({Key key,this.subject_name,this.notes}) : super(key: key);
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
                      title: Text("CHAPTERS",style: TextStyle(fontSize: 27),),
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
                      return Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => TextNoteContent(
                              chapter_name: notes[index]["chapter_name"],
                              chapter_content: notes[index]["content"],
                        )));
              },
              leading : Container(
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
              title: Text(notes[index]["chapter_name"]),
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

