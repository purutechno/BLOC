// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ioesolutions/src/screens/show_pdf.dart';
import 'package:path_provider/path_provider.dart';

import 'components/loading_indicator.dart';
class DownloadsPage extends StatefulWidget {
  @override
  _DownloadsPageState createState() => _DownloadsPageState();
}

class _DownloadsPageState extends State<DownloadsPage> {
var downloadedNotes = <FileSystemEntity>[];
var downloadedOldQuestions = <FileSystemEntity>[];
var downloadedExtraContents = <FileSystemEntity>[];
bool _isLoading = false;
bool _noteHasError = false;
bool _oldQuestionHasError = false;
bool _extraContentsHasError = false;
@override
void initState(){
  super.initState();
  setState(() {
    _isLoading = true;
  });
  getDownloadedContents();
}
getDownloadedContents()async
{
  try{
    downloadedNotes = await getDownloadedNotes();
  }catch(e)
  {
    setState(() {
      _noteHasError = true;
    });
  }
  try{
    downloadedOldQuestions = await getDownloadedOldQuestions();
    
  }catch(e)
  {
    setState(() {
      _oldQuestionHasError = true;
    });
  }
  try{
    downloadedExtraContents = await getDownloadedExtraContents();
    
  }catch(e)
  {
    setState(() {
      _extraContentsHasError = true;
    });
  }
  
  setState(() {
    _isLoading = false;
  });
}
Future<List<FileSystemEntity>> getDownloadedNotes()async {
  try{
    var files = <FileSystemEntity>[];
    var _localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Notes';
    var dir = Directory(_localPath);
    bool hasExisted = await dir.exists();
    if (!hasExisted) {
      dir.create();
    }
    var completer = Completer<List<FileSystemEntity>>();
    var lister = dir.list(recursive: false);
    lister.listen ( 
        (file) => files.add(file),
        // should also register onError
        onDone:   () => completer.complete(files)
        );
    return completer.future;
  }catch(e){
    setState(() {
      _noteHasError = true;
    });
  }
  
}
Future<List<FileSystemEntity>> getDownloadedOldQuestions()async {
  try{
    var files2 = <FileSystemEntity>[];
    var _localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Old_Questions';
    var dir = Directory(_localPath);
    bool hasExisted = await dir.exists();
    if (!hasExisted) {
      dir.create();
    }
    var completer = Completer<List<FileSystemEntity>>();
    var lister = dir.list(recursive: false);
    lister.listen ( 
        (file) => files2.add(file),
        // should also register onError
        onDone:   () => completer.complete(files2)
        );
    return completer.future;
  }catch(e){
    setState(() {
      _oldQuestionHasError = true;
    });
  }
  
}
Future<List<FileSystemEntity>> getDownloadedExtraContents()async {
  try{
    var files2 = <FileSystemEntity>[];
    var _localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Extra_Contents';
    var dir = Directory(_localPath);
    bool hasExisted = await dir.exists();
    if (!hasExisted) {
      dir.create();
    }
    var completer = Completer<List<FileSystemEntity>>();
    var lister = dir.list(recursive: false);
    lister.listen ( 
        (file) => files2.add(file),
        // should also register onError
        onDone:   () => completer.complete(files2)
        );
    return completer.future;
  }catch(e){
    setState(() {
      _extraContentsHasError = true;
    });
  }
  
}
Future<String> _findLocalPath() async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }
  @override
  Widget build(BuildContext context) {
    print(downloadedNotes);
    return DefaultTabController(
        length: choices.length,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff860000),
            title: const Text('Downloads'),
            bottom: TabBar(
              isScrollable: true,
              tabs: choices.map((Choice choice) {
                return Tab(
                  text: choice.title,
                );
              }).toList(),
            ),
          ),
          body: TabBarView(
            children: choices.map((Choice choice) {
              if(_isLoading)
              {
                return loadingIndicator();
              }
              if(choice.title == "Old Questions")
              {
                if(_oldQuestionHasError)
                {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal:15.0),
                      child: Text("An error occured. Please try again !",style: TextStyle(color: Colors.grey[600]),),
                    ),
                  );
                }else{
                  if(downloadedOldQuestions.length == 0)
                  {
                    return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left:15.0,),
                      child: Text("Old Questions collection is empty!",style: TextStyle(color: Colors.grey[600]),),
                    ),
                  );
                  }
                  return _showOldQuestionsList();
                }
                
              }
              else if(choice.title == "Notes"){
                if(_noteHasError)
                {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal:15.0),
                      child: Text("An error occured. Please try again !",style: TextStyle(color: Colors.grey[600]),),
                    ),
                  );
                }else{
                  if(downloadedNotes.length == 0)
                  {
                    return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal:15.0),
                      child: Text("Notes collection is empty!",style: TextStyle(color: Colors.grey[600]),),
                    ),
                  );
                  }
                  return _showNotesList();
                }
              }
              else if(choice.title == "Extra Contents"){
                if(_extraContentsHasError)
                {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal:15.0),
                      child: Text("An error occured. Please try again !",style: TextStyle(color: Colors.grey[600]),),
                    ),
                  );
                }else{
                  if(downloadedExtraContents.length == 0)
                  {
                    return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal:15.0),
                      child: Text("Extra Contents collection is empty!",style: TextStyle(color: Colors.grey[600]),),
                    ),
                  );
                  }
                  return _showExtraContentsList();
                }
              }
              
            }).toList(),
          ),
        ),
      );
    
  }
  Widget _showOldQuestionsList()
{
  return Container(
    padding: const EdgeInsets.only(top:30),
    child: ListView.separated(
      itemCount: downloadedOldQuestions.length,
      itemBuilder: (context,index){
        return ListTile(
          onTap: ()=>Navigator.of(context).push(MaterialPageRoute(
            builder: (context)=>ShowPdf(filename: _getFileNameForOldQuestion(downloadedOldQuestions[index].path),pdf_path: downloadedOldQuestions[index].path,)
          )),
          leading: Image(
              image: AssetImage("images/pdf_image.jpg"), 
              height: 50.0,
            ),
            title: Text(_getFileNameForOldQuestion(downloadedOldQuestions[index].path)),
            trailing: PopupMenuButton(
            onSelected: (String value)async{ 
              await _deleteThisFile(_getFileNameForOldQuestion(downloadedOldQuestions[index].path),"Old_Questions");
              },
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: "delete",
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.delete_forever,color:Colors.red,
                        ),
                        Text(
                          "  Delete",
                        )
                      ],
                    )
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
    return Divider();
  },
    ),
  );
}
_deleteThisFile(filename,file_type)async
{
  print("delete function called");
  var taskId = "_";
  var _localPath = (await _findLocalPath()) + Platform.pathSeparator + '$file_type';
  final tasks = await FlutterDownloader.loadTasks();
  tasks?.forEach((task) {
    if(task.filename == "$filename" && task.savedDir == "$_localPath")
    {
      taskId = task.taskId;
    }
  });
  if(taskId == "_")
    {
      var filePathDir = File(_localPath + "/$filename");
      await filePathDir.delete();
    }
    else{
      await FlutterDownloader.remove(taskId: taskId,shouldDeleteContent: true);
      
    }
    if(file_type == "Notes")
    {
      downloadedNotes = await getDownloadedNotes();
    }else if (file_type == "Old_Questions")
    {
      downloadedOldQuestions = await getDownloadedOldQuestions();
    }else if(file_type == "Extra_Contents")
    {
      downloadedExtraContents = await getDownloadedExtraContents();
    }
    setState(() {
    Fluttertoast.showToast(
              msg: "File Deleted!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 12.0);
    });
}
  Widget _showNotesList()
{
  return Container(
    padding: const EdgeInsets.only(top:30),
    child: ListView.separated(
      itemCount: downloadedNotes.length,
      itemBuilder: (context,index){
        return ListTile(
          onTap: ()=>Navigator.of(context).push(MaterialPageRoute(
            builder: (context)=>ShowPdf(filename: _getFileNameForNote(downloadedNotes[index].path),pdf_path: downloadedNotes[index].path,)
          )),
          leading: Image(
              image: AssetImage("images/pdf_image.jpg"), 
              height: 50.0,
            ),
            title: Text(_getFileNameForNote(downloadedNotes[index].path)),
            trailing: PopupMenuButton(
            onSelected:(String value)async{ 
              await _deleteThisFile(_getFileNameForNote(downloadedNotes[index].path),"Notes");
              },
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: "delete",
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.delete_forever,color:Colors.red,
                        ),
                        Text(
                          "  Delete",
                        )
                      ],
                    )
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
    return Divider();
  },
    ),
  );
}
  Widget _showExtraContentsList()
{
  return Container(
    padding: const EdgeInsets.only(top:30),
    child: ListView.separated(
      itemCount: downloadedExtraContents.length,
      itemBuilder: (context,index){
        return ListTile(
          onTap: ()=>Navigator.of(context).push(MaterialPageRoute(
            builder: (context)=>ShowPdf(filename: _getFileNameForExtraContent(downloadedExtraContents[index].path),pdf_path: downloadedExtraContents[index].path,)
          )),
          leading: Image(
              image: AssetImage("images/pdf_image.jpg"), 
              height: 50.0,
            ),
            title: Text(_getFileNameForExtraContent(downloadedExtraContents[index].path)),
            trailing: PopupMenuButton(
            onSelected:(String value)async{ 
              await _deleteThisFile(_getFileNameForExtraContent(downloadedExtraContents[index].path),"Extra_Contents");
              },
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: "delete",
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.delete_forever,color: Colors.red,
                        ),
                        Text(
                          "  Delete",
                        )
                      ],
                    )
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
    return Divider();
  },
    ),
  );
}
String _getFileNameForNote(filepath)
{
  var index = filepath.indexOf("/Notes/");
  print("Index of /Notes/ is : $index");
  var filename = filepath.substring(index+7);
  print("Filename for Note is : $filename");
  return "$filename";
}
String _getFileNameForOldQuestion(filepath)
{
  var index = filepath.indexOf("/Old_Questions/");
  print("Index of /Old_Questions/ is : $index");
  var filename = filepath.substring(index+15);
  print("Filename for Old_Questions is : $filename");
  return "$filename";
}
String _getFileNameForExtraContent(filepath)
{
  var index = filepath.indexOf("/Extra_Contents/");
  print("Index of /Extra_Contents/ is : $index");
  var filename = filepath.substring(index+16);
  print("Filename for Extra_Contents is : $filename");
  return "$filename";
}
}

class Choice {
  const Choice({this.title});

  final String title;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Notes'),
  const Choice(title: 'Old Questions'),
  const Choice(title: 'Extra Contents'),
];



