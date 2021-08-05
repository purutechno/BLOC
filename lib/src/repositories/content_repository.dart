import 'dart:convert';

import 'package:ioesolutions/src/blocs/content/content_event.dart';
import 'package:ioesolutions/src/helper_functions.dart';
import 'package:ioesolutions/src/providers/content_provider.dart';
import 'package:sqflite/sqflite.dart';

class ContentRepository{
  Database database;
  ContentProvider contentProvider = new ContentProvider();
  Future fetchSubjects({content_type,faculty,semester})async
  {
    if(content_type == "syllabus")
    {
      var response = await contentProvider.fetchSubjectsForSyllabus(faculty: faculty,semester: semester);
      return response;
    }
    else if(content_type == "notes")
    {
      var response = await contentProvider.fetchSubjectsForNotes(faculty: faculty,semester: semester);
      return response;
    }
    else{
      var response = await contentProvider.fetchSubjectsForOldQuestions(faculty: faculty,semester: semester);
      return response;
    }
    
  }

  Future fetchNoteTypesForSubject({subject_id})async
  {
      var response = await contentProvider.fetchNoteTypesForSubject(subject_id:subject_id);
      return response;
  }
  Future fetchExtraContents()async
  {
      var response = await contentProvider.fetchExtraContents();
      return response;
  }
  Future fetchOldQuestionFiles({subject_id})async
  {
      var response = await contentProvider.fetchOldQuestionFiles(subjectId:subject_id);
      return response;
  }

  Future loadSubjectContent({subject_id})async
  {
    
      var response = await contentProvider.fetchSubjectContent(subject_id:subject_id);
      return response;
  }

  Future fetchAllContents()async
  {
      var response = await contentProvider.fetchAllContents();
      
      return response;
  }

  Future getOfflineContentsVersion()async
  {
      var response = await getFromSharedPreferences("offline_content_version");
      return response;
  }


  saveContentsToTable(offlineContents)async
  {
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + "/IoeSolutions.db";
    database = await openDatabase("$path");
    await contentProvider.saveToSubjectsTable(offlineContents["subjects"],database).then((_)async{
    await contentProvider.saveToContentsTable(offlineContents["subject_contents"],database);
    });
  }


  truncateTable(tablename)async
  {
    await truncateTheTable(tablename: tablename);
  }


}



