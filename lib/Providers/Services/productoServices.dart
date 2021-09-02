import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http show get;
import 'package:riomarket/Providers/models/producto_model.dart';
import 'package:riomarket/Providers/models/producto_model_service.dart';

import 'package:riomarket/Utils/conexionHttp.dart';
import 'package:riomarket/Utils/endpoint.dart';

class ProductoServices {
  final _url = Endpoint().endpoint;

  Future<List<ProductoModel>> getProductos() async {
    final url = Uri.http(_url, 'stayhome_app_services/productos2');

    final respuesta = await http.get(url, headers: ConexionHttp().header());

    var jsonResponse = json.decode(respuesta.body);
    List<ProductoModel> list = new List<ProductoModel>();
    if (jsonResponse.length > 0) {
      for (var item in jsonResponse) {
        list.add(ProductoModel.fromJsonHttp(item));
      }
    }

    return list;
  }

  Future<List<ProductosModelService>> getProductoXCategoria(
      {@required int categoriaId,
      @required int start,
      String orderBy = 'name',
      String orderWay = 'ASC'}) async {
    final url = Uri.http(_url, 'stayhome_app_services/productos2', {
      "category_id": categoriaId.toString(),
      "order_by": orderBy,
      "order_way": orderWay,
      "start": start.toString(),
      "limit": '20',
    });

    final respuesta = await http.get(url, headers: ConexionHttp().header());

    var jsonResponse = json.decode(respuesta.body);
    List<ProductosModelService> list = new List<ProductosModelService>();
    if (jsonResponse.length > 0) {
      for (var item in jsonResponse) {
        list.add(ProductosModelService.fromJson(item));
      }
    }

    return list;
  }

  Future<ProductosModelService> getProductoXId(int productoId) async {
    final url = Uri.http(_url, 'stayhome_app_services/productos2',
        {"product_id": productoId.toString()});

    final respuesta = await http.get(url, headers: ConexionHttp().header());

    return ProductosModelService.fromJson(json.decode(respuesta.body));
  }
}
