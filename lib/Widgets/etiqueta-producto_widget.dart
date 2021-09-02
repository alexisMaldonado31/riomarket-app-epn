import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Etiqueta extends StatelessWidget {
  String mensaje;
  Color color;

  Etiqueta({this.mensaje, this.color});
  @override
  Widget build(BuildContext context) {
    double maxH = MediaQuery.of(context).size.height;
    double maxW = MediaQuery.of(context).size.height;  
    return Container(
      margin: EdgeInsets.all(5.0),
      height: maxH*0.04,
      width: maxH*0.12,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Text(
          mensaje,
          textScaleFactor: 1.0,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: maxW*0.022    
          ),
        ),
      ),
    );
  }
}