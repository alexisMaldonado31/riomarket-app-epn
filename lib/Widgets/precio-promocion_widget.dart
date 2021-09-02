import 'package:flutter/material.dart';

class PrecioPromocion extends StatelessWidget {
  final double precioDescuento; 
  final double precio;
  final bool isHorizontal;

  PrecioPromocion(this.precioDescuento, this.precio, {this.isHorizontal = true});

  @override
  Widget build(BuildContext context) {
    double maxH = MediaQuery.of(context).size.height;
    double maxW = MediaQuery.of(context).size.height;
    return isHorizontal ?
     Padding(
        padding: EdgeInsets.only(
          left: maxW*0.01,
          right: maxW*0.01
      ),
       child: Container(
        height: maxH*0.05,
        width: maxW*0.3,
        margin: EdgeInsets.only(
          left: maxW*0.01,
          right: maxW*0.01
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '${precioDescuento.toStringAsFixed(2)} \$',
              textScaleFactor: 1.0,
              style: TextStyle(
                fontSize: maxH*0.03,
                color: Color(0xffe32659),
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(width: 10),
            Text(
              '${precio.toStringAsFixed(2)} \$',
              textScaleFactor: 1.0,
              style: TextStyle(
                fontSize: maxH*0.02,
                color: Colors.grey,
                decoration: TextDecoration.lineThrough
              ),
            ),
          ],
        ),
    ),
     )
    : Container(
      height: maxH*0.07,
      width: maxW*0.12,
      child: Column(
        children: <Widget>[
          Text(
            '${precioDescuento.toStringAsFixed(2)} \$',
            textScaleFactor: 1.0,
            style: TextStyle(
              fontSize: maxH*0.03,
              color: Color(0xffe32659),
              fontWeight: FontWeight.bold
            ),
          ),
          Spacer(),
          Text(
            '${precio.toStringAsFixed(2)} \$',
            textScaleFactor: 1.0,
            style: TextStyle(
              fontSize: maxH*0.024,
              color: Colors.grey,
              decoration: TextDecoration.lineThrough
            ),
          ),
        ],
      ),
    );
  }
}