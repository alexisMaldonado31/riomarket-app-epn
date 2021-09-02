import 'dart:convert';

import 'package:http/http.dart' as http show get, post;
import 'package:riomarket/Providers/models/address_model.dart';
import 'package:riomarket/Providers/models/address_register_model.dart';
import 'package:riomarket/Providers/models/register_model.dart';
import 'package:riomarket/Providers/models/user_model.dart';
import 'package:riomarket/Utils/conexionHttp.dart';
import 'package:riomarket/Utils/endpoint.dart';
import 'package:riomarket/Utils/login_utils.dart';
import '../../preferences.dart';

class LoginServices {
  final _url = Endpoint().endpoint;
  final pref = new Preferences();

  postLogin(String email, String password) async {
    Map<String, dynamic> body = {
      'email': email,
      'password': await LoginUtils().encryptPassword(password)
    };
    Map<String, String> header = {
      'Accept': "application/json",
      'content-type': "application/x-www-form-urlencoded"
    };
    UserModel userModel = UserModel();
    final url = Uri.http(_url, 'stayhome_app_services/login_cliente.php');
    try {
      final respuesta = await http.post(
        url,
        body: body,
        headers: header,
      );
      var jsonResponse = json.decode(respuesta.body);
      if (respuesta.body == 'false') {
        userModel.id = 0;
      } else {
        userModel = UserModel.fromJson(jsonResponse);
        pref.user = respuesta.body;
      }
    } catch (ex) {
      userModel.id = 0;
    }

    return userModel;
  }

  postRegister(RegisterModel registerModel) async {
    Map<String, String> header = {
      'Accept': "application/json",
      'content-type': "application/x-www-form-urlencoded"
    };
    UserModel userModel = UserModel();
    final url = Uri.http(_url, 'stayhome_app_services/ingresar_cliente.php');
    try {
      final respuesta = await http.post(
        url,
        body: registerModel.toJson(),
        headers: header,
      );

      var jsonResponse = json.decode(respuesta.body);
      if (respuesta.body == 'false') {
        userModel.id = 0;
        return false;
      } else {
        try {
          userModel = UserModel.fromJson(jsonResponse);
          pref.user = respuesta.body;
          return true;
        } catch (er) {
          return false;
        }
      }
    } catch (error) {
      return false;
    }
  }

  postAddress(AddressModel addressModel,
      {bool isDireccionFactura = false}) async {
    Map<String, String> header = {
      'Accept': "application/json",
      'content-type': "application/x-www-form-urlencoded"
    };
    addressModel.firstName = json.decode(pref.user)['firstname'];
    addressModel.lastName = json.decode(pref.user)['lastname'];
    final url = Uri.http(_url, 'stayhome_app_services/ingresar_direccion.php');
    final respuesta = await http.post(
      url,
      body: addressModel.toJson(),
      headers: header,
    );
    var jsonResponse = json.decode(respuesta.body);

    if (isDireccionFactura) pref.idDireccionFactura = jsonResponse['id'];

    return true;
  }

  postAddressUpdate(AddressModel addressModel,
      {bool isDireccionFactura = false}) async {
    Map<String, String> header = {
      'Accept': "application/json",
      'content-type': "application/x-www-form-urlencoded"
    };
    addressModel.firstName = json.decode(pref.user)['firstname'];
    addressModel.lastName = json.decode(pref.user)['lastname'];
    final url = Uri.http(_url, 'stayhome_app_services/ingresar_direccion.php');
    final respuesta = await http.post(
      url,
      body: addressModel.toJsonUpdate(),
      headers: header,
    );
    var jsonResponse = json.decode(respuesta.body);

    if (isDireccionFactura) pref.idDireccionFactura = jsonResponse['id'];

    return true;
  }

  getAddress(int costumerId) async {
    ListaAddressRegisterModel lista;
    List<AddressRegisterModel> listaResp = [];
    final url = Uri.http(_url, 'stayhome_app_services/direcciones',
        {'customer_id': costumerId.toString()});
    final respuesta = await http.get(url, headers: ConexionHttp().header());

    final jsonRes = json.decode(respuesta.body);
    try {
      lista = ListaAddressRegisterModel.fromJsonList(jsonRes);
    } catch (e) {
      //lista = AddressRegisterModel{addr};
    }
    return lista == null ? listaResp : lista.address;
  }
}
