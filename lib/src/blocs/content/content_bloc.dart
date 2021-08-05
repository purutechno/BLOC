import 'dart:async';
import 'dart:io';

import 'package:ioesolutions/src/blocs/content/content_state.dart';
import 'package:ioesolutions/src/blocs/content/content_event.dart';
import 'package:bloc/bloc.dart';
import 'package:ioesolutions/src/helper_functions.dart';
import 'package:ioesolutions/src/repositories/content_repository.dart';

class ContentBloc extends Bloc<ContentEvent, ContentState> {
  final ContentRepository contentRepository = new ContentRepository();
  @override
  ContentState get initialState => ContentPageInitial();

  @override
  Stream<ContentState> mapEventToState(ContentEvent event) async* {
    if (event is LoadExtraContents) {
      yield ContentLoading();
      try {
        var response = await contentRepository.fetchExtraContents();
        yield ContentLoaded(content: response);
      } catch (error) {
        if (error is SocketException) {
          yield ContentLoadFailure(error: {
            "exception_type": "SocketException",
            "message": "No Internet Connection!"
          });
        }else {
          yield ContentLoadFailure(error: {
            "exception_type": "GeneralException",
            "message": "An error occured. Please try again!"
          });
        }
      }
    }

    if (event is LoadSubjects) {
      yield ContentLoading();
      try {
        var response = await contentRepository.fetchSubjects(
            content_type: event.content_type,
            faculty: event.faculty,
            semester: event.semester);
        yield ContentLoaded(content: response);
      } catch (error) {
        if (error is SocketException) {
          yield ContentLoadFailure(error: {
            "exception_type": "SocketException",
            "message": "No Internet Connection!"
          });
        }else {
          yield ContentLoadFailure(error: {
            "exception_type": "GeneralException",
            "message": "An error occured. Please try again!"
          });
        }
      }
    }

    if(event is LoadNoteTypesForSubject)
    {
      yield ContentLoading();
      try {
        var response = await contentRepository.fetchNoteTypesForSubject(
            subject_id: event.subject_id);
        yield ContentLoaded(content: response);
      } catch (error) {
        if (error is SocketException) {
          yield ContentLoadFailure(error: {
            "exception_type": "SocketException",
            "message": "No Internet Connection!"
          });
        }else {
          yield ContentLoadFailure(error: {
            "exception_type": "GeneralException",
            "message": "An error occured. Please try again!"
          });
        }
      }
    }

    if(event is LoadOldQuestionsFiles)
    {
      yield ContentLoading();
      try {
        var response = await contentRepository.fetchOldQuestionFiles(
            subject_id: event.subject_id);
        yield ContentLoaded(content: response);
      } catch (error) {
        if (error is SocketException) {
          yield ContentLoadFailure(error: {
            "exception_type": "SocketException",
            "message": "No Internet Connection!"
          });
        }else {
          yield ContentLoadFailure(error: {
            "exception_type": "GeneralException",
            "message": "An error occured. Please try again!"
          });
        }
      }
    }

    if(event is MakeOldQuestionPageReady)
    {
      yield OldQuestionPageReady();
    }
    if (event is LoadSyllabusContent) {
      yield ContentLoading();
      try {
        var response = await contentRepository.loadSubjectContent(
            subject_id: event.subject_id);
        yield ContentLoaded(content: response);
      } catch (error) {
        if (error is SocketException) {
          yield ContentLoadFailure(error: {
            "exception_type": "SocketException",
            "message": "No Internet Connection!"
          });
        }else {
          yield ContentLoadFailure(error: {
            "exception_type": "GeneralException",
            "message": "An error occured. Please try again!"
          });
        }
      }
    }

    if (event is FetchAllContents) {
      yield ContentLoading();
      try {
        var response = await contentRepository.fetchAllContents();
        yield ContentLoaded(content: response);
      } catch (error) {
        if (error is SocketException) {
          yield ContentLoadFailure(error: {
            "exception_type": "SocketException",
            "message": "No Internet Connection!"
          });
        }else {
          yield ContentLoadFailure(error: {
            "exception_type": "GeneralException",
            "message": "An error occured. Please try again!"
          });
        }
      }
    }



    if (event is CheckForContentUpdate) {
      print('checking if contetn needs to be updated');
      try {
        var response = await contentRepository.getOfflineContentsVersion();
        print(event.app_config["offline_content_version"]);
        if(response == "_")
        {
          yield LoadingNewContents();
          var offlineContents = await contentRepository.fetchAllContents();
          await contentRepository.truncateTable("Subjects");
          await contentRepository.truncateTable("Contents");
          await contentRepository.saveContentsToTable(offlineContents);
          await saveToSharedPreferences("offline_content_version", "${event.app_config["offline_content_version"]}");
          yield ContentSaved();
        }
        else if(response != "${event.app_config["offline_content_version"]}")
        {
          yield UpdatingContents();
          var offlineContents = await contentRepository.fetchAllContents();
          await contentRepository.truncateTable("Subjects");
          await contentRepository.truncateTable("Contents");
          await contentRepository.saveContentsToTable(offlineContents);
          await saveToSharedPreferences("offline_content_version", "${event.app_config["offline_content_version"]}");
          yield ContentSaved();
        }
        else{
          yield ContentPageNoResponse();
        }
        
      } catch (error) {
        if (error is SocketException) {
          yield ContentLoadFailure(error: {
            "exception_type": "SocketException",
            "message": "No Internet Connection!"
          });
        }else {
          print(error);
          yield ContentLoadFailure(error: {
            "exception_type": "GeneralException",
            "message": "An error occured. Please try again!"
          });
        }
      }
    }
    if(event is UpdateAllContents)
    {
     var currentState = state;
     if(currentState is! ContentLoading)
     {
          yield UpdatingContents();
          var offlineContents = await contentRepository.fetchAllContents();
          await contentRepository.truncateTable("Subjects");
          await contentRepository.truncateTable("Contents");
          await contentRepository.saveContentsToTable(offlineContents);
          await saveToSharedPreferences("offline_content_version", "${offlineContents["offline_content_version"]}");
          yield ContentSaved();
     }
    }




  }
}
