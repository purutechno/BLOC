import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoteType{
  String text;
  Icon icon;
  
  NoteType({this.text,this.icon});
}



  List<NoteType> noteTypes = [
  NoteType(text : 'PDF Files', icon: Icon(Icons.picture_as_pdf,color : Color(0xff860000),size: 20,),),
  NoteType(text : 'Text Note', icon : Icon(Icons.insert_drive_file,color : Color(0xff860000),size: 20,),),
   
];
