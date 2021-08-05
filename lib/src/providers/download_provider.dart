import 'dart:convert';
import 'dart:io';
import 'package:ioesolutions/src/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:ioesolutions/src/helper_functions.dart';

class DownloadProvider
{
  Future loadPdfOnline({file_id})async
  {
    try{
        var downloadLink = getGoogleDriveDownloadLink(fileId: file_id);
        
    }catch(e){
      if(e is SocketException)
      {
        throw SocketException("$e");
        
      }
      throw Exception(e);
    }
  }
}

