import 'dart:async';
import 'dart:io';

import 'package:ioesolutions/src/blocs/homepage/homepage_state.dart';
import 'package:ioesolutions/src/blocs/homepage/homepage_event.dart';
import 'package:bloc/bloc.dart';
import 'package:ioesolutions/src/repositories/homepage_repository.dart';

class HomepageBloc extends Bloc<HomepageEvent, HomepageState> {
  @override
  HomepageState get initialState => HomepageInitial();
  HomepageRepository homepageRepository = new HomepageRepository();
  @override
  Stream<HomepageState> mapEventToState(
    HomepageEvent event) async* {
    if (event is LoadHomepageData) {
      yield HomepageDataLoading();
      print("homepage data loading!");
      try {
        var response = await homepageRepository.fetchInitialData();
        yield HomepageDataLoaded(homepageData: response);
      } catch (error) {
        if (error is SocketException) {
          yield HomepageFailure(error: {
            "exception_type": "SocketException",
            "message": "No Internet Connection!"
          });
        }else {
          yield HomepageFailure(error: {
            "exception_type": "GeneralException",
            "message": "An error occured while fetching data!"
          });
        }
      }
      
    }

    if (event is CheckIfDataAvailable) {
      try {
        var response = await homepageRepository.fetchInitialData();
        yield HomepageDataLoaded(homepageData: response);
      } catch (error) {
        if (error is SocketException) {
          yield HomepageFailure(error: {
            "exception_type": "SocketException",
            "message": "No Internet Connection!"
          });
        }else {
          yield HomepageFailure(error: {
            "exception_type": "GeneralException",
            "message": "An error occured while fetching data!"
          });
        }
      }
      
    }

  }
}