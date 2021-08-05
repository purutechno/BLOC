import 'dart:convert';
import 'dart:io';

import 'package:ioesolutions/src/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

class ContentProvider{

  Future fetchSubjectsForSyllabus({faculty,semester})async
  {
    try{
        var databasesPath = await getDatabasesPath();
        String path = databasesPath + "/IoeSolutions.db";
        var database = await openDatabase("$path");
        List<Map> subjects = await database.rawQuery(
        'SELECT * FROM Subjects WHERE faculty_code=? and semester_id=?', 
        ['$faculty', '$semester']
        );
        return subjects;
    }catch(e){
      throw Exception(e);
    }
  }

  Future fetchSubjectsForNotes({faculty,semester})async
  {
    try{
        var bodyData = {
            "faculty_code" : "$faculty",
            "semester_id" : "$semester",
          };
        final response = await http.post("${app_config["base_url"]}/get-subjects-list-for-note",body: bodyData);
        var decodedResponse = json.decode(response.body);
        if (response.statusCode == 200) {
            return decodedResponse;
        } else {
          throw Exception();
        }
    }catch(e){
      if(e is SocketException)
      {
        throw SocketException("$e");
        
      }
      throw Exception(e);
    }
  }
  Future fetchExtraContents()async
  {
    try{
        final response = await http.post("${app_config["base_url"]}/get-extra-contents");
        var decodedResponse = json.decode(response.body);
        if (response.statusCode == 200) {
            return decodedResponse;
        } else {
          throw Exception();
        }
    }catch(e){
      if(e is SocketException)
      {
        throw SocketException("$e");
        
      }
      throw Exception(e);
    }
  }


  Future fetchSubjectsForOldQuestions({faculty,semester})async
  {
    try{
        var bodyData = {
            "faculty_code" : "$faculty",
            "semester_id" : "$semester",
          };
        final response = await http.post("${app_config["base_url"]}/get-subjects-list-for-old-question",body: bodyData);
        var decodedResponse = json.decode(response.body);
        if (response.statusCode == 200) {
            return decodedResponse;
        } else {
          throw Exception();
        }
    }catch(e){
      if(e is SocketException)
      {
        throw SocketException("$e");
        
      }
      throw Exception(e);
    }
  }

  Future fetchOldQuestionFiles({subjectId})async
  {
    try{
        var bodyData = {
            "subject_id" : "$subjectId",
          };
        final response = await http.post("${app_config["base_url"]}/get-questionbank-files-for-subject",body: bodyData);
        var decodedResponse = json.decode(response.body);
        if (response.statusCode == 200) {
            return decodedResponse;
        } else {
          throw Exception();
        }
    }catch(e){
      if(e is SocketException)
      {
        throw SocketException("$e");
        
      }
      throw Exception(e);
    }
  }


  Future fetchNoteTypesForSubject({subject_id})async
  {
    try{
        var bodyData = {
            "subject_id" : "$subject_id",
          };
        final response = await http.post("${app_config["base_url"]}/get-notes-list-for-subject",body: bodyData);
        var decodedResponse = json.decode(response.body);
        if (response.statusCode == 200) {
            return decodedResponse;
        } else {
          throw Exception();
        }
    }catch(e){
      if(e is SocketException)
      {
        throw SocketException("$e");
        
      }
      throw Exception(e);
    }
  }



  Future fetchSubjectContent({subject_id})async
  {
    try{
        var databasesPath = await getDatabasesPath();
        String path = databasesPath + "/IoeSolutions.db";
        var database = await openDatabase("$path");
        List<Map> content = await database.rawQuery(
        'SELECT * FROM Contents WHERE subject_id=?', 
        ['$subject_id']
        );
        return content;
        
    }catch(e){
      throw Exception(e);
    }
  }

  Future fetchOnlineContent({subject_id})async
  {
    try{
        var bodyData = {
            "subject_id" : "$subject_id",
          };
        final response = await http.post("${app_config["base_url"]}/fetch-content",body: bodyData);
        var decodedResponse = json.decode(response.body);
        if (response.statusCode == 200) {
            return decodedResponse;
        } else {
          throw Exception();
        }
    }catch(e){
      if(e is SocketException)
      {
        throw SocketException("$e");
        
      }
      throw Exception(e);
    }
  }

  Future fetchAllContents()async
  {
    try{
      print("getting all the contents");
        final response = await http.post("${app_config["base_url"]}/get-all-contents");
        var decodedResponse = json.decode(response.body);
        if (response.statusCode == 200) {
            return decodedResponse;
        } else {
          throw Exception();
        }
    }catch(e){
      if(e is SocketException)
      {
        throw SocketException("$e");
        
      }
      throw Exception(e);
    }
  }


  
  saveToSubjectsTable(subjects,database)async
  {
      try
      {
        var count = Sqflite.firstIntValue(await database.rawQuery('SELECT COUNT(*) FROM Subjects'));
        print("The total no. of records in Subjects before saving  : $count");
        await database.transaction((txn) async {
        subjects.forEach((subject)async{ 
        int id1 = await txn.rawInsert(
          'INSERT INTO Subjects(`faculty_code`,`semester_id`,`subject_id`,`subject_name`) VALUES(?,?,?,? )',["${subject["faculty_code"]}","${subject["semester_id"]}","${subject["subject_id"]}","${subject["subject_name"]}"]);
          print('inserted into Subjects: $id1');
          });
        });
        var count2 = Sqflite.firstIntValue(await database.rawQuery('SELECT COUNT(*) FROM Subjects'));
        print("The total no. of records in Subjects after saving  : $count2");
        // var del= await database.rawDelete('DELETE FROM Subjects WHERE id > ?',[1]);
        // var count2 = Sqflite.firstIntValue(await database.rawQuery('SELECT COUNT(*) FROM Subjects'));
      }
      catch(error)
      {
        print("Error inserting into Subjects Table : $error");
      }
  }


  saveToContentsTable(contents,database)async
  {
    print("Now adding contents");
    try{
      var count = Sqflite.firstIntValue(await database.rawQuery('SELECT COUNT(*) FROM Contents'));
        print("The total no. of records in Contents before saving  : $count");
        await database.transaction((txn)async{
        for(var content in contents){
        int id1 = await txn.rawInsert(
          'INSERT INTO Contents(`subject_id`,`subject_content`) VALUES(?,?)',["${content["subject_id"]}","${content["subject_content"]}"]);
          print('inserted into Contents: $id1');
        }
      });
      var count2 = Sqflite.firstIntValue(await database.rawQuery('SELECT COUNT(*) FROM Contents'));
        print("The total no. of records in Contents after saving  : $count2");
    }
    catch(e)
    {
      print("Error inserting in contents : $e");
    }
   }







}