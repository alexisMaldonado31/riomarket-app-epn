import 'dart:convert';

import 'package:http/http.dart' as http show get;
import 'package:riomarket/Utils/endpoint.dart';

class AppService {
  final _url = Endpoint().endpoint;
  Future<String> getVersion() async {
    final url = Uri.https(_url, 'stayhome_app_services/version');

    final respuesta = await http.get(url);

    var jsonResponse = json.decode(respuesta.body);

    return jsonResponse['version'];
  }
}
