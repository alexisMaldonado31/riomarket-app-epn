import 'package:flutter/material.dart';
import 'package:riomarket/Providers/Services/direccionServices.dart';
import 'package:riomarket/Providers/models/address_register_model.dart';
import 'package:riomarket/preferences.dart';

class ModalEscogerDireccion extends StatefulWidget {
  final int customerId;
  final ValueChanged<int> parentAction;

  ModalEscogerDireccion(this.customerId, {this.parentAction});

  @override
  _ModalEscogerDireccionState createState() => _ModalEscogerDireccionState();
}

class _ModalEscogerDireccionState extends State<ModalEscogerDireccion> {
  final _direccionesService = new DireccionService();
  final _prefs = new Preferences();

  int _selectCheck = 0;
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "Escoja la dirección para sus facturas",
              textScaleFactor: 1.0,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: screenSize.height * 0.03),
            ),
            Container(
              height: screenSize.height * 0.25,
              child: FutureBuilder(
                future: _direccionesService
                    .getDireccionesCliente(widget.customerId),
                builder: (BuildContext context,
                    AsyncSnapshot<List<AddressRegisterModel>> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final direcciones = snapshot.data;

                  if (direcciones.length == 0) return Container();

                  return ListView.builder(
                      itemCount: direcciones.length,
                      itemBuilder: (context, i) =>
                          _checkDireccion(direcciones[i]));
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Salir',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: screenSize.height * 0.025),
                        textScaleFactor: 1.0)),
                FlatButton(
                    onPressed: _selectCheck != 0
                        ? () {
                            _prefs.idDireccionFactura = _selectCheck.toString();
                            widget.parentAction(_selectCheck);
                            Navigator.pop(context);
                          }
                        : null,
                    child: Text('Guardar',
                        style: TextStyle(
                            color:
                                _selectCheck != 0 ? Colors.blue : Colors.grey,
                            fontSize: screenSize.height * 0.03),
                        textScaleFactor: 1.0))
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _checkDireccion(AddressRegisterModel address) {
    return RadioListTile<int>(
      value: int.parse(address.idAddress),
      groupValue: _selectCheck,
      onChanged: (int value) => setState(() {
        _selectCheck = value;
      }),
      title: Text(address.address1, textScaleFactor: 1.0),
      subtitle:
          Text('${address.city} - ${address.country}', textScaleFactor: 1.0),
    );
  }
}
