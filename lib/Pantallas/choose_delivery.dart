import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:riomarket/Pantallas/choose_payment_method.dart';
import 'package:riomarket/Providers/Services/deliveryServices.dart';
import 'package:riomarket/Providers/models/delivery_model.dart';
import 'package:riomarket/Providers/models/payment_model.dart';
import 'package:riomarket/Providers/models/revision_model.dart';

// ignore: must_be_immutable
class ChooseDelivery extends StatefulWidget {
  PaymentModel paymentModel = PaymentModel();
  RevisionModel revisionModel = RevisionModel();
  ChooseDelivery(this.paymentModel, this.revisionModel);
  @override
  _ChooseDeliveryState createState() => _ChooseDeliveryState();
}

class _ChooseDeliveryState extends State<ChooseDelivery> {
  final deliveryServices = DeliveryServices();
  DeliveryModel _deliveryModel = DeliveryModel();
  bool hayDatos = false;
  bool loading = true;
  @override
  void initState() {
    super.initState();
    _iniciarDeliveryPage();
  }

  void _iniciarDeliveryPage() async {
    await cargarDelivery();
  }

  cargarDelivery() async {
    _deliveryModel = await deliveryServices.postDelivery(widget.paymentModel);
    setState(() {
      if (_deliveryModel.availableCarriers.length > 0) {
        hayDatos = true;
      }
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Elegir método de envío", textScaleFactor: 1.0),
        ),
        body: loading
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : hayDatos
                ? ListView.builder(
                    itemCount: _deliveryModel.availableCarriers.length,
                    itemBuilder: (context, index) {
                      return _cardDelivery(
                          _deliveryModel.availableCarriers[index]);
                    },
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/img/no_delivery.png',
                          height: 150,
                        ),
                        Text(
                            'Por el momento no tenemos entregas en tu ubicación',
                            textScaleFactor: 1.0),
                      ],
                    ),
                  ));
  }

  _cardDelivery(AvailableCarrier model) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Card(
        elevation: 10,
        child: ListTile(
          leading: Icon(
            Icons.local_shipping,
            size: 35,
            color: Color(0xffff8357),
          ),
          title: Text(
            model.name,
            textScaleFactor: 1.0,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          subtitle: Text(
              'Entrega: ' +
                  model.delay +
                  '\n' +
                  'Precio compras: \$ ${widget.revisionModel.amountPaid.toStringAsFixed(2)} \n' +
                  (model.price == 0.0
                      ? 'Entrega gratis'
                      : 'Precio de envio: \$ ' +
                          model.price.toStringAsFixed(2)) +
                  '\n' +
                  'Total: \$ ' +
                  (widget.revisionModel.amountPaid + model.price)
                      .toStringAsFixed(2),
              textScaleFactor: 1.0),
          onTap: () {
            RevisionModel revModel = RevisionModel(
                amountPaid: widget.revisionModel.amountPaid + model.price,
                idCarrier: model.idCarrier,
                idCustomer: widget.paymentModel.idCustomer,
                idVoucher: widget.revisionModel.idVoucher);
            revModel.idCart = _deliveryModel.id;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => ChoosePaymentMethod(
                          arguments: widget.paymentModel,
                          revision: revModel,
                        )));
          },
        ),
      ),
    );
  }
}
