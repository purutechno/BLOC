import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ioesolutions/src/blocs/notice/notice_event.dart';
import 'package:ioesolutions/src/blocs/notice/notice_state.dart';
import 'package:ioesolutions/src/models/notice_model.dart';
import 'package:ioesolutions/src/repositories/notice_repository.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';

import '../../app_config.dart';

class NoticeBloc extends Bloc<NoticeEvent, NoticeState> {
  final http.Client httpClient;
  NoticeRepository noticeRepository = new NoticeRepository();
   @override
  NoticeState get initialState => NoticeInitial();

  NoticeBloc({@required this.httpClient});
@override
  Stream<Transition<NoticeEvent, NoticeState>> transformEvents(
    Stream<NoticeEvent> events,
    TransitionFunction<NoticeEvent, NoticeState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }
  @override
  Stream<NoticeState> mapEventToState(NoticeEvent event) async* {
    final currentState = state;
    print("map event to state");
    if (event is FetchNotices && !_hasReachedMax(currentState)) {
      try {
        if (currentState is NoticeInitial) {
          print('Fetching the notices from 0 to 15');
          // yield LoadingInitialNotices();
          final fetchedNotices = await _fetchNotices(0, 15);
          yield NoticesLoaded(notices: fetchedNotices, hasReachedMax: false);
          return;
        }
        if (currentState is NoticesLoaded) {
          // yield LoadingAdditionalNotices();
          print('Fetching the notices from ${currentState.notices.length} to ${currentState.notices.length + 15}');
          final notices = await _fetchNotices(currentState.notices.length, 15);
          yield notices.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : NoticesLoaded(
                  notices: currentState.notices + notices, 
                  hasReachedMax: false,
                );
        }
      } catch (e) {
        if(e is SocketException)
        {
          yield NoticeFailure(error: "No internet connection!");
        }
        else{
        yield NoticeFailure(error: "An error occured. Please try again!");
        }
      }
    }
  }

  bool _hasReachedMax(NoticeState state) =>
      state is NoticesLoaded && state.hasReachedMax;

Future<List<Notice>> _fetchNotices(int startIndex,int limit)async{
  try{
      var bodyData = {
      "start": "$startIndex",
      "limit": "$limit",
    };
    final response = await http.post("${app_config["base_url"]}"+"/get-notices",body: bodyData);
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List; 
      return data.map((rawNotice) { 
        return Notice(
          id: rawNotice['id'],
          title: rawNotice['notice_title'],
          link: rawNotice['notice_link'],
          noticeDate: rawNotice['notice_date'],
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
      throw Exception();
    }
}
 
}
