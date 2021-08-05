import 'dart:convert';
import 'dart:io';

import 'package:ioesolutions/src/app_config.dart';
import 'package:http/http.dart' as http;

class HomepageProvider{

  Future fetchInitialData()async
  {
    try{
        
        final response = await http.post("${app_config["base_url"]}/get-homepage-data");
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
      print("Homepage Error : $e");
      throw Exception(e);
    }
  }


}