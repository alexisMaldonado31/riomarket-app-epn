import 'dart:async';

import 'package:riomarket/Providers/class/total.dart';
import 'package:riomarket/Providers/db_provider.dart';
import 'package:riomarket/Providers/models/itemCarrito_model.dart';

import '../preferences.dart';
import 'carrito_bloc.dart';

class ItemsCarritoBloc {
  static final ItemsCarritoBloc _singleton = new ItemsCarritoBloc._internal();
  final carritoBloc = new CarritoBloc();
  final _pref = new Preferences();

  factory ItemsCarritoBloc() {
    return _singleton;
  }

  ItemsCarritoBloc._internal() {
    obtenerItemsCarrito();
  }

  final _itemsCarritoController =
      StreamController<List<ItemCarritoModel>>.broadcast();
  final _totalCarritoController = StreamController<Total>.broadcast();
  final _descuentoCarritoController = StreamController<double>.broadcast();

  Stream<List<ItemCarritoModel>> itemsCarritoStream() {
    obtenerItemsCarrito();
    return _itemsCarritoController.stream;
  }

  dispose() {
    _itemsCarritoController?.close();
    _totalCarritoController?.close();
    _descuentoCarritoController?.close();
  }

  Stream<Total> totalCarritoStream() {
    obtenerTotalCarrito();
    return _totalCarritoController.stream;
  }

  Stream<double> obtenerDescuentoCarritoStream() {
    obtenerDescuentoCarrito();
    return _descuentoCarritoController.stream;
  }

  obtenerItemsCarrito() async {
    _itemsCarritoController.sink.add(await DBProvider.db.getAllItemsCarrito());
  }

  obtenerTotalCarrito() async {
    _totalCarritoController.sink.add(await DBProvider.db.totalCarrito());
  }

  obtenerDescuentoCarrito() async {
    final total = await DBProvider.db.totalCarrito();
    double descuento = 0;
    String _tipoDescuento = _pref.tipoDescuento ?? '';
    if (total.totalCarrito() < _pref.cantidadMinimaDescuento) {
      descuento = 0;
    } else if (_tipoDescuento == 'percent') {
      descuento = total.totalCarrito() * (_pref.descuentoCupon ?? 0);
    } else {
      descuento = (_pref.descuentoCupon ?? 0);
    }
    _descuentoCarritoController.sink.add(descuento ?? 0.0);
  }

  Future<int> agregarItemCarrito(ItemCarritoModel itemCarrito) async {
    int idItemCarrito =
        await DBProvider.db.existeProductoEnCarrito(itemCarrito.idProducto);
    int resIdItemCarrito = 0;
    if (idItemCarrito == 0) {
      resIdItemCarrito = await DBProvider.db.nuevoItemCarrito(itemCarrito);
    } else {
      itemCarrito.idItemCarrito = idItemCarrito;
      await DBProvider.db.updateItemCarrito(itemCarrito);
      resIdItemCarrito = idItemCarrito;
    }
    obtenerItemsCarrito();
    carritoBloc.carritoStream();
    carritoBloc.itemAgregado();
    return resIdItemCarrito;
  }

  actualizarCantidadItemCarrito(
      ItemCarritoModel itemCarrito, int cambioCantidad) async {
    if (itemCarrito.cantidadProducto + cambioCantidad == 0) {
      await DBProvider.db.deleteItemCarrito(itemCarrito.idItemCarrito);
    } else {
      itemCarrito.cantidadProducto += cambioCantidad;
      await DBProvider.db.updateItemCarrito(itemCarrito);
    }
    obtenerItemsCarrito();
    carritoBloc.carritoStream();
  }

  borrarItemCarrito(int id) async {
    await DBProvider.db.deleteItemCarrito(id);
    obtenerItemsCarrito();
    carritoBloc.carritoStream();
  }

  borrarAllItemsCarrito() async {
    await DBProvider.db.deleteAllItemsCarrito();
    obtenerItemsCarrito();
  }
}
