import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:toast/toast.dart';

import 'package:riomarket/bloc/itemsCarrito_bloc.dart';

import 'package:riomarket/Providers/models/itemCarrito_model.dart';
import 'package:riomarket/Providers/models/producto_model_service.dart';

import 'package:riomarket/Widgets/bottomsheet_carrito_widget.dart';
import 'package:riomarket/Widgets/carrito-compra_widget.dart';

class ProductoDescripcionPage extends StatefulWidget {
  final ProductosModelService producto;

  ProductoDescripcionPage(this.producto);
  @override
  _ProductoDescripcionPageState createState() =>
      _ProductoDescripcionPageState();
}

class _ProductoDescripcionPageState extends State<ProductoDescripcionPage> {
  int cantidad = 0;
  final itemsCarritoBloc = new ItemsCarritoBloc();

  @override
  void initState() {
    cantidad = widget.producto.minimalQuantity;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      key: Key('descripcionProducto'),
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: <Widget>[
          _bottomSheetCarrito(context, primaryColor, screenSize.height)
        ],
      ),
      body: Container(
        width: screenSize.width,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20.0,
            ),
            _titulo(screenSize.width),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(
                  width: screenSize.width * 0.05,
                ),
                _imagenProducto(screenSize, widget.producto.urlImage, context),
                SizedBox(
                  width: screenSize.width * 0.05,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    height: screenSize.height * 0.4,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 10.0,
                        ),
                        widget.producto.discount > 0
                            ? _precioPromocion(
                                widget.producto.priceWithDiscount,
                                widget.producto.priceWithTax,
                                screenSize.width)
                            : _precio(widget.producto.priceWithDiscount,
                                screenSize.width),
                        Container(
                          width: screenSize.width * 0.35,
                          child: Text("Impuestos Incluidos",
                              textScaleFactor: 1.0,
                              style: Theme.of(context).textTheme.caption),
                        ),
                        Spacer(),
                        _cambiarCantidad(screenSize.width),
                        _botonAgregarCarrito()
                      ],
                    ),
                  ),
                )
              ],
            ),
            Expanded(
                child: _descripcion(
                    widget.producto.descriptionShort, screenSize.width)),
          ],
        ),
      ),
    );
  }

  Widget _imagenProducto(Size screenSize, String url, BuildContext context) {
    return Hero(
      tag: widget.producto.name,
      child: Container(
        width: screenSize.width * 0.5,
        height: screenSize.height * 0.4,
        margin: EdgeInsets.only(bottom: 10.0),
        child: CachedNetworkImage(
          imageUrl: url,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          placeholder: (context, url) => Center(
              child: CircularProgressIndicator(
            backgroundColor: Theme.of(context).primaryColor,
          )),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }

  Widget _bottomSheetCarrito(
      BuildContext context, Color primaryColor, double height) {
    return InkWell(
        borderRadius: BorderRadius.circular(500),
        onTap: () {
          showModalBottomSheet(
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(20),
              ),
              isScrollControlled: true,
              builder: (BuildContext context) => Container(
                    height: height * 0.65,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border(top: BorderSide(color: Colors.black12)),
                    ),
                    child: BottomSheetCarrito(primaryColor),
                  ));
        },
        child: Carrito(
          colorCarrito: Colors.white,
        ));
  }

  Widget _descripcion(String descripcion, double width) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Container(
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Descripción:',
                textScaleFactor: 1.0,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xffe32659),
                    fontSize: 20),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(descripcion,
                  textScaleFactor: 1.0,
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 15)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _precio(double precio, double maxH) {
    return Container(
      height: maxH * 0.1,
      child: Text(
        '${precio.toStringAsFixed(2)} \$',
        textScaleFactor: 1.0,
        style: TextStyle(
          fontSize: maxH * 0.08,
          fontWeight: FontWeight.bold,
          color: Color(0xffe32659),
        ),
      ),
    );
  }

  Widget _precioPromocion(
      double precioPromocion, double precioOriginal, double maxH) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '${precioPromocion.toStringAsFixed(2)} \$',
            textScaleFactor: 1.0,
            style: TextStyle(
              fontSize: maxH * 0.06,
              fontWeight: FontWeight.bold,
              color: Color(0xffe32659),
            ),
          ),
          Text(
            '${precioOriginal.toStringAsFixed(2)} \$',
            textScaleFactor: 1.0,
            style: TextStyle(
                fontSize: maxH * 0.04,
                color: Colors.grey,
                decoration: TextDecoration.lineThrough),
          ),
        ],
      ),
    );
  }

  Widget _cambiarCantidad(double maxW) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Cantidad:',
            textScaleFactor: 1.0,
            style: TextStyle(fontSize: maxW * 0.05, color: Color(0xffe32659)),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconButton(
                onPressed: widget.producto.stockQuantity == 0
                    ? null
                    : () {
                        if (cantidad > 1) {
                          cantidad--;
                          setState(() {});
                        }
                      },
                color: Color(0xffe32659),
                icon: Icon(
                  Icons.remove_circle,
                  size: maxW * 0.075,
                ),
              ),
              Spacer(),
              Text(
                cantidad.toString(),
                textScaleFactor: 1.0,
                style: TextStyle(fontSize: maxW * 0.05),
              ),
              Spacer(),
              IconButton(
                onPressed: widget.producto.stockQuantity == 0
                    ? null
                    : () {
                        if (cantidad < widget.producto.stockQuantity) {
                          cantidad++;
                          setState(() {});
                        }
                      },
                icon: Icon(
                  Icons.add_circle,
                  color: Color(0xffe32659),
                  size: maxW * 0.075,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _botonAgregarCarrito() {
    return Container(
      width: double.infinity,
      child: RaisedButton(
        onPressed: widget.producto.stockQuantity > 0
            ? () async {
                var itemCarrito = new ItemCarritoModel(
                    idProducto: widget.producto.idProduct,
                    cantidadProducto: cantidad.toInt(),
                    stock: widget.producto.stockQuantity,
                    precioProducto: widget.producto.priceWithouthTax,
                    precioIva: widget.producto.priceWithTax -
                        widget.producto.priceWithouthTax,
                    precioDescuento: widget.producto.discount,
                    descripcionProducto: widget.producto.name,
                    imagenUrl: widget.producto.urlImage);
                await itemsCarritoBloc.agregarItemCarrito(itemCarrito);
                Toast.show("Producto Agregado", context,
                    duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
              }
            : null,
        color: Color(0xffe32659),
        child: Text(
          'Agregar',
          textScaleFactor: 1.0,
        ),
        textColor: Colors.white,
      ),
    );
  }

  _titulo(double width) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Text(
        widget.producto.name,
        textScaleFactor: 1.0,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: width * 0.05),
      ),
    );
  }
}
