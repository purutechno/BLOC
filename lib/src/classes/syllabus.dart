import 'package:flutter/material.dart';
import 'package:ioesolutions/src/presentation/my_flutter_app_icons.dart';

class Sylabus {

  Icon icon;
  String text;

  Sylabus({this.icon,this.text});
  
}

List <Sylabus> syllabus = [
  Sylabus(icon: Icon(MyFlutterApp.transportation,size: 40.0,color: Color(0xff860000),),text: 'Agriculture'),
  Sylabus(icon: Icon(MyFlutterApp.house,size: 40.0,color: Color(0xff860000)),text: 'Architecture'),
  Sylabus(icon: Icon(MyFlutterApp.people,size: 40.0,color: Color(0xff860000)),text: 'Civil'),
  Sylabus(icon: Icon(MyFlutterApp.computing,size: 40.0,color: Color(0xff860000)),text: 'Computer'),
  Sylabus(icon: Icon(MyFlutterApp.askcom,size: 40.0,color: Color(0xff860000)),text: 'Electronics'),
  Sylabus(icon: Icon(MyFlutterApp.cogwheel,size: 40.0,color: Color(0xff860000)),text: 'Electrical'),
  Sylabus(icon: Icon(MyFlutterApp.tool,size: 40.0,color: Color(0xff860000)),text: 'Mechanical'),
  Sylabus(icon: Icon(MyFlutterApp.askcom,size: 40.0,color: Color(0xff860000)),text: 'BEI'),
  Sylabus(icon: Icon(Icons.airplanemode_active,size: 40.0,color: Color(0xff860000)),text: 'Aerospace'),
  Sylabus(icon: Icon(MyFlutterApp.architecture_and_city,size: 40.0,color: Color(0xff860000)),text: 'Industrial'),
  Sylabus(icon: Icon(MyFlutterApp.transportation__1_,size: 40.0,color: Color(0xff860000)),text: 'Automobile'),
  Sylabus(icon: Icon(MyFlutterApp.communications,size: 40.0,color: Color(0xff860000)),text: 'Geomatics'),
];