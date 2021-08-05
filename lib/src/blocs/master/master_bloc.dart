import 'dart:async';
import 'dart:io';

import 'package:ioesolutions/src/blocs/master/master_state.dart';
import 'package:ioesolutions/src/blocs/master/master_event.dart';
import 'package:bloc/bloc.dart';
import 'package:sqflite/sqflite.dart';

class MasterBloc extends Bloc<MasterEvent, MasterState> {
  @override
  MasterState get initialState => MasterInitial();

  @override
  Stream<MasterState> mapEventToState(MasterEvent event) async* {
    if (event is AppStarted) {
      yield MasterLoading();
      try {
        // database
        var databasesPath = await getDatabasesPath();
        print("Database path is : $databasesPath");
        String path = databasesPath + "/IoeSolutions.db";
        await openDatabase(path, version: 1,
            onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE IF NOT EXISTS Subjects (id INTEGER PRIMARY KEY AUTOINCREMENT,faculty_code TEXT,semester_id INTEGER,subject_id INTEGER,subject_name TEXT)');
          print("Subjects table created successfully!!");
          await db.execute(
              'CREATE TABLE IF NOT EXISTS Contents (id INTEGER PRIMARY KEY AUTOINCREMENT, subject_id INTEGER, subject_content TEXT)');
          print("Contents table created successfully!!");
          db.close();
        });
        yield LoadingComplete();
      } catch (error) {}
    }
  }
}
