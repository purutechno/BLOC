import 'package:flutter/material.dart';
import 'package:ioesolutions/src/classes/sem.dart';
class Notes extends StatelessWidget {
  const Notes({Key key}) : super(key: key);

  ListTile _sem(int index){
    return ListTile(
      leading : Container(
        height: 30.0,
        width : 30.0,
        decoration: BoxDecoration(
          borderRadius : BorderRadius.circular(15.0),
          border: Border.all(color : Color(0xff860000)), 
        ),
      child : Align(
        child:sem[index].trailing,
          ),
        ),
      title: sem[index].title,
      trailing: Icon(Icons.keyboard_arrow_right),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Color(0xff860000),
      appBar : AppBar(
        elevation : 0.0,
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right:15.0),
            child: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top:10.0),
            child: Align(
              child: Text(
                'NOTES',
                style: TextStyle(
                  color : Colors.white,
                  fontSize : 40.0,
                  
                ),
                ),

            ),
          ),
          SizedBox(height:20.0),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius : BorderRadius.only(
                  topRight: Radius.circular(40.0),
                  topLeft: Radius.circular(40.0),
                )
              ),
            
              child: ListView(
                padding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 10.0),
                children: <Widget>[
                  _sem(0),
                  Divider(),
                  _sem(1),
                  Divider(),
                  _sem(2),
                  Divider(),
                  _sem(3),
                  Divider(),
                  _sem(4),
                  Divider(),
                  _sem(5),
                  Divider(),
                  _sem(6),
                  Divider(),
                  _sem(7),
                  Divider(),
                ],
              ),
            ),
          
          ),
        ],
        ),
    );
      
  
  }
}