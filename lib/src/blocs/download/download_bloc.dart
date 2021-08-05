import 'dart:async';
import 'dart:io';

import 'package:ioesolutions/src/blocs/content/content_state.dart';
import 'package:ioesolutions/src/blocs/content/content_event.dart';
import 'package:bloc/bloc.dart';
import 'package:ioesolutions/src/blocs/download/download_event.dart';
import 'package:ioesolutions/src/helper_functions.dart';
import 'package:ioesolutions/src/repositories/content_repository.dart';
import 'package:ioesolutions/src/repositories/download_repository.dart';
import 'package:sqflite/sqflite.dart';

import 'download_state.dart';

class DownloadBloc extends Bloc<DownloadEvent, DownloadState> {
  final DownloadRepository downloadRepository = new DownloadRepository();
  @override
  DownloadState get initialState => DownloadPageInitial();

  @override
  Stream<DownloadState> mapEventToState(DownloadEvent event) async* {
    // if (event is LoadPdfOnline) {
    //   yield PdfLoading();
    //   try {
    //     var response = await downloadRepository.loadPdfOnline(
    //         file_id: event.file_id,);
    //     yield ContentLoaded(content: response);
    //   } catch (error) {
    //     if (error is SocketException) {
    //       yield ContentLoadFailure(error: {
    //         "exception_type": "SocketException",
    //         "message": "No Internet Connection!"
    //       });
    //     }else {
    //       yield ContentLoadFailure(error: {
    //         "exception_type": "GeneralException",
    //         "message": "An error occured. Please try again!"
    //       });
    //     }
    //   }
    // }

    

    




  }
}
