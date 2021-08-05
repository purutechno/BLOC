import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ioesolutions/src/blocs/content/content_bloc.dart';
import 'package:ioesolutions/src/blocs/content/content_event.dart';
import 'package:ioesolutions/src/blocs/content/content_state.dart';
import 'package:ioesolutions/src/classes/sub.dart';
import 'package:ioesolutions/src/screens/components/loading_indicator.dart';
import 'package:ioesolutions/src/screens/syllabus_content.dart';

import '../helper_functions.dart';
class SyllabusSubjects extends StatelessWidget {
  final String content_type;
  final String faculty_code;
  final String semester_id;
  const SyllabusSubjects({Key key,this.content_type,this.faculty_code,this.semester_id}) : super(key: key);

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
            child: SyllabusSubjectsBody(),
    ),    
        ),
      ),  
    );
  }
}

class SyllabusSubjectsBody extends StatelessWidget {
  const SyllabusSubjectsBody({
    Key key,
  }) : super(key: key);
ListTile _sub(int index){
    return ListTile(
      leading : Container(
        height: 30.0,
        width : 30.0,
        decoration: BoxDecoration(
          borderRadius : BorderRadius.circular(15.0),
          border: Border.all(color : Color(0xff860000)), 
        ),
      child : Align(
        child:subj[index].trailing,
          ),
        ),
      title: subj[index].title,
      trailing: Icon(Icons.keyboard_arrow_right),
    );
  }
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
          return ListView.separated(
          padding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 10.0),
          itemCount: state.content.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap:()=> Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SyllabusContent(
                  subject_id: "${state.content[index]["subject_id"]}",
                  subject_name: state.content[index]["subject_name"],
                  subject_content: state.content[index]["subject_content"],
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