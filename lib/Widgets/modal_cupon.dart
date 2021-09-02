import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:riomarket/Providers/Services/cuponService.dart';
import 'package:riomarket/Providers/models/cupon_model_service.dart';
import 'package:riomarket/bloc/itemsCarrito_bloc.dart';

import '../preferences.dart';

class ModalAgregarCupon extends StatefulWidget {
  final double subtotal;

  ModalAgregarCupon(this.subtotal);

  @override
  _ModalAgregarCuponState createState() => _ModalAgregarCuponState();
}

class _ModalAgregarCuponState extends State<ModalAgregarCupon> {
  bool cargando = false;

  final prefs = new Preferences();
  final itemsCarritoBloc = new ItemsCarritoBloc();
  final TextEditingController _editingController = new TextEditingController();
  CuponModelService cupon = new CuponModelService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Dialog(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Container(
        width: screenSize.width * 0.9,
        height: screenSize.height * 0.38,
        padding: EdgeInsets.symmetric(
            horizontal: screenSize.width * 0.04,
            vertical: screenSize.height * 0.03),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _editingController,
              decoration: InputDecoration(
                fillColor: Colors.orange,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintText: 'Ingresa el código de tu cupón',
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            RaisedButton(
              onPressed: () async {
                final customerId = json.decode(prefs.user)['id'];
                setState(() {
                  cargando = true;
                });
                FocusScope.of(context).requestFocus(new FocusNode());
                await prefs.initPrefs();
                cupon = await CuponService()
                    .getCupon(customerId, _editingController.text);
                setState(() {});
                prefs.idCupon = cupon.idCartRule;
                prefs.descuentoCupon = cupon.reductionPercent == 0
                    ? cupon.reductionAmount
                    : cupon.reductionPercent / 100;
                prefs.tipoDescuento =
                    cupon.reductionPercent == 0 ? 'amount' : 'percent';
                prefs.cantidadMinimaDescuento = cupon.minimumAmount;
                await itemsCarritoBloc.obtenerDescuentoCarrito();
                setState(() {
                  cargando = false;
                });
              },
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              shape: StadiumBorder(),
              child: Container(
                width: double.infinity,
                child: Center(
                    child: Text(
                  'Ingresa tú cupón',
                  textScaleFactor: 1,
                )),
              ),
            ),
            cargando
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : _mensajeCupon(cupon.minimumAmount, screenSize)
          ],
        ),
      ),
    );
  }

  Widget _mensajeCupon(double minimumAmount, Size screenSize) {
    if (minimumAmount == null) {
      return Container();
    }

    if (cupon.description == 'error') {
      return ListTile(
        leading: Icon(Icons.sentiment_very_dissatisfied, color: Colors.red),
        title: Text('Tú cupón no es válido', textScaleFactor: 1.0),
      );
    }

    if (cupon.minimumAmount > widget.subtotal) {
      return ListTile(
        leading: Icon(Icons.sentiment_neutral, color: Colors.yellow),
        title: Text(
          'Tú cupón ha sido agregado. Recuerda que el monto mínimo para el descuento es de ${cupon.minimumAmount} \$',
          textScaleFactor: 1.0,
          style: TextStyle(fontSize: screenSize.height * 0.02),
        ),
      );
    } else {
      return ListTile(
        leading: Icon(Icons.sentiment_very_satisfied, color: Colors.green),
        title: Text('Este cupón ha sido agregado a tú compra',
            textScaleFactor: 1.0),
      );
    }
  }
}
