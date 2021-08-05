import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ioesolutions/src/admob/admob_manager.dart';
import 'package:ioesolutions/src/screens/pdf_loading_progress.dart';
import 'package:ioesolutions/src/screens/show_pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

import '../../app_config.dart';
import '../components/loading_indicator.dart';

const debug = true;

class ShowFolderContents extends StatefulWidget with WidgetsBindingObserver {
  final String folder_id;
  final String folder_name;
  ShowFolderContents({Key key, this.folder_id, this.folder_name})
      : super(key: key);

  @override
  _ShowFolderContentsState createState() => new _ShowFolderContentsState(
      folder_id: folder_id, folder_name: folder_name);
}

class _ShowFolderContentsState extends State<ShowFolderContents> {
  final String folder_id;
  final String folder_name;

  _ShowFolderContentsState({this.folder_id, this.folder_name});
  var error = {"hasError": false, "message": ""};
  _fetchFolderContents() async {
    try {
      var bodyData = {
        "folder_id": "$folder_id",
      };
      final response = await http.post(
          "${app_config["base_url"]}/get-folder-contents",
          body: bodyData);
          print ("the response is : $response");
      var decodedResponse = json.decode(response.body);
      if (response.statusCode == 200) {
        print("fetched data is : $decodedResponse");
        return decodedResponse;
      } else {
        setState(() {
          error["hasError"] = true;
          error["message"] = "An error occured. Please try again!";
        });
      }
    } catch (e) {
      if (e is SocketException) {
        setState(() {
          error["hasError"] = true;
          error["message"] = "No internet connection!";
        });
      }
      setState(() {
        error["hasError"] = true;
        error["message"] = "An error occured. Please try again!";
      });
    }
  }

  String _getFileName(filename) {
    if (filename.length > 50) {
      String final_name = filename.substring(0, 50);
      return final_name + " ...";
    }
    return filename;
  }

  String _getFileSize(sizeInBytes) {
    var filesize = (sizeInBytes / 1000000).toStringAsFixed(2);
    return "Size: $filesize mb";
  }

  _prepareSubjectsList() {
    for (int i = 0; i < extraContents.length; i++) {
      print("File id is : ${extraContents[i]["basename"]}");
      _documents.add({
        "name": extraContents[i]["name"],
        "link": "https://drive.google.com/uc?id=" + extraContents[i]["basename"] +"&export=download"
      });
    }
    
  }

  List<_TaskInfo> _tasks;
  List<_ItemHolder> _items;
  // bool _isLoading;
  bool _permissionReady;
  String _localPath;
  ReceivePort _port = ReceivePort();
  var _documents = [];
  var extraContents;
  var futureVar;
  @override
  void initState() {
    super.initState();
    print(extraContents);
    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback);

