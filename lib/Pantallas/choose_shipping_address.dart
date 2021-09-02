import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riomarket/Pantallas/choose_delivery.dart';
import 'package:riomarket/Providers/Services/loginServices.dart';
import 'package:riomarket/Providers/models/address_model.dart';
import 'package:riomarket/Providers/models/address_register_model.dart';
import 'package:riomarket/Providers/models/payment_model.dart';
import 'package:riomarket/Providers/models/revision_model.dart';
import 'package:riomarket/Utils/login_utils.dart';
import 'package:riomarket/Widgets/card_register_address.dart';
import 'package:riomarket/Widgets/widgetGoogleMaps.dart';

// ignore: must_be_immutable
class ChooseShippingAddress extends StatefulWidget {
  PaymentModel arguments = PaymentModel();
  RevisionModel revision = RevisionModel();
  ChooseShippingAddress({@required this.arguments, @required this.revision});
  @override
  _ChooseShippingAddressState createState() => _ChooseShippingAddressState();
}

class _ChooseShippingAddressState extends State<ChooseShippingAddress> {
  bool addressEnable = false;
  LatLng _latLng = LatLng(0, 0);
  final _loginUtils = LoginUtils();
  bool loading = true;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<AddressRegisterModel> lista = List<AddressRegisterModel>();
  LoginServices _loginServices = LoginServices();

  @override
  void initState() {
    super.initState();
    _iniciarDireccionesPage();
  }

  void _iniciarDireccionesPage() async {
    _cargarDirecciones(int.parse(widget.arguments.idCustomer));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Elegir dirección de envió", textScaleFactor: 1.0),
      ),
      body: loading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              child: addressEnable
                  ? ListView.builder(
                      itemCount: lista.length != null ? lista.length : 0,
                      itemBuilder: (context, i) => _cardAddress(lista[i]))
                  : Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/img/no_address.png',
                          height: 150,
                        ),
                        Text('No hay direcciones registradas',
                            textScaleFactor: 1.0),
                      ],
                    )),
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color(0xffe32659),
        onPressed: () async {
          await showDialog(
              context: context,
              builder: (BuildContext context) => Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Container(
                      height: 595,
                      width: double.infinity,
                      child: CardRegisterAddress(
                        payModel: widget.arguments,
                        parentAction: _cargarDirecciones,
                      ),
                    ),
                  ));

          _mostrarSnackbar(
              mensaje: "La Dirección se guardó con éxito", color: Colors.green);
        },
        label: Text('Nueva dirección',
            style: TextStyle(color: Colors.white), textScaleFactor: 1.0),
        icon: Icon(
          Icons.add_location,
          color: Colors.white,
        ),
      ),
    );
  }

  void _cargarDirecciones(int costumerId) async {
    lista.clear();
    lista = await _loginServices.getAddress(costumerId);
    setState(() {
      if (lista.length > 0 && lista[0].address1 != '') {
        addressEnable = true;
      } else {
        addressEnable = false;
      }
      loading = false;
    });
  }

  _cardAddress(AddressRegisterModel model) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Card(
        elevation: 10,
        child: ListTile(
          leading: model.other.isNotEmpty
              ? Icon(
                  Icons.location_on,
                  size: 35,
                  color: Color(0xffe32659),
                )
              : Icon(
                  Icons.home,
                  size: 35,
                  color: Colors.red,
                ),
          title: Text(
            model.address1 + ' - ' + (model.city != null ? model.city : ''),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            textScaleFactor: 1.0,
          ),
          subtitle: Text(model.phoneMobile != null ? model.phoneMobile : '',
              textScaleFactor: 1.0),
          onTap: widget.revision.amountPaid == 0
              ? null
              : () {
                  if (model.other.isEmpty) {
                    showDialog(
                        context: context,
                        builder: (BuildContext contexto) => SimpleDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              children: <Widget>[
                                Container(
                                  height: 500,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  width: double.infinity,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: MapSample(
                                      editable: true,
                                      parentAction: setPosition,
                                    ),
                                  ),
                                ),
                                RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  onPressed: () async {
                                    if (_latLng.longitude == 0 &&
                                        _latLng.latitude == 0) {
                                      _loginUtils.alertInfo(
                                          context,
                                          'Debe seleccionar una ubicacion en el mapa',
                                          'assets/img/maps_help.png');
                                    } else {
                                      AddressModel addressModel = AddressModel(
                                          longitud:
                                              _latLng.longitude.toString(),
                                          latitud: _latLng.latitude.toString(),
                                          dni: model.dni,
                                          address1: model.address1,
                                          phoneMobile: model.phoneMobile,
                                          city: model.city,
                                          customerId: model.idCustomer,
                                          lastName: model.lastname,
                                          firstName: model.firstname,
                                          addressId: model.idAddress,
                                          phone: model.phone);

                                      _latLng = LatLng(0, 0);

                                      if (await _loginServices
                                          .postAddressUpdate(addressModel)) {
                                        _cargarDirecciones(
                                            int.parse(model.idCustomer));
                                        Navigator.pop(context);
                                      }
                                    }
                                  },
                                  color: Colors.green,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                    child: Text('Guardar',
                                        style: TextStyle(color: Colors.white),
                                        textScaleFactor: 1.0),
                                  ),
                                )
                              ],
                            ));
                  } else {
                    widget.arguments.idAddressDelivery =
                        model.idAddress.toString();
                    if (widget.arguments.idAddressInvoice == '0') {
                      widget.arguments.idAddressInvoice = lista[0].idAddress;
                    }

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => ChooseDelivery(
                                widget.arguments, widget.revision)));
                  }
                },
        ),
      ),
    );
  }

  setPosition(LatLng pos) {
    setState(() {
      _latLng = pos;
    });
  }

  _mostrarSnackbar({@required String mensaje, @required Color color}) {
    final snackbar = SnackBar(
        content: Text(mensaje,
            style: TextStyle(color: Colors.white), textScaleFactor: 1.0),
        duration: Duration(milliseconds: 1500),
        backgroundColor: color);
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }
}
