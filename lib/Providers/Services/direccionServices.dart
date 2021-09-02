import 'dart:convert';

import 'package:http/http.dart' as http show get, post;
import 'package:riomarket/Providers/models/address_model.dart';
import 'package:riomarket/Providers/models/address_register_model.dart';
import 'package:riomarket/Utils/endpoint.dart';

import '../../preferences.dart';

class DireccionService {
  final _url = Endpoint().endpoint;
  final _header = {'content-type': "application/x-www-form-urlencoded"};
  final pref = new Preferences();

  Future<List<AddressRegisterModel>> getDireccionesCliente(
      int idCustomer) async {
    final url = Uri.http(_url, 'stayhome_app_services/direcciones',
        {'customer_id': idCustomer.toString()});

    final res = await http.get(url, headers: _header);
    final direcciones = json.decode(res.body);
    final resDirecciones = new List<AddressRegisterModel>();
    try {
      if (!direcciones) {
        return [];
      }
    } catch (e) {
      for (var direccion in direcciones) {
        resDirecciones.add(AddressRegisterModel.fromJson(direccion));
      }
    }
    return resDirecciones;
  }

  Future<AddressRegisterModel> getDireccionXId(String id) async {
    final url =
        Uri.http(_url, 'stayhome_app_services/direcciones', {'address_id': id});

    final res = await http.get(url, headers: _header);
    return AddressRegisterModel.fromJson(json.decode(res.body));
  }

  Future<bool> actualizarDireccion(AddressModel addressModel,
      {bool isDireccionFactura = false}) async {
    Map<String, String> header = {
      'Accept': "application/json",
      'content-type': "application/x-www-form-urlencoded"
    };
    //addressModel.firstName = json.decode(pref.user)['firstname'];
    //addressModel.lastName = json.decode(pref.user)['lastname'];
    final url = Uri.http(_url, 'stayhome_app_services/ingresar_direccion.php');
    final respuesta = await http.post(
      url,
      body: addressModel.toJsonUpdate(),
      headers: header,
    );
    var jsonResponse = json.decode(respuesta.body);

    if (isDireccionFactura)
      pref.idDireccionFactura = jsonResponse['id'].toString();

    return true;
  }
}
