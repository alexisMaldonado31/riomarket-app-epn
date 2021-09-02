import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http show get;
import 'package:riomarket/Providers/models/categoria_model_service.dart';
import 'dart:convert';
import 'package:riomarket/Utils/conexionHttp.dart';
import 'package:riomarket/Utils/endpoint.dart';

class CategoriaServices {
  final _url = Endpoint().endpoint;

  Future<List<CategoriaModelService>> _procesarRespuestaCategoria(
      Uri url) async {
    List<CategoriaModelService> categorias = new List<CategoriaModelService>();
    final respuesta = await http.get(url, headers: ConexionHttp().header());
    var res = json.decode(respuesta.body);
    if (res.length > 0) {
      for (var categoria in res) {
        if (int.parse(categoria["id_category"]) != 17) {
          categorias.add(new CategoriaModelService.fromJson(categoria));
        }
      }
    }

    return categorias;
  }

  Future<List<CategoriaModelService>> getCategorias() async {
    final url = Uri.http(_url, 'stayhome_app_services/categorias2');

    return _procesarRespuestaCategoria(url);
  }

  Future<List<CategoriaModelService>> getSubCategoriasXPadre(
      int categoriaId) async {
    final url = Uri.http(_url, 'stayhome_app_services/categorias2',
        {"parent_id": categoriaId.toString()});
    List<CategoriaModelService> categorias =
        await _procesarRespuestaCategoria(url);

    categorias.insert(
        0,
        CategoriaModelService(
          idCategory: categoriaId.toString(),
          name: "Todos",
        ));

    return categorias;
  }

  Future<CategoriaModelService> getCategoriaXId(int categoriaId) async {
    final url = Uri.http(_url, 'stayhome_app_services/categoria',
        {"category_id": categoriaId.toString()});

    final respuesta = await http.get(url, headers: ConexionHttp().header());
    final res = json.decode(respuesta.body);

    return CategoriaModelService.fromJson(res);
  }

  Future<int> status(int categoriaId) async {
    final url = Uri.http(_url, 'stayhome_app_services/categoria',
        {"category_id": categoriaId.toString()});
    int respuesta;
    try {
      final res = await http
          .get(url, headers: ConexionHttp().header())
          .timeout(Duration(seconds: 10));
      respuesta = res.statusCode;
    } on SocketException catch (_) {
      respuesta = 0;
    } on TimeoutException catch (_) {
      respuesta = 0;
    }
    return respuesta;
  }
}
