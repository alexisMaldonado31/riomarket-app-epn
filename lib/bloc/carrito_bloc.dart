import 'dart:async';
import 'package:flutter/animation.dart';
import 'package:riomarket/Providers/db_provider.dart';

class CarritoBloc {
  static final CarritoBloc _singleton = new CarritoBloc._internal();

  factory CarritoBloc() {
    return _singleton;
  }

  CarritoBloc._internal() {
    obtenerCantidadItemsCarrito();
  }

  final _carritoController = StreamController<int>.broadcast();
  AnimationController _animationController;

  Stream<int> carritoStream() {
    obtenerCantidadItemsCarrito();
    return _carritoController.stream;
  }

  dispose() {
    _carritoController?.close();
  }

  obtenerCantidadItemsCarrito() async {
    _carritoController.sink.add(await DBProvider.db.getCountItemsCarrito());
  }

  itemAgregado() {
    try {
      _animationController.forward(from: 0.0);
    } catch (e) {}
  }

  set bounceController(AnimationController controller) {
    this._animationController = controller;
  }
}
