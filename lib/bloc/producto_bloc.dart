import 'dart:async';

import 'package:riomarket/Providers/db_provider.dart';
import 'package:riomarket/Providers/models/producto_model.dart';

class ProductoBloc {
  static final ProductoBloc _singleton = new ProductoBloc._internal();

  factory ProductoBloc() {
    return _singleton;
  }

  ProductoBloc._internal();

  Future<List<ProductoModel>> obtenerProductosXNombre(String nombre) async {
    return DBProvider.db.getProductoXNombre(nombre);
  }

  agregarProducto(ProductoModel productoModel) async {
    await DBProvider.db.nuevoProducto(productoModel);
  }

  eliminarProductos() async {
    await DBProvider.db.deleteAllProductos();
  }
}
