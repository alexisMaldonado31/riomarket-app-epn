import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:riomarket/payment_method/card_method_model.dart';

class Provider {
  final _keyPublic = "b7dd4b4f32d5486890e96c2d47cc4884";
  final _url = 'https://api.kushkipagos.com/card/v1/tokens';
  Future<String> postCardTocken(CardMethodModel cardModel) async {
    Map<String, String> mapHeader = {
      "public-merchant-id": _keyPublic,
      "content-type": "application/json"
    };

    final res = await http.post(_url,
        body: json.encode(cardModel.toJson()), headers: mapHeader);
    final jsonResponse = json.decode(res.body);
    if (res.statusCode == 201) {
      return jsonResponse['token'];
    } else {
      return '';
    }
  }
}
