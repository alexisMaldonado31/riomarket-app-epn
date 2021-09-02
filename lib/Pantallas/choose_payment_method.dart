import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riomarket/Providers/Services/paymentService.dart';
import 'package:riomarket/Providers/db_provider.dart';
import 'package:riomarket/Providers/models/method_payment_model.dart';
import 'package:riomarket/Providers/models/payment_model.dart';
import 'package:riomarket/Providers/models/revision_model.dart';
import 'package:riomarket/Utils/payment_utils.dart';
import 'package:riomarket/payment_method/card_method.dart';
import 'package:riomarket/preferences.dart';

// ignore: must_be_immutable
class ChoosePaymentMethod extends StatefulWidget {
  PaymentModel arguments = PaymentModel();
  RevisionModel revision = RevisionModel();
  ChoosePaymentMethod(
      {Key key, @required this.arguments, @required this.revision})
      : super(key: key);
  @override
  _ChoosePaymentMethodState createState() => _ChoosePaymentMethodState();
}

bool cargando = false;

class _ChoosePaymentMethodState extends State<ChoosePaymentMethod> {
  final _methodPayment = PaymentServices();
  final _prefs = Preferences();
  List<MethodPaymentModel> metodosPago = List<MethodPaymentModel>();
  final utils = PaymentUtils();
  bool loading = true;
  @override
  void initState() {
    super.initState();
    cargando = false;
    _iniciarPaymentMethodPage();
  }

  void _iniciarPaymentMethodPage() async {
    await cargarMetodosPago();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Elegir método de pago', textScaleFactor: 1.0),
      ),
      body: loading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              child: cargando
                  ? Container(
                      height: double.infinity,
                      width: double.infinity,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ))
                  : ListView.builder(
                      itemCount: metodosPago.length,
                      itemBuilder: (context, index) {
                        return _itemPaymentMethod(metodosPago[index]);
                      },
                    ),
            ),
    );
  }

  _itemPaymentMethod(MethodPaymentModel model) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Card(
        elevation: 10,
        child: ListTile(
          leading: Icon(
            utils.cargarIconos(model.moduleName),
            size: 35,
            color: Color(0xffff8357),
          ),
          title: Text(
            model.displayName,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            textScaleFactor: 1.0,
          ),
          trailing: Text(
            '\$ ' + widget.revision.amountPaid.toStringAsFixed(2),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textScaleFactor: 1.0,
          ),
          onTap: () {
            confirmacionPago(model);
          },
        ),
      ),
    );
  }

  confirmacionPago(MethodPaymentModel model) {
    showDialog(
        context: context,
        builder: (_) {
          return Dialog(
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Container(
                padding: EdgeInsets.all(10),
                height: 200,
                width: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Acepta realizar la compra en StayHome market por un valor de \$ ${widget.revision.amountPaid.toStringAsFixed(2)}',
                        textScaleFactor: 1,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 10,
                          color: Colors.white,
                          textColor: Theme.of(context).primaryColor,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Atras'),
                        ),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 10,
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          onPressed: () {
                            Navigator.pop(context);
                            pagar(model);
                          },
                          child: Text('Aceptar'),
                        )
                      ],
                    )
                  ],
                ),
              ));
        });
  }

  pagar(MethodPaymentModel metodo) async {
    _iniciarPaymentMethodPage();
    setState(() {
      cargando = true;
    });

    widget.revision.paymentName = metodo.moduleName;
    widget.revision.amountPaid =
        double.parse(widget.revision.amountPaid.toStringAsFixed(2));
    print(metodo.idModulePayment);

    switch (metodo.idModulePayment) {
      case '30':
        {
          if (await _methodPayment.postPedido(widget.revision)) {
            pedidoFinalizado();
          }
          break;
        }
      case '88':
        {
          if (await _methodPayment.postPedido(widget.revision)) {
            pedidoFinalizado();
          }
          break;
        }
      case '82':
        {
          setState(() {
            cargando = false;
          });
          showDialog(
              context: context,
              builder: (BuildContext context) => SimpleDialog(
                    children: [
                      CardMethod(
                        widget.revision,
                      )
                    ],
                  ));
          break;
        }
      case '105':
        {
          setState(() {
            cargando = false;
          });
          break;
        }
      default:
        {
          setState(() {
            cargando = false;
          });
          break;
        }
    }
  }

  cargarMetodosPago() async {
    metodosPago = await _methodPayment.getMethodsPayment();

    setState(() {
      loading = false;
    });
  }

  pedidoFinalizado() async {
    final db = DBProvider.db;

    await db.deleteAllItemsCarrito();
    _prefs.idCupon = 0;
    _prefs.descuentoCupon = 0.0;
    _prefs.tipoDescuento = '';
    setState(() {
      cargando = true;
    });
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
                            color: Color(0xffe32659),
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
                                  //child: Image.asset('assets/img/logohorizontal.png'),
                                )),
                            Container(
                              height: 320,
                              width: double.infinity,
                              padding:
                                  EdgeInsets.only(top: 70, left: 10, right: 10),
                              child: Column(
                                children: [
                                  Text(
                                    'Tu compra por un valor de \$ ${widget.revision.amountPaid.toStringAsFixed(2)} realizada el ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} fue ingresada exitosamente.',
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
