import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ioesolutions/src/admob/admob_manager.dart';
import 'package:ioesolutions/src/blocs/content/content_bloc.dart';
import 'package:ioesolutions/src/blocs/content/content_event.dart';
import 'package:ioesolutions/src/blocs/content/content_state.dart';
import 'package:ioesolutions/src/classes/note_types.dart';
import 'package:ioesolutions/src/screens/components/loading_indicator.dart';
import 'package:ioesolutions/src/screens/download.dart';
import 'package:ioesolutions/src/screens/pdf_notes_list.dart';
import 'package:ioesolutions/src/screens/text_notes_list.dart';

class NoteTypes extends StatelessWidget {
  final String subject_id;
  final String subject_name;
  const NoteTypes({Key key,this.subject_id,this.subject_name}) : super(key: key);

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
                      title: Text("AVAILABLE NOTES",style: TextStyle(fontSize: 18),),
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
            create: (_) => ContentBloc()..add(LoadNoteTypesForSubject(subject_id:subject_id)),
            child: NoteTypesBody(subjectName: subject_name,),
    ),    
        ),
      ),  
    );
  }
}

class NoteTypesBody extends StatelessWidget {
  final String subjectName;
  const NoteTypesBody({
    Key key,this.subjectName
  }) : super(key: key);
ListTile listViewItem({context,content,index,note_type,subject_name}){
    return ListTile(
      onTap:(){ 
        if(note_type == "text_note")
        {
         return Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => TextNotesList(
              subject_name: "$subject_name",
              notes: content["notes"], 
                )));
        }
        return Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PdfNotesList(
              subject_name: "$subject_name",
              note_type: "$note_type",
              notes: content["notes"], 
                )));
        },
      leading : Container(
        height: 34.0,
        width : 34.0,
        decoration: BoxDecoration(
          borderRadius : BorderRadius.circular(17.0),
          border: Border.all(color : Color(0xff860000)), 
        ),
      child : Align(
        child:noteTypes[index].icon,
          ),
        ),
      title: Text("${content["title"]}"),
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
     child: ListView(
       shrinkWrap: true,
      //  padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
       physics: AlwaysScrollableScrollPhysics(),
       children: <Widget>[
         Padding(
                padding: const EdgeInsets.fromLTRB(30,10,20,10),
                child: Text("$subjectName",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
              ),
              Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(left: 30,right: 20),
                    child: SizedBox(
                      child: Container(
                        width: 120,
                      height: 3,
                      color: Color(0xff860000),
              ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 27),
              BlocBuilder(
      bloc: BlocProvider.of<ContentBloc>(context),
      builder: (context, state) {
        if(state is ContentLoaded)
        {
          return ListView(
            padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              state.content.containsKey("link_notes")?
              listViewItem(context:context,content:state.content["link_notes"],index:0,note_type: "link_note",subject_name: state.content["subject_name"])
              :Container(),
              state.content.containsKey("text_notes")?Divider():Container(),
              state.content.containsKey("text_notes")?
              listViewItem(context:context,content:state.content["text_notes"],index:1,note_type: "text_note",subject_name: state.content["subject_name"])
              :Container(),
              state.content.containsKey("text_notes")?Divider():Container(),
              SizedBox(
                height: 20,
              ),
              AdmobManager.mediumRectangle,
            ],
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






       ],
     ),
      
     );
  }
}