import 'dart:convert';
import 'package:http/http.dart' as http show get, post;
import 'package:riomarket/Providers/models/method_payment_model.dart';
import 'package:riomarket/Providers/models/revision_model.dart';
import 'package:riomarket/Utils/endpoint.dart';

class PaymentServices {
  final _url = Endpoint().endpoint;
  Map<String, String> header = {
    'Accept': "application/json",
    'content-type': "application/x-www-form-urlencoded"
  };
  getMethodsPayment() async {
    List<MethodPaymentModel> lista = List<MethodPaymentModel>();

    final url = Uri.http(
      _url,
      'stayhome_app_services/formas_pago.php',
    );
    final respuesta = await http.get(
      url,
      headers: header,
    );

    List<dynamic> resp = json.decode(respuesta.body);
    resp.forEach((element) {
      final item = MethodPaymentModel.fromJson(element);
      lista.add(item);
    });
    return lista;
  }

  postPedido(RevisionModel model) async {
    final url = Uri.http(_url, 'stayhome_app_services/ingresar_orden.php');

    final respuesta =
        await http.post(url, body: model.toJson(), headers: header);
    final jsonResponse = json.decode(respuesta.body);
    try {
      if (int.parse(jsonResponse['id_address_delivery']) > 0 &&
          int.parse(jsonResponse['id_carrier']) > 0 &&
          int.parse(jsonResponse['id_cart']) > 0) {
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      return false;
    }
  }
}