    // _isLoading = true;
    _permissionReady = false;
    futureVar = _fetchDataAndPrepare();
    // _prepareSubjectsList();
    // _prepare();
  }

  Future<String> _fetchDataAndPrepare() async {
    extraContents = await _fetchFolderContents();
    await _prepareSubjectsList();
    await _prepare();
    return "initial tasks completed";
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      if (debug) {
        print('UI Isolate Callback: $data');
      }
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];

      final task = _tasks?.firstWhere((task) => task.taskId == id);
      if (task != null) {
        setState(() {
          task.status = status;
          task.progress = progress;
        });
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    if (debug) {
      print(
          'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    }
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xff860000),
      body: SafeArea(
        top: false,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                iconTheme: IconThemeData(color: Colors.white),
                expandedHeight: 100 + screenHeight / 14,
                floating: true,
                pinned: true,
                elevation: 0.0,
                flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      "EXTRA CONTENTS",
                      style: TextStyle(fontSize: 17),
                    ),
                    // centerTitle: true,
                    collapseMode: CollapseMode.parallax,
                    background: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 0, color: Colors.white),
                        color: Colors.white,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xff860000),
                          border:
                              Border.all(width: 2, color: Color(0xff860000)),
                        ),
                      ),
                    )),
                backgroundColor: Color(0xff860000),
              ),
            ];
          },
          body: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40.0),
                  topLeft: Radius.circular(40.0),
                )),
            child: ListView(
                physics: AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 20, 20, 10),
                      child: ListTile(
                        leading: Image(
                          image: AssetImage("images/folder_icon.png"),
                          height: 30,
                        ),
                        title: Text(
                            "$folder_name",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                      ),
                  ),
                  Divider(),
                  FutureBuilder(
                    future: futureVar,
                    builder: (context, snapshot) {
                      if (error["hasError"] == true) {
                        return Center(
                          child: Container(
                              padding: const EdgeInsets.only(top: 20),
                              child: Text(error["message"])),
                        );
                      }
                      if (!snapshot.hasData) {
                        return Container(
                            padding: const EdgeInsets.only(top: 20),
                            child: loadingIndicator());
                      }
                      if (snapshot.hasData) {
                        return _permissionReady
                            ? _buildDownloadList()
                            : _buildNoPermissionWarning();
                      }
                    },
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  Widget _buildDownloadList() {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        if (_items[index].task == null) {
          return _myBuildListSection(index);
        }
        return DownloadItem(
          data: _items[index],
          onItemClick: (task) {
            if (task.status != DownloadTaskStatus.complete) {}
            _openDownloadedFile(task).then((success) {
              if (!success) {
                Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text('Cannot open this file')));
              }
            });
          },
          onAtionClick: (task) {
            if (task.status == DownloadTaskStatus.undefined ||
                task.status == DownloadTaskStatus.canceled) {
              _requestDownload(task);
            } else if (task.status == DownloadTaskStatus.running) {
              _pauseDownload(task);
            } else if (task.status == DownloadTaskStatus.paused) {
              _resumeDownload(task);
            } else if (task.status == DownloadTaskStatus.complete) {
              _delete(task);
            } else if (task.status == DownloadTaskStatus.failed) {
              _retryDownload(task);
            }
          },
        );
      },
      separatorBuilder: (context, index) {
        if ((index + 1) % 4 == 0) {
          return Column(
            children: <Widget>[Divider(), AdmobManager.finishBanner, Divider()],
          );
        }
        return Divider();
      },
    );
  }

  Widget _myBuildListSection(index) {
    return ListTile(
      onTap: () async {
        String pdf_path = await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => LoadPdfPage(
                filename: "${_documents[index]["name"]}",
                link: "${_documents[index]["link"]}")));
        if (pdf_path != "cancel") {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ShowPdf(pdf_path: pdf_path)));
        }
      },
      leading: Image(
        image: AssetImage("images/pdf_image.jpg"),
        height: 40.0,
      ),
      title: Text(_getFileName(_documents[index]["name"])),
      subtitle: Text(_getFileSize(_documents[index]["file_size"])),
      // trailing: Icon(Icons.keyboard_arrow_right),
    );
  }

  Widget _buildNoPermissionWarning() => Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Please grant accessing storage permission to continue -_-',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.blueGrey, fontSize: 18.0),
                ),
              ),
              SizedBox(
                height: 32.0,
              ),
              FlatButton(
                  onPressed: () {
                    _checkPermission().then((hasGranted) {
                      setState(() {
                        _permissionReady = hasGranted;
                      });
                    });
                  },
                  child: Text(
                    'Retry',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ))
            ],
          ),
        ),
      );

  void _requestDownload(_TaskInfo task) async {
    task.taskId = await FlutterDownloader.enqueue(
        url: task.link,
        savedDir: _localPath,
        showNotification: true,
        openFileFromNotification: true);
    Fluttertoast.showToast(
        msg: "Starting Download!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 12.0);
  }

  void _cancelDownload(_TaskInfo task) async {
    await FlutterDownloader.cancel(taskId: task.taskId);
  }

  void _pauseDownload(_TaskInfo task) async {
    await FlutterDownloader.pause(taskId: task.taskId);
  }

  void _resumeDownload(_TaskInfo task) async {
    String newTaskId = await FlutterDownloader.resume(taskId: task.taskId);
    task.taskId = newTaskId;
  }

  void _retryDownload(_TaskInfo task) async {
    String newTaskId = await FlutterDownloader.retry(taskId: task.taskId);
    task.taskId = newTaskId;
  }

  Future<bool> _openDownloadedFile(_TaskInfo task) {
    return FlutterDownloader.open(taskId: task.taskId);
  }

  void _delete(_TaskInfo task) async {
    await FlutterDownloader.remove(
        taskId: task.taskId, shouldDeleteContent: true);
    await _prepare();
    setState(() {});
  }

  Future<bool> _checkPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<Null> _prepare() async {
    final tasks = await FlutterDownloader.loadTasks();

    int count = 0;
    _tasks = [];
    _items = [];

    _tasks.addAll(_documents.map((document) =>
        _TaskInfo(name: document['name'], link: document['link'])));

    for (int i = count; i < _tasks.length; i++) {
      _items.add(_ItemHolder(name: _tasks[i].name, task: _tasks[i]));
      count++;
    }
    tasks?.forEach((task) {
      for (_TaskInfo info in _tasks) {
        if (info.link == task.url) {
          info.taskId = task.taskId;
          info.status = task.status;
          info.progress = task.progress;
        }
      }
    });

    _permissionReady = await _checkPermission();

    _localPath =
        (await _findLocalPath()) + Platform.pathSeparator + 'Extra_Contents';
    var savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
    // setState(() {
    //   _isLoading = false;
    // });
  }

  Future<String> _findLocalPath() async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }
}

