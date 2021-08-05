import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ioesolutions/src/blocs/news/news_event.dart';
import 'package:ioesolutions/src/blocs/news/news_state.dart';
import 'package:ioesolutions/src/models/news_model.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';

import '../../app_config.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final http.Client httpClient;
   @override
  NewsState get initialState => NewsInitial();

  NewsBloc({@required this.httpClient});
  @override
  Stream<Transition<NewsEvent, NewsState>> transformEvents(
    Stream<NewsEvent> events,
    TransitionFunction<NewsEvent, NewsState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }
  @override
  Stream<NewsState> mapEventToState(NewsEvent event) async* {
    final currentState = state;
    print("map event to state");
    if (event is FetchNews && !_hasReachedMax(currentState)) {
      try {
        if (currentState is NewsInitial) {
          print('Fetching the news from 0 to 15');
          // yield LoadingInitialnews();
          final fetchedNews = await _fetchNews(0, 15);
          if(fetchedNews.length<15)
          {
            yield NewsLoaded(news: fetchedNews, hasReachedMax: true);
          }
          else
          {
            yield NewsLoaded(news: fetchedNews, hasReachedMax: false);
          }
          return;
        }
        if (currentState is NewsLoaded) {
          // yield LoadingAdditionalnews();
          print('Fetching the news from ${currentState.news.length} to ${currentState.news.length + 15}');
          final news = await _fetchNews(currentState.news.length, 15);
          yield news.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : NewsLoaded(
                  news: currentState.news + news, 
                  hasReachedMax: false,
                );
        }
      } catch (e) {
        if(e is SocketException)
        {
          yield NewsFailure(error: "No internet connection!");
        }
        print(e);
        yield NewsFailure(error: "An error occured. Please try again!");
      }
    }
  }

  bool _hasReachedMax(NewsState state) =>
      state is NewsLoaded && state.hasReachedMax;

Future<List<News>> _fetchNews(int startIndex,int limit)async{
  try{
      var bodyData = {
      "start": "$startIndex",
      "limit": "$limit",
    };
    final response = await http.post("${app_config["base_url"]}"+"/get-news",body: bodyData);
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List; 
      return data.map((rawNews) { 
        return News(
          id: rawNews['id'],
          title: rawNews['title'],
          image_name: rawNews['image'],
          news_date: rawNews['created_at'],
          thumbnail_link: app_config["image_base_url"]+"/admin/image/article/small/"+rawNews['image'],
        );
      }).toList();
    } else {
      throw Exception('error fetching posts');
    }
    }catch(e){
      if(e is SocketException)
      {
        throw SocketException("No internet");
      }
      print(e);
      throw Exception();
    }
}
 
}
