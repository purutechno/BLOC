import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ioesolutions/src/presentation/my_flutter_app_icons.dart';

class Draw{
  String text;
  Icon icon;
  
  Draw({this.text,this.icon});
}

 

  List<Draw> drawers = [
  Draw(text : 'Update Contents', icon: Icon(Icons.update,color : Color(0xff860000),size: 20,),),
  Draw(text : 'Downloads', icon: Icon(Icons.file_download,color : Color(0xff860000),size: 20,),),
  Draw(text : 'Send Us Message', icon: Icon(Icons.send,color : Color(0xff860000),size: 20,),),
  Draw(text : 'Share App', icon : Icon(Icons.share,color : Color(0xff860000),size: 20,),),
  Draw(text : 'Rate Us', icon : Icon(MyFlutterApp.shapes_and_symbols,color : Color(0xff860000),size: 20,),),
  Draw(text : 'About' , icon : Icon(Icons.info,color : Color(0xff860000),size: 20,),),
  Draw(text : 'Privacy Policy', icon : Icon(Icons.lock,color : Color(0xff860000),size: 20,),),
  Draw(text: 'Find Us On Facebook', icon: Icon(MyFlutterApp.facebook, color: Colors.blue[900],size: 20, ),),
   
];
