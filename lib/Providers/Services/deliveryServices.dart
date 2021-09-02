import 'dart:convert';
import 'package:http/http.dart' as http show post;
import 'package:riomarket/Providers/models/delivery_model.dart';
import 'package:riomarket/Providers/models/payment_model.dart';
import 'package:riomarket/Utils/conexionHttp.dart';
import 'package:riomarket/Utils/endpoint.dart';
import '../../preferences.dart';

class DeliveryServices {
  final _url = Endpoint().endpoint;
  final pref = new Preferences();

  postDelivery(PaymentModel carrito) async {
    final url = Uri.http(_url, 'stayhome_app_services/ingresar_carro.php');
    final respuesta = await http.post(
      url,
      body: json.encode(carrito.toJson()),
      headers: ConexionHttp().header(),
    );
    DeliveryModel deliveryList =
        DeliveryModel.fromJson(json.decode(respuesta.body));
    return deliveryList;
  }
}
