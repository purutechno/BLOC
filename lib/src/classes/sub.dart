import 'package:flutter/cupertino.dart';

class Sub {

Text trailing;
Text title;
Sub({this.title,this.trailing});
  
}

List <Sub> subj = [
  Sub(trailing: Text('I'),title: Text('Applied Mechanics')),
  Sub(trailing: Text('II'),title: Text('Basic Electrical Engineering')),
  Sub(trailing: Text('III'),title: Text('Engineering Physics')),
  Sub(trailing: Text('IV'),title: Text('Engineering Drawing')),
  Sub(trailing: Text('V'),title: Text('Engineering Mathematics')),
  Sub(trailing: Text('VI'),title: Text('C Programming')),
 
];