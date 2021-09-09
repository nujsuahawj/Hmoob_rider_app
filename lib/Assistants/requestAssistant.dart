import 'dart:convert';

import 'package:http/http.dart' as http;
// ignore: unused_import
import 'package:http/http.dart';

class RequestAssistant {
  static Future<dynamic> getRequest(var url) async {
    // ignore: unused_local_variable
    http.Response response = await http.get(url);
    try{
      if (response.statusCode == 200) {
      // ignore: unused_local_variable
      String jSonData = response.body;
      // ignore: unused_local_variable
      var decodeData = jsonDecode(jSonData);
    } else {
      return "failed";
    }
    }catch(exp){
      return "failed";
    }
  }
}
