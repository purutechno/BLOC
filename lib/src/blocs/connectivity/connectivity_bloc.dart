import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:ioesolutions/src/blocs/connectivity/connectivity_state.dart';
import 'package:ioesolutions/src/blocs/connectivity/connectivity_event.dart';
import 'package:bloc/bloc.dart';
import 'package:sqflite/sqflite.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  bool hasInternetConnection = false;
  final _connectivity;
  StreamSubscription _connectivitySubscription;
  ConnectivityBloc(this._connectivity);
  
  @override
  ConnectivityState get initialState => ConnectivityInitial();

  @override
  Stream<ConnectivityState> mapEventToState(ConnectivityEvent event) async* {
    if (event is CheckInternetConnection) {
    
        await _connectivitySubscription?.cancel();
        _connectivitySubscription = _connectivity.onConnectivityChanged.listen((ConnectivityResult result) => add(ConnectionChanged()));
        yield await _checkConnection();
    }
    if(event is ConnectionChanged)
    {
      yield await _checkConnection();
    }


  }
  Future<ConnectivityState> _checkConnection()async
  {
    bool previousConnection = hasInternetConnection;
    try{
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            hasInternetConnection = true;
           return HasInternetConnection();
        }
        else{
          hasInternetConnection = false;
          return NoInternetConnection();
        }

      } on SocketException catch (_) {
        hasInternetConnection = false;
        return NoInternetConnection();
      }
      
  }

   @override
    Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }



}
