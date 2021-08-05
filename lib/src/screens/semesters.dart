import 'package:flutter/material.dart';
import 'package:ioesolutions/src/admob/admob_manager.dart';
import 'package:ioesolutions/src/blocs/content/content_bloc.dart';
import 'package:ioesolutions/src/classes/sem.dart';
import 'package:ioesolutions/src/screens/note_subjects.dart';
import 'package:ioesolutions/src/screens/question_subjects.dart';
import 'package:ioesolutions/src/screens/syllabus_subjects.dart';
class Semester extends StatelessWidget {
  var subjectPage;
  final ContentBloc contentBloc = new ContentBloc();
  final String content_type;
  final String faculty_code;
  Semester({Key key,this.content_type,this.faculty_code}) : super(key: key);

  ListTile _sem(int index){
    return ListTile(
      leading : Container(
        height: 34.0,
        width : 34.0,
        decoration: BoxDecoration(
          borderRadius : BorderRadius.circular(17.0),
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
  _getDestinationPage(contentType,id)
  {
    if(contentType == "notes")
    {
      return new NoteSubjects(content_type: contentType,faculty_code: faculty_code,semester_id: id,);
    }
    else if (contentType == "questions")
    {
      return new QuestionSubjects(content_type: contentType,faculty_code: faculty_code,semester_id: id,);
    }
    return new SyllabusSubjects(content_type: contentType,faculty_code: faculty_code,semester_id: id,);
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
                      title: Text("SEMESTERS",style: TextStyle(fontSize: 27),),
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
            child: ListView(
                padding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 10.0),
                children: <Widget>[
                  GestureDetector(
                    onTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => _getDestinationPage(
                                content_type,
                                "1"
                                ),
                          )),
                    child: _sem(0),),
                  Divider(),
                  GestureDetector(
                    onTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => _getDestinationPage(
                                content_type,
                                "2"
                                ),
                          )),
                    child: _sem(1),),
                  Divider(),
                  GestureDetector(
                    onTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => _getDestinationPage(
                                content_type,
                                "3"
                                ),
                          )),
                    child: _sem(2),),
                  Divider(),
                  GestureDetector(
                    onTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => _getDestinationPage(
                                content_type,
                                "4"
                                ),
                          )),
                    child: _sem(3),),
                  Divider(),
                  AdmobManager.finishBanner,
                  GestureDetector(
                    onTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => _getDestinationPage(
                                content_type,
                                "5"
                                ),
                          )),
                    child: _sem(4),),
                  Divider(),
                  GestureDetector(
                    onTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => _getDestinationPage(
                                content_type,
                                "6"
                                ),
                          )),
                    child: _sem(5),),
                  Divider(),
                  
                  GestureDetector(
                    onTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => _getDestinationPage(
                                content_type,
                                "7"
                                ),
                          )),
                    child: _sem(6),),
                  Divider(),
                  GestureDetector(
                    onTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => _getDestinationPage(
                                content_type,
                                "8"
                                ),
                          )),
                    child: _sem(7),),
                  Divider(),
                  AdmobManager.finishBanner,
                  faculty_code == "architecture-engineering-barch"?
                  GestureDetector(
                    onTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => _getDestinationPage(
                                content_type,
                                "9"
                                ),
                          )),
                    child: _sem(8),)
                  :Container(),
                  faculty_code == "architecture-engineering-barch"?
                  Divider()
                  :Container(),
                  faculty_code == "architecture-engineering-barch"?
                  GestureDetector(
                    onTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => _getDestinationPage(
                                content_type,
                                "10"
                                ),
                          )),
                    child: _sem(9),)
                  :Container(),
                  faculty_code == "architecture-engineering-barch"?
                  Divider()
                  :Container(),
                  faculty_code == "architecture-engineering-barch"?
                  AdmobManager.finishBanner
                  :Container(),
                ],
              ),
          ),
        ),
      ),  
      );
  }
}