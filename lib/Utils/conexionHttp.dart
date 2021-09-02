import 'dart:convert';

class ConexionHttp{
  static String username = 'G5QJBKNJVL5WC9PQMYTZGQPMMW4WF2KR';
  static String password = '';

  Map<String, String> header(){
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));
    Map<String, String> header = {      
      "Output-Format": "JSON",
      "authorization": basicAuth   
    }; 
    return header;
  }
}