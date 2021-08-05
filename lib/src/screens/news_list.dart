
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:ioesolutions/src/blocs/news/news_bloc.dart';
import 'package:ioesolutions/src/blocs/news/news_event.dart';
import 'package:ioesolutions/src/blocs/news/news_state.dart';
import 'package:ioesolutions/src/models/news_model.dart';
import 'package:ioesolutions/src/screens/components/loading_indicator.dart';

class NewsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff860000),
        title: Text("Recent News"),
      ),
      body: BlocProvider<NewsBloc>(
            create: (_) => NewsBloc(httpClient: http.Client())..add(FetchNews()),
            child: NewsListBody(),
    ), 
    );
  }
}

class NewsListBody extends StatefulWidget {
  @override
  _NewsListBodyState createState() => _NewsListBodyState();
}

class _NewsListBodyState extends State<NewsListBody> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  NewsBloc _newsBloc;
   
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _newsBloc = BlocProvider.of<NewsBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsBloc, NewsState>(
      builder: (context, state) {
        if (state is NewsInitial){
          return loadingIndicator();
        }
        if (state is NewsFailure) {
          return Center(
            child: Text('${state.error}',style: TextStyle(color: Colors.grey[600],fontSize: 14),),
          );
        }
        if (state is NewsLoaded) {            
          if (state.news.isEmpty) {
            return Center(
              child: Text('No recent news!',style: TextStyle(color: Colors.grey[600],fontSize: 15),),
            );
          }
          return ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              return index >= state.news.length
                  ? Container(
                    padding: const EdgeInsets.only(bottom:20),
                    child: loadingIndicator()
                  )
                  : NewsWidget(news: state.news[index]);
            },
            itemCount: state.hasReachedMax
                ? state.news.length
                : state.news.length + 1,
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
        _newsBloc.add(FetchNews());
      }
      
    }
}
class NewsWidget extends StatelessWidget {
  final News news;

  const NewsWidget({Key key, @required this.news}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top:5,bottom:5),
          color: Colors.grey[200],
          child: ListTile(
            dense: false,
            onTap: (){
             
              // print("Index of /Notes/ is : $index");
              // var filename = news.link.substring(index+7);
              // print("Filename for Note is : $filename");
              // return "$filename";
            },
            leading: CachedNetworkImage(
              height: 50,
              width: 50,
              imageUrl: "${news.thumbnail_link}",
              placeholder: (context, url) => Image.asset("images/logo.png"),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            title:
                Text(news.title, style: TextStyle(fontSize: 15.0,height: 1.4),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                
                ),
            subtitle:
                Text(news.news_date.toString(), style: TextStyle(fontSize: 12.0,height: 1.5)),
          ),
        );
  }
}

