import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import 'package:riomarket/bloc/carrito_bloc.dart';

class Carrito extends StatefulWidget {
  final Color colorCarrito;
  final Color notificationColor;
  final Color numberColor;

  Carrito(
      {this.colorCarrito,
      this.notificationColor = Colors.red,
      this.numberColor = Colors.white});
  @override
  State<StatefulWidget> createState() {
    return _Carrito();
  }
}

class _Carrito extends State<Carrito> {
  final carritoBloc = new CarritoBloc();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double maxW = MediaQuery.of(context).size.width;
    double maxH = MediaQuery.of(context).size.height;
    return StreamBuilder(
        stream: carritoBloc.carritoStream(),
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (!snapshot.hasData) {
            return Container(
              child: Align(
                child: Icon(
                  Icons.shopping_cart,
                  size: maxH * 0.035,
                  color: widget.colorCarrito,
                ),
              ),
            );
          }

          final carrito = snapshot.data;

          return Container(
              width: maxW * 0.15,
              height: maxW * 0.13,
              margin: EdgeInsets.only(right: maxW * 0.01),
              child: Stack(
                children: <Widget>[
                  Container(
                    child: Align(
                      child: Icon(
                        Icons.shopping_cart,
                        size: maxH * 0.035,
                        color: widget.colorCarrito,
                      ),
                    ),
                  ),
                  carrito == 0
                      ? Container()
                      : Bounce(
                          controller: (controller) =>
                              carritoBloc.bounceController = controller,
                          from: 10,
                          child: Container(
                            width: maxW * 0.16,
                            height: maxW * 0.15,
                            child: Align(
                              alignment: Alignment(0.7, -0.7),
                              child: Container(
                                height: maxW * 0.06,
                                width: maxW * 0.06,
                                child: Center(
                                  child: Text(carrito.toString(),
                                      style: TextStyle(
                                          color: widget.numberColor,
                                          fontWeight: FontWeight.w900,
                                          fontSize: maxW * 0.03),
                                      textScaleFactor: 1.0),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: widget.notificationColor,
                                ),
                              ),
                            ),
                          ),
                        )
                ],
              ));
        });
  }
}
