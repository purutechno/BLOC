import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:ioesolutions/src/blocs/notice/notice_bloc.dart';
import 'package:ioesolutions/src/blocs/notice/notice_event.dart';
import 'package:ioesolutions/src/blocs/notice/notice_state.dart';
import 'package:ioesolutions/src/models/notice_model.dart';
import 'package:ioesolutions/src/screens/components/loading_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'pdf_loading_progress.dart';

class NoticesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff860000),
        title: Text("Notices"),
      ),
      body: BlocProvider<NoticeBloc>(
            create: (_) => NoticeBloc(httpClient: http.Client())..add(FetchNotices()),
            child: NoticesListBody(),
    ), 
    );
  }
}

class NoticesListBody extends StatefulWidget {
  @override
  _NoticesListBodyState createState() => _NoticesListBodyState();
}

class _NoticesListBodyState extends State<NoticesListBody> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  NoticeBloc _noticeBloc;
   
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _noticeBloc = BlocProvider.of<NoticeBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoticeBloc, NoticeState>(
      builder: (context, state) {
        if (state is NoticeInitial){
          return loadingIndicator();
        }
        if (state is NoticeFailure) {
          return Center(
            child: Text('${state.error}',style: TextStyle(color: Colors.grey[600],fontSize: 14),),
          );
        }
        if (state is NoticesLoaded) {            
          if (state.notices.isEmpty) {
            return Center(
              child: Text('No notices!',style: TextStyle(color: Colors.grey[600],fontSize: 15),),
            );
          }
          return ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              return index >= state.notices.length
                  ? Container(
                    padding: const EdgeInsets.only(bottom:20),
                    child: loadingIndicator()
                  )
                  : NoticeWidget(notice: state.notices[index]);
            },
            itemCount: state.hasReachedMax
                ? state.notices.length
                : state.notices.length + 1,
            controller: _scrollController,
            separatorBuilder: (context,index){
              return SizedBox(height: 10,);
            },
          );
        }
        return loadingIndicator();
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll()async {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
        _noticeBloc.add(FetchNotices());
      }
      
    }
}
class NoticeWidget extends StatelessWidget {
  final Notice notice;

  const NoticeWidget({Key key, @required this.notice}) : super(key: key);
_launchUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
  @override
  Widget build(BuildContext context) {
    return Container(
          color: Colors.grey[200],
          child: ListTile(
            onTap: ()async{
              var index = notice.link.indexOf(".pdf");
              if(index >=0)
              {
               return Navigator.of(context).push(MaterialPageRoute(
                  builder: (context)=>LoadPdfPage(filename:notice.title,link:notice.link)
                ));
              }
              else{
               return await _launchUrl("${notice.link}");
              }
            },
            title:
                Text(notice.title.trim(), style: TextStyle(fontSize: 12.0),
                maxLines: 2,
                overflow: TextOverflow.ellipsis, 
                ),
            subtitle:
                Text(notice.noticeDate, style: TextStyle(fontSize: 12.0)),
          ),
        );
  }
}

