import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ioesolutions/src/blocs/content/content_bloc.dart';
import 'package:ioesolutions/src/blocs/content/content_event.dart';
import 'package:ioesolutions/src/blocs/content/content_state.dart';
import 'package:ioesolutions/src/classes/note_types.dart';

import 'components/loading_indicator.dart';


class OldQuestionsListBackup extends StatelessWidget {
  final String subject_id;
  final String subject_name;
  const OldQuestionsListBackup({Key key,this.subject_id,this.subject_name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  print("subject id is : $subject_id");

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
                      title: Text("OLD QUESTIONS",style: TextStyle(fontSize: 20),),
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
            create: (_) => ContentBloc()..add(LoadOldQuestionsFiles(subject_id:subject_id)),
            child: OldQuestionsBody(subjectName: subject_name,),
    ),    
        ),
      ),  
    );
  }
}

class OldQuestionsBody extends StatelessWidget {
  final String subjectName;
  const OldQuestionsBody({
    Key key,this.subjectName
  }) : super(key: key);
// ListTile listViewItem({context,content,index,note_type,subject_name}){
//     return ListTile(
//       onTap:(){}, 
//       // Navigator.of(context).push(MaterialPageRoute(
//       //       builder: (context) => NoteFilesList(
//       //         subject_name: "$subject_name",
//       //         note_type: "$note_type",
//       //         notes: content["notes"],
//       //           ))),
//       leading : Container(
//         height: 34.0,
//         width : 34.0,
//         decoration: BoxDecoration(
//           borderRadius : BorderRadius.circular(17.0),
//           border: Border.all(color : Color(0xff860000)), 
//         ),
//       child : Align(
//         child:noteTypes[index].icon,
//           ),
//         ),
//       title: Text("${content["title"]}"),
//       trailing: Icon(Icons.keyboard_arrow_right),
//     );
//   }
  String _getFileName(filename)
  {
    if(filename.length>50)
    {
       String final_name = filename.substring(0,50);
       return final_name + " ...";
    }
    return filename;
  }
  String _getFileSize(sizeInBytes)
  {
    var filesize = (sizeInBytes/1000000).toStringAsFixed(2);
    return "Size: $filesize mb";
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
           return ListView.separated(
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              itemCount: state.content["files"].length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap:()
                    {
                      // return Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => TextNoteContent(
                      //         chapter_name: state.content["files"][index]["chapter_name"],
                      //         chapter_content: state.content["files"][index]["content"],
                      //   )));
              },
              leading : Image(
              image: AssetImage("images/pdf_image.jpg"), 
              height: 50.0,
            ),
              title: Text(_getFileName(state.content["files"][index]["filename"])),
              subtitle: Text(_getFileSize(state.content["files"][index]["file_size"])),
              // trailing: Icon(Icons.keyboard_arrow_right),
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
],
     ),
      
     );
  }
}
