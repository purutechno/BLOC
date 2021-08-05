import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ioesolutions/src/admob/admob_manager.dart';
import 'package:ioesolutions/src/blocs/content/content_bloc.dart';
import 'package:ioesolutions/src/blocs/content/content_event.dart';
import 'package:ioesolutions/src/blocs/content/content_state.dart';
import 'package:ioesolutions/src/screens/components/loading_indicator.dart';
import 'package:ioesolutions/src/screens/extra%20contents/show_folder_contents.dart';

import '../../helper_functions.dart';
class ShowFolders extends StatelessWidget {
  const ShowFolders({Key key}) : super(key: key);

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
                      title: Text("EXTRA CONTENTS",style: TextStyle(fontSize: 17),),
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
            create: (_) => ContentBloc()..add(LoadExtraContents()),
            child: ShowFoldersBody(),
    ),    
        ),
      ),  
    );
  }
}

class ShowFoldersBody extends StatelessWidget {
  const ShowFoldersBody({
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
          if(state.content.isEmpty)
          {
            return Center(
              child: Text("No contents to show!",style: TextStyle(color: Colors.grey[600]),),
            ); 
          }
          return ListView.separated(
          padding: EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 10.0),
          itemCount: state.content.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap:()=> Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ShowFolderContents(
              folder_id: state.content[index]["basename"],
              folder_name: state.content[index]["name"],
                ))),
              leading : Image(
                image: AssetImage("images/folder_icon.png"),
                height: 40,
              ),
              title: Text(state.content[index]["name"],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              ),
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