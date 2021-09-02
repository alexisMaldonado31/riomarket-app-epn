import 'dart:convert';
import 'package:http/http.dart' as http show get;

import 'package:riomarket/Providers/models/cupon_model_service.dart';
import 'package:riomarket/Utils/conexionHttp.dart';
import 'package:riomarket/Utils/endpoint.dart';

class CuponService {
  final _url = Endpoint().endpoint;

  Future<CuponModelService> getCupon(
      int idCustomerId, String codigoCupon) async {
    final url = Uri.http(_url, 'stayhome_app_services/cupon',
        {"customer_id": idCustomerId.toString(), "code": codigoCupon});

    final respuesta = await http.get(url, headers: ConexionHttp().header());
    CuponModelService cupon;

    try {
      cupon = new CuponModelService.fromJson(json.decode(respuesta.body));
    } catch (e) {
      cupon = new CuponModelService.vacio();
    }

    return cupon;
  }
}
