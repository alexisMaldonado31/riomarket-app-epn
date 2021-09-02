import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:riomarket/Pantallas/producto_descripcion_page.dart';

import 'package:riomarket/Providers/models/producto_model_service.dart';

import 'package:riomarket/Widgets/etiqueta-producto_widget.dart';
import 'package:riomarket/Widgets/precio-promocion_widget.dart';

import 'modal_informacion_producto.dart';

class CardProduct extends StatelessWidget {
  final ProductosModelService producto;

  CardProduct(this.producto);

  @override
  Widget build(BuildContext context) {
    double maxW = MediaQuery.of(context).size.width;
    double maxH = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {
        if (producto.stockQuantity > 0) {
          showDialog(
              context: context,
              builder: (BuildContext context) =>
                  ModalInformacionProducto(producto));
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: maxH * 0.03),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20), top: Radius.circular(20)),
            border: Border.all(color: Colors.grey[300])),
        height: maxH * 0.5,
        width: maxW * 0.45,
        child: Stack(children: <Widget>[
          Column(children: <Widget>[
            Container(
              height: maxH * 0.3,
              width: maxW * 0.3,
              margin: EdgeInsets.only(top: maxH * 0.01, bottom: maxH * 0.01),
              child: Column(
                children: <Widget>[
                  producto.stockQuantity == 0
                      ? Etiqueta(
                          mensaje: "¡Agotado!",
                          color: Colors.red,
                        )
                      : SizedBox(
                          height: maxH * 0.04,
                        ),
                  Expanded(
                      child: Container(
                    width: maxW * 0.3,
                    height: maxH * 0.25,
                    child: Hero(
                      tag: producto.name,
                      child: CachedNetworkImage(
                        imageUrl: producto.urlImage,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  )),
                  (producto.discount > 0)
                      ? Etiqueta(
                          mensaje: "¡En Oferta!",
                          color: Color(0xffe32659),
                        )
                      : SizedBox(
                          height: maxH * 0.04,
                        ),
                ],
              ),
            ),
            producto.discount > 0
                ? PrecioPromocion(
                    producto.priceWithDiscount,
                    producto.priceWithTax,
                    isHorizontal: false,
                  )
                : _precio(producto.priceWithTax, maxH),
            SizedBox(
              height: maxH * 0.01,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                width: maxW * 0.35,
                child: Text(
                  producto.name,
                  textScaleFactor: 1.0,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: maxW * 0.04, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Spacer()
          ]),
          Align(
            alignment: Alignment(1, -1),
            child: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                var route = new MaterialPageRoute(
                    builder: (BuildContext context) =>
                        new ProductoDescripcionPage(producto));
                Navigator.of(context).push(route);
              },
            ),
          ),
        ]),
      ),
    );
  }

  Widget _precio(double precio, double maxH) {
    return Container(
      height: maxH * 0.05,
      child: Text(
        '${precio.toStringAsFixed(2)} \$',
        textScaleFactor: 1.0,
        style: TextStyle(
          fontSize: maxH * 0.04,
          fontWeight: FontWeight.bold,
          color: Color(0xffe32659),
        ),
      ),
    );
  }
}
