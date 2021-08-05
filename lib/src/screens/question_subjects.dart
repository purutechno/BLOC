import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ioesolutions/src/admob/admob_manager.dart';
import 'package:ioesolutions/src/blocs/content/content_bloc.dart';
import 'package:ioesolutions/src/blocs/content/content_event.dart';
import 'package:ioesolutions/src/blocs/content/content_state.dart';
import 'package:ioesolutions/src/classes/sub.dart';
import 'package:ioesolutions/src/screens/components/loading_indicator.dart';
import 'package:ioesolutions/src/screens/old_questions_list.dart';
import 'package:ioesolutions/src/screens/syllabus_content.dart';

import '../helper_functions.dart';
class QuestionSubjects extends StatelessWidget {
  final String content_type;
  final String faculty_code;
  final String semester_id;
  const QuestionSubjects({Key key,this.content_type,this.faculty_code,this.semester_id}) : super(key: key);

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
                      title: Text("SUBJECTS",style: TextStyle(fontSize: 27),),
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
          body: BlocProvider<ContentBloc>(
            create: (_) => ContentBloc()..add(LoadSubjects(content_type:content_type,faculty:faculty_code,semester:semester_id)),
            child: QuestionSubjectsBody(),
    ),    
        ),
      ),  
    );
  }
}

class QuestionSubjectsBody extends StatelessWidget {
  const QuestionSubjectsBody({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
     decoration: BoxDecoration(
         color: Colors.white,
         borderRadius: BorderRadius.only(
           topRight: Radius.circular(40.0),
           topLeft: Radius.circular(40.0),
         )),
     child: 
      BlocBuilder(
      bloc: BlocProvider.of<ContentBloc>(context),
      builder: (context, state) {
        if(state is ContentLoaded)
        {
          if(state.content.length == 0)
          {
            return Center(
              child: Text("Old questions for this semester will be available soon!",style: TextStyle(color: Colors.grey[600]),),
            );
          }
          return ListView.separated(
          padding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 10.0),
          itemCount: state.content.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap:()=> Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => OldQuestionsList(
              subject_id: "${state.content[index]["subject_id"]}",
                  subject_name: state.content[index]["subject_name"],
                ))),
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
              title: Text(state.content[index]["subject_name"]),
              trailing: Icon(Icons.keyboard_arrow_right),
            );
      },
      separatorBuilder: (context, index) {
        if((index+1)%4==0)
        {
          return Column(
            children: <Widget>[
              Divider(),
              AdmobManager.finishBanner,
              Divider()
            ],
          );
          
        }
    return Divider();
  },
    );
}

if(state is ContentLoading)
{
  return loadingIndicator();
}

if(state is ContentLoadFailure)
{
  return Center(
    child: Text(state.error["message"],style:TextStyle(color:Colors.grey[600])),
  );
}
return Container();



      },
      ),
     );
  }
}