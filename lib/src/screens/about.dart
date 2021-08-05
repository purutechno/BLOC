import 'package:flutter/material.dart';
import 'package:ioesolutions/src/presentation/my_flutter_app_icons.dart';
class About extends StatelessWidget {
  const About({Key key}) : super(key: key);

  
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
                'ABOUT',
                style: TextStyle(
                  color : Colors.white,
                  fontSize : 40.0,
                ),
                ),
            ),
          ),
          SizedBox(height:20.0),
          Expanded(
            child:
            Container(
               width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius : BorderRadius.only(
                  topRight: Radius.circular(40.0),
                  topLeft: Radius.circular(40.0),
                )
              ),
              child: ListView(
              shrinkWrap: true,
              children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(30.0, 40.0, 20.0, 0.0),
              child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: <Widget>[
                 Text(
                   'IOE Solutions',
                   style: TextStyle(
                     fontSize : 25.0,
                     fontWeight : FontWeight.w600,
                   ),
                   ),
                   Text('A Product of Esign Technology',style: TextStyle(fontSize : 10.0,fontWeight : FontWeight.w500),),
                   SizedBox(height : 3.0),
                   Divider(
                     color: Color(0xff860000),
                     height: 2.0,
                     thickness: 3.0,
                     endIndent: 265.0,
                   ),
                   SizedBox(height:30.0,),
                   Text('Initial Release Date : 5th January,2020',style: TextStyle(fontSize : 12.0,fontWeight: FontWeight.w300),),
                   SizedBox(height : 10.0),
                   Text('Email : solutions.ioe@gmail.com',style: TextStyle(fontSize : 12.0,fontWeight: FontWeight.w300),),
                   SizedBox(height : 10.0),
                   Text('Website : https://ioesolutions.esign.com.np',style: TextStyle(fontSize : 12.0,fontWeight: FontWeight.w300),),
                   SizedBox(height:20.0),
                   Icon(MyFlutterApp.facebook,color: Colors.blue[900],size: 30.0,),
                  SizedBox(height:20.0,),
               ],
               ),
            ),
              Container(
              padding: EdgeInsets.fromLTRB(30.0, 40.0, 20.0, 0.0),
              color: Colors.grey[300],
              child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: <Widget>[
               Text(
                 'About Us',
                 style: TextStyle(
                   fontSize : 20.0,
                   fontWeight : FontWeight.w600,
                 ),
                 ),
                 SizedBox(height : 3.0),
                 Divider(
                   color: Color(0xff860000),
                   height: 2.0,
                   thickness: 3.0,
                   endIndent: 265.0,

                 ),
                 SizedBox(height:20.0,),
                 Text('ESign Technology Pvt. Ltd.',style: TextStyle(fontSize : 15.0,fontWeight: FontWeight.w600),),
                 Text('Kathmandu, Nepal',style: TextStyle(fontSize : 12.0,),),
                 Text('Website : www.esign.com.np',style: TextStyle(fontSize : 12.0,),),
                 Text('Email : esignnp@gmail.com',style: TextStyle(fontSize : 12.0,),),
                 SizedBox(height:20.0),
                 Row(
                   children: <Widget>[
                     Icon(MyFlutterApp.facebook,color: Colors.blue[900],size: 30.0,),
                     SizedBox(width:15.0),
                     Icon(MyFlutterApp.linkedin,color: Color(0xff0e76a8),size: 30.0,),
                     SizedBox(width:15.0),
                     Icon(MyFlutterApp.twitter,color: Colors.blue,size: 30.0,),
                   ],
                 ),
                 SizedBox(height:20.0),
             ],
             ),
            ),
              ],
            ),
            ),
          ),  
        ],
        ),
    );
      
  }
}