class DownloadItem extends StatelessWidget {
  final _ItemHolder data;
  final Function(_TaskInfo) onItemClick;
  final Function(_TaskInfo) onAtionClick;

  DownloadItem({this.data, this.onItemClick, this.onAtionClick});
  _cancelThisDownload(task_id) async {
    await FlutterDownloader.cancel(taskId: task_id);
    Fluttertoast.showToast(
        msg: "Download cancelled!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 12.0);
  }

  String _getFileSize(sizeInBytes) {
    var filesize = (sizeInBytes / 1000000).toStringAsFixed(2);
    return "Size: $filesize mb";
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        if (data.task.status == DownloadTaskStatus.complete) {
          var ext_dir = await getExternalStorageDirectory();
          String file_path = ext_dir.path + "/Extra_Contents/" + data.task.name;
          print(file_path);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ShowPdf(
                    filename: "${data.task.name}",
                    pdf_path: file_path,
                  )));
        } else {
          String pdf_path = await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => LoadPdfPage(
                  filename: "${data.task.name}", link: "${data.task.link}")));
          if (pdf_path != "cancel") {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ShowPdf(
                    filename: "${data.task.name}", pdf_path: pdf_path)));
          }
        }
      },
      leading: Image(
        image: AssetImage("images/pdf_image.jpg"),
        height: 40.0,
      ),
      title: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 70.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text(
                    data.name,
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: _buildActionForTask(data.task),
                ),
              ],
            ),
          ),
          data.task.status == DownloadTaskStatus.running ||
                  data.task.status == DownloadTaskStatus.paused
              ? Positioned(
                  left: 0.0,
                  right: 0.0,
                  bottom: 0.0,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: LinearProgressIndicator(
                          value: data.task.progress / 100,
                        ),
                      ),
                      InkWell(
                          onTap: () => _cancelThisDownload(data.task.taskId),
                          child: Text(
                            "   Cancel  ",
                            style: TextStyle(color: Color(0xff860000)),
                          )),
                    ],
                  ),
                )
              : Container()
        ].where((child) => child != null).toList(),
      ),
    );
  }

  Widget _buildActionForTask(_TaskInfo task) {
    if (task.status == DownloadTaskStatus.undefined ||
        task.status == DownloadTaskStatus.canceled) {
      return PopupMenuButton(
            onSelected:(String value){ 
               onAtionClick(task);
              },
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: "download",
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.file_download,color:Colors.green,
                        ),
                        Text(
                          "  Download",
                        )
                      ],
                    )
              ),
            ],
          );
    } else if (task.status == DownloadTaskStatus.running) {
      return RawMaterialButton(
        onPressed: () {
          onAtionClick(task);
        },
        child: Icon(
          Icons.pause,
          color: Colors.red,
        ),
        shape: CircleBorder(),
        constraints: BoxConstraints(minHeight: 32.0, minWidth: 32.0),
      );
    } else if (task.status == DownloadTaskStatus.paused) {
      return RawMaterialButton(
        onPressed: () {
          onAtionClick(task);
        },
        child: Icon(
          Icons.play_arrow,
          color: Colors.green,
        ),
        shape: CircleBorder(),
        constraints: BoxConstraints(minHeight: 32.0, minWidth: 32.0),
      );
    } else if (task.status == DownloadTaskStatus.complete) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Ready',
            style: TextStyle(color: Colors.green),
          ),
          RawMaterialButton(
            onPressed: () {
              onAtionClick(task);
            },
            child: Icon(
              Icons.delete_forever,
              color: Colors.red,
            ),
            shape: CircleBorder(),
            constraints: BoxConstraints(minHeight: 32.0, minWidth: 32.0),
          )
        ],
      );
    } else if (task.status == DownloadTaskStatus.canceled) {
      return Text('Canceled', style: TextStyle(color: Colors.red));
    } else if (task.status == DownloadTaskStatus.failed) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('Failed', style: TextStyle(color: Colors.red)),
          RawMaterialButton(
            onPressed: () {
              onAtionClick(task);
            },
            child: Icon(
              Icons.refresh,
              color: Colors.green,
            ),
            shape: CircleBorder(),
            constraints: BoxConstraints(minHeight: 32.0, minWidth: 32.0),
          )
        ],
      );
    } else {
      return null;
    }
  }
}

class _TaskInfo {
  final String name;
  final String link;

  String taskId;
  int progress = 0;
  DownloadTaskStatus status = DownloadTaskStatus.undefined;

  _TaskInfo({this.name, this.link});
}

class _ItemHolder {
  final String name;
  final _TaskInfo task;

  _ItemHolder({this.name, this.task});
}
