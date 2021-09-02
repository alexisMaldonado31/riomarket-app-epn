import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riomarket/Providers/Services/paymentService.dart';
import 'package:riomarket/Providers/db_provider.dart';
import 'package:riomarket/Providers/models/revision_model.dart';
import 'package:riomarket/payment_method/card_method_bloc.dart';
import 'package:riomarket/payment_method/card_method_model.dart';
import 'package:riomarket/payment_method/card_method_provider.dart';
import 'package:riomarket/preferences.dart';

// ignore: must_be_immutable
class CardMethod extends StatefulWidget {
  RevisionModel _arguments;
  CardMethod(this._arguments);
  @override
  _CardMethodState createState() => _CardMethodState(this._arguments);
}

class _CardMethodState extends State<CardMethod> {
  bool _paymentInProcess = false;
  final RevisionModel _arguments;
  final _paymentService = PaymentServices();
  TextEditingController _name = TextEditingController();
  TextEditingController _number = TextEditingController();
  TextEditingController _mmyy = TextEditingController();
  TextEditingController _cvc = TextEditingController();

  _CardMethodState(this._arguments);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bloc = CardMethodBloc();
    return Container(
        padding: EdgeInsets.all(20),
        width: size.width,
        child: Column(
          children: <Widget>[
            _inputName(bloc),
            SizedBox(
              height: 5,
            ),
            Divider(),
            SizedBox(
              height: 5,
            ),
            _inputNumber(bloc),
            SizedBox(
              height: 5,
            ),
            Divider(),
            SizedBox(
              height: 5,
            ),
            Row(
              children: <Widget>[
                _inputMonthYear(size.width * 0.6, bloc),
                Expanded(
                  child: SizedBox(),
                ),
                _inputCVC(size.width * 0.7, bloc),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Divider(),
            SizedBox(
              height: 5,
            ),
            _buttonPayment(bloc),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _logoCard('assets/img/payment/pci.png'),
                SizedBox(
                  width: 5,
                ),
                _logoCard('assets/img/payment/mastercard.png'),
                SizedBox(
                  width: 5,
                ),
                _logoCard('assets/img/payment/visa.png')
              ],
            )
          ],
        ));
  }

  _inputName(CardMethodBloc bloc) {
    return StreamBuilder(
      stream: bloc.nameStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return TextField(
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.characters,
          controller: _name,
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              labelText: 'Nombre',
              hintText: 'NOMBRE APELLIDO',
              icon: Icon(Icons.person_outline),
              helperText: 'Nombre del titular de la tarjeta',
              errorText: snapshot.error),
          onChanged: bloc.changeName,
        );
      },
    );
  }

  _inputNumber(CardMethodBloc bloc) {
    return StreamBuilder(
      stream: bloc.numberStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return TextField(
          keyboardType: TextInputType.number,
          controller: _number,
          maxLength: 16,
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              labelText: 'Número de la tarjeta',
              icon: Icon(Icons.credit_card),
              hintText: 'XXXX XXXX XXXX XXXX',
              helperText: 'Número de la parte frontal de la tarjeta',
              errorText: snapshot.error),
          onChanged: bloc.changeNumber,
        );
      },
    );
  }

  _inputMonthYear(double w, CardMethodBloc bloc) {
    return StreamBuilder(
      stream: bloc.mmyyStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            width: w / 2,
            child: TextField(
                controller: _mmyy,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    labelText: 'MMAA',
                    icon: Icon(Icons.date_range),
                    hintText: 'MMAA',
                    errorText: snapshot.error,
                    errorStyle: TextStyle(fontSize: 8)),
                onChanged: bloc.changeMmyy));
      },
    );
  }

  _inputCVC(double w, CardMethodBloc bloc) {
    return StreamBuilder(
      stream: bloc.cvcStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            width: w / 2,
            child: TextField(
              controller: _cvc,
              keyboardType: TextInputType.number,
              obscureText: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  labelText: 'CVC',
                  icon: Icon(Icons.lock_outline),
                  hintText: 'CVS',
                  errorText: snapshot.error),
              onChanged: bloc.changeCvc,
            ));
      },
    );
  }

  _buttonPayment(CardMethodBloc bloc) {
    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Color(0xffff8357),
          onPressed: snapshot.hasData
              ? _paymentInProcess
                  ? null
                  : () async {
                      setState(() {
                        _paymentInProcess = true;
                      });

                      final _card = CardModel(
                          cvv: _cvc.text,
                          expiryMonth: _mmyy.text.substring(0, 2),
                          expiryYear: _mmyy.text.substring(2, 4),
                          name: _name.text,
                          number: _number.text);
                      final cardPayment = CardMethodModel(
                          card: _card,
                          currency: 'USD',
                          totalAmount: _arguments.amountPaid);
                      final resp = await Provider().postCardTocken(cardPayment);
                      if (resp.toString().isNotEmpty) {
                        widget._arguments.token = resp;
                        try {
                          if (await _paymentService
                              .postPedido(widget._arguments)) {
                            _pedidoFinalizado();
                          } else {
                            _dialog(context, 'Error en la transacción');
                          }
                          setState(() {
                            _paymentInProcess = false;
                          });
                        } catch (e) {
                          _dialog(context, 'Error en la transacción');
                          setState(() {
                            _paymentInProcess = false;
                          });
                        }
                      } else {
                        _dialog(context, 'Error en la transacción');
                        setState(() {
                          _paymentInProcess = false;
                        });
                      }
                    }
              : null,
          child: Container(
            height: 50,
            width: 100,
            alignment: Alignment.center,
            child: _paymentInProcess
                ? CircularProgressIndicator()
                : Text(
                    'Pagar \$ ${_arguments.amountPaid.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.white),
                    textScaleFactor: 1.0,
                  ),
          ),
        );
      },
    );
  }

  _logoCard(String image) {
    return Container(
        height: 20,
        width: 40,
        padding: EdgeInsets.symmetric(horizontal: 3, vertical: 4),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                  color: Colors.black26,
                  spreadRadius: 1,
                  offset: Offset(0.5, 0))
            ]),
        child: Image.asset(
          image,
        ));
  }

  _dialog(BuildContext context, String _text) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: Color(0xffe05c45),
            child: Container(
              height: 130,
              width: double.infinity,
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Text(
                    _text,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    textScaleFactor: 1.0,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.white,
                    onPressed: () {
                      setState(() {
                        _paymentInProcess = false;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      child: Text(
                        "Cerrar",
                        style: TextStyle(color: Colors.red),
                        textScaleFactor: 1.0,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  _pedidoFinalizado() async {
    final db = DBProvider.db;
    final _prefs = Preferences();
    await db.deleteAllItemsCarrito();
    _prefs.idCupon = 0;
    _prefs.descuentoCupon = 0.0;

    Navigator.of(context)
        .pushNamedAndRemoveUntil('home', (Route<dynamic> route) => false);
    showDialog(
        context: context,
        builder: (BuildContext context) => Material(
              type: MaterialType.transparency,
              child: Center(
                  // Aligns the container to center
                  child: Container(
                // A simplified version of dialog.
                width: 250,
                height: 370,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                        height: 320,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xffe05c45),
                            boxShadow: [
                              BoxShadow(color: Colors.black54, blurRadius: 10),
                            ]),
                        margin: EdgeInsets.only(top: 85),
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Container(
                                margin: EdgeInsets.only(top: 30),
                                child: Opacity(
                                  opacity: 0.2,
                                  child: Image.asset('assets/img/logo.png'),
                                )),
                            Container(
                              height: 320,
                              width: double.infinity,
                              padding:
                                  EdgeInsets.only(top: 70, left: 10, right: 10),
                              child: Column(
                                children: [
                                  Text(
                                    'Tu compra por un valor de \$ ${widget._arguments.amountPaid.toStringAsFixed(2)} realizada el ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} fue ingresada exitosamente.',
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                    textScaleFactor: 1.0,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Gracias por confiar en nosotros, nos pondremos en contacto contigo para coordinar la entrega.',
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                    textScaleFactor: 1.0,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    elevation: 10,
                                    color: Colors.white,
                                    textColor: Color(0xffe05c45),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child:
                                        Text('ACEPTAR', textScaleFactor: 1.0),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                    Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(150),
                            boxShadow: [
                              BoxShadow(color: Colors.black54, blurRadius: 10)
                            ],
                            color: Colors.red),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(75),
                          child: Image.asset(
                            'assets/img/fin.gif',
                            fit: BoxFit.contain,
                          ),
                        )),
                  ],
                ),
              )),
            ));
  }
}
