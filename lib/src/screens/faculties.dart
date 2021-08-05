import 'package:flutter/material.dart';
import 'package:ioesolutions/src/classes/syllabus.dart';
import 'package:ioesolutions/src/screens/semesters.dart';

class Faculty extends StatelessWidget {
  final String content_type;
  const Faculty({Key key, this.content_type}) : super(key: key);

  Column _sylabus(int index) {
    return Column(
      children: <Widget>[
        Container(
            height: 70.0,
            width: 70.0,
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xff860000)),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: syllabus[index].icon),
        SizedBox(height: 5.0),
        Text(syllabus[index].text, style: TextStyle(color: Colors.black)),
        SizedBox(height: 20.0),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xff860000),
      body:
      SafeArea(
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
                      title: Text("$content_type".toUpperCase(),style: TextStyle(fontSize: 27),),
                      centerTitle: true,
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
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10.0, 20.0, 0.0),
                  child: Wrap(
                    alignment: WrapAlignment.spaceEvenly,
                    spacing: 30.0,
                    runSpacing: 10.0,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Semester(
                              content_type: content_type,
                              faculty_code: "agriculture-engineering-bag"),
                        )),
                        child: _sylabus(0),
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Semester(
                              content_type: content_type,
                              faculty_code: "architecture-engineering-barch"),
                        )),
                        child: _sylabus(1),
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Semester(
                              content_type: content_type,
                              faculty_code: "civil-engineering-bce"),
                        )),
                        child: _sylabus(2),
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Semester(
                              content_type: content_type,
                              faculty_code: "computer-engineering-bct"),
                        )),
                        child: _sylabus(3),
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Semester(
                              content_type: content_type,
                              faculty_code: "electronics-and-communication-engineering-bex"),
                        )),
                        child: _sylabus(4),
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Semester(
                              content_type: content_type,
                              faculty_code: "electrical-engineering-bel"),
                        )),
                        child: _sylabus(5),
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Semester(
                              content_type: content_type,
                              faculty_code: "mechanical-engineering-bme"),
                        )),
                        child: _sylabus(6),
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Semester(
                              content_type: content_type,
                              faculty_code: "electronics-and-information-bei-new"),
                        )),
                        child: _sylabus(7),
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Semester(
                              content_type: content_type,
                              faculty_code: "aerospace-engineering"),
                        )),
                        child: _sylabus(8),
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Semester(
                              content_type: content_type,
                              faculty_code: "industrial-engineering-bie"),
                        )),
                        child: _sylabus(9),
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Semester(
                              content_type: content_type,
                              faculty_code: "automobile-engineering"),
                        )),
                        child: _sylabus(10),
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Semester(
                              content_type: content_type,
                              faculty_code: "geomatics-engineering"),
                        )),
                        child: _sylabus(11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),  
      
       
    );
  }
}
