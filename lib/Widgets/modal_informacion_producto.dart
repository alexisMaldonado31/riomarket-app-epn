import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:riomarket/Providers/db_provider.dart';
import 'package:riomarket/Providers/models/producto_model_service.dart';
import 'package:riomarket/Widgets/precio-promocion_widget.dart';
import 'package:riomarket/bloc/itemsCarrito_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ModalInformacionProducto extends StatefulWidget {
  final ProductosModelService producto;

  ModalInformacionProducto(this.producto);

  @override
  _ModalInformacionProducto createState() => _ModalInformacionProducto();
}

class _ModalInformacionProducto extends State<ModalInformacionProducto> {
  double cantidad = 1;
  final itemsCarritoBloc = new ItemsCarritoBloc();

  @override
  void initState() {
    cantidad = widget.producto.minimalQuantity.toDouble();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final carrito = Provider.of<CarritoProvider>(context);
    double maxH = MediaQuery.of(context).size.height;
    double maxW = MediaQuery.of(context).size.width;

    return FadeInUp(
      duration: Duration(milliseconds: 500),
      child: Dialog(
          backgroundColor: Color.fromRGBO(255, 255, 255, 1),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Container(
            height: maxH * 0.65,
            child: Column(
              children: <Widget>[
                Container(
                  width: maxW,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: maxW * 0.05,
                      vertical: maxH * 0.02,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: maxW * 0.45,
                          child: Text(
                            widget.producto.name,
                            textScaleFactor: 1,
                            style: TextStyle(
                                fontSize: maxW * 0.05,
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                        Spacer(),
                        widget.producto.discount > 0
                            ? PrecioPromocion(
                                widget.producto.priceWithDiscount,
                                widget.producto.priceWithTax,
                                isHorizontal: false,
                              )
                            : _precio(maxW, widget.producto.priceWithTax)
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: maxW * 0.05,
                      ),
                      child: Column(
                        children: <Widget>[
                          _producto(maxH, maxW),
                          _seleccionarCantidad(
                              maxW, widget.producto.priceWithDiscount, maxH),
                          Spacer(),
                          _acciones(widget.producto.priceWithTax),
                          Spacer()
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget _informacionProducto(double maxH, double maxW) {
    return Expanded(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: maxH * 0.02,
            ),
            Container(
              child: Text(
                widget.producto.descriptionShort,
                style: TextStyle(fontSize: maxW * 0.04),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                textScaleFactor: 1,
              ),
            ),
            SizedBox(
              height: maxH * 0.04,
            ),
            Container(
              child: Text(
                'Disponibles: ${widget.producto.stockQuantity.toString()}',
                style: TextStyle(fontSize: maxH * 0.025),
                textScaleFactor: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _acciones(double precioFinal) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        new FlatButton(
          padding: const EdgeInsets.only(top: 8.0),
          textColor: Color(0xffe32659),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: new Text(
            "Regresar",
            textScaleFactor: 1.2,
          ),
        ),
        new RaisedButton(
          color: Color(0xffe32659),
          textColor: Colors.white,
          onPressed: () async {
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
            Navigator.pop(context);
          },
          child: Center(
            child: Text(
              "Agregar",
              textScaleFactor: 1.2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _seleccionarCantidad(double maxW, double precioFinal, double maxH) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              "Cantidad:",
              style: TextStyle(
                fontSize: maxW * 0.05,
              ),
              textScaleFactor: 1,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Spacer(),
                  IconButton(
                      icon: Icon(Icons.remove_circle),
                      onPressed: _disminuirCantidad,
                      color: Color(0xffe32659)),
                  Text(
                    '${cantidad.toInt()}',
                    style: TextStyle(
                      fontSize: maxW * 0.05,
                    ),
                    textScaleFactor: 1,
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle),
                    onPressed: _aumentarCantidad,
                    color: Color(0xffe32659),
                  ),
                  Spacer()
                ],
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              'Total:',
              style: TextStyle(fontSize: maxW * 0.05),
              textScaleFactor: 1,
            ),
            Spacer(),
            Text(
              '${(widget.producto.priceWithDiscount * cantidad).toStringAsFixed(2)}',
              textScaleFactor: 1,
              style: TextStyle(
                  fontSize: maxH * 0.035,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffe32659)),
            ),
            Spacer()
          ],
        ),
      ],
    );
  }

  Widget _precio(double maxW, double precioFinal) {
    return Text(
      '${precioFinal.toStringAsFixed(2)} \$',
      textScaleFactor: 1,
      style: TextStyle(
          color: Color(0xffe32659),
          fontSize: maxW * 0.06,
          fontWeight: FontWeight.bold),
    );
  }

  Widget _imagenProducto(double maxH, double maxW) {
    return Container(
      width: maxW * 0.3,
      height: maxH * 0.25,
      child: CachedNetworkImage(
        imageUrl: widget.producto.urlImage,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.contain,
            ),
          ),
        ),
        placeholder: (context, url) =>
            Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }

  Widget _producto(double maxH, maxW) {
    return Row(
      children: <Widget>[
        _imagenProducto(maxH, maxW),
        SizedBox(
          width: maxW * 0.02,
        ),
        _informacionProducto(maxH, maxW)
      ],
    );
  }

  void _disminuirCantidad() {
    if (cantidad > 1) {
      cantidad--;
      setState(() {});
    }
  }

  void _aumentarCantidad() {
    if (cantidad < widget.producto.stockQuantity) {
      cantidad++;
      setState(() {});
    }
  }
}
