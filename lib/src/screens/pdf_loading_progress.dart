import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'components/loading_indicator.dart';

class LoadPdfPage extends StatefulWidget {
  LoadPdfPage({Key key,@required this.filename,@required this.link}) : super(key: key);

  final String filename;
  final String link;

  @override
  _LoadPdfPageState createState() =>
      _LoadPdfPageState(fileLink: link, filename: filename);
}

class _LoadPdfPageState extends State<LoadPdfPage> {
  _LoadPdfPageState({this.fileLink, this.filename});
  String fileLink;
  String filename;
  bool _permissionReady;
  String _downloadPath;
  var _cancelToken;
  Dio dio;
  String progress = '0';
  int receivedBytes = 0;
  bool _isLoading = true;
  var error = {
    "hasError": false,
    "message":""
  };
  @override
  void initState() {
    super.initState();
    _prepare();
  }

  _prepare() async {
    setState(() {
      _isLoading = true;
    });
    dio = Dio();
    _permissionReady = await _checkPermission();
    var localPath = await _findLocalPath();
    _downloadPath = "$localPath/temp";

    final savedDir = Directory(_downloadPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
    if (_permissionReady) {
      downloadFile();
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<String> _findLocalPath() async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
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
  Future<void> downloadFile() async {
    // String savePath = await getFilePath(fileName);

    _cancelToken = CancelToken();
    try
    {
      dio.download(
      fileLink,
      _downloadPath + "/temp.pdf",
      cancelToken: _cancelToken,
      onReceiveProgress: (rcv, total) {
        receivedBytes = rcv;
        print(
            'received: ${rcv.toStringAsFixed(0)} out of total: ${total.toStringAsFixed(0)}');
        if (mounted) {
          setState(() {
            progress = ((rcv / total) * 100).toStringAsFixed(0);
          });
        }
      },
      deleteOnError: true,
    ).then((_) {
      if (mounted) {
        Navigator.pop(context, "$_downloadPath/temp.pdf");
      }
    });
    }catch(e)
    {
      if(e is SocketException)
      {
        setState(() {
          error["hasError"] = true;
          error["message"] = "Error: No Internet Connection!";
        });
      }
      else{
        setState(() {
          error["hasError"] = true;
          error["message"] = "Error: Cannot load file. Please try again!";
        });
      }

    }
    
  }
  
  @override
  Widget build(BuildContext context) {
    print('build running');

    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        _cancelToken?.cancel("cancelled");
        Navigator.pop(context, "cancel");
      },
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Color(0xff860000),
          title: Text(
            "$filename",
            style: TextStyle(fontSize: 15),
          ),
        ),
        body: Center(
            child: _isLoading
                ? loadingIndicator()
                : _permissionReady
                    ? _showDownloadingWidget()
                    : _buildNoPermissionWarning()),
      ),
    );
  }

  Widget loadingInMb() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
          height: 30,
          width: 30,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey[600]),
          ),
        ),
          ],
        ),
        
        SizedBox(height:15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
          (receivedBytes / 1048576).toStringAsFixed(2) + " MB",
          style: TextStyle(
              fontSize: 21, color: Colors.green, fontWeight: FontWeight.w700),
        ),
          ],
        ),
        
      ],
    );
  }

  Widget loadingInPercentage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
          height: 30,
          width: 30,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey[600]),
          ),
        ),
          ],
        ),
        SizedBox(height:15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("$progress %",
          style: TextStyle(
              fontSize: 21, color: Colors.green, fontWeight: FontWeight.w700),
        ),
          ],
        ),
      ],
    );
  }
_showErrorMessage()
{
  return Center(
    child: Container(
      padding: const EdgeInsets.only(top:15,bottom:15),
      child: Text(error["message"],style: TextStyle(color: Colors.red),),
    ),
  );
}
  Widget _showDownloadingWidget() {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(10.0),
      child: Card(
        elevation: 5,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: Text("$filename",
                    style: TextStyle(
                      color: Colors.grey[900],
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,),
                    
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  error["hasError"]?_showErrorMessage():
                  int.parse(progress) < 0 ? loadingInMb() : loadingInPercentage(),
                ],
              ),
              
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: Text(
                  "Some files may take a while to load. This might be because of large file size or poor internet connection!",
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              )
            ]),
      ),
    );
  }
}
