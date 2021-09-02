import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riomarket/Providers/Services/loginServices.dart';
import 'package:riomarket/Providers/models/address_model.dart';
import 'package:riomarket/Providers/models/payment_model.dart';
import 'package:riomarket/bloc/address_bloc.dart';
import 'widgetGoogleMaps.dart';

// ignore: must_be_immutable
class CardRegisterAddress extends StatefulWidget {
  PaymentModel payModel = PaymentModel();
  ValueChanged<int> parentAction;
  CardRegisterAddress({Key key, this.payModel, this.parentAction})
      : super(key: key);
  @override
  _CardRegisterAddressState createState() => _CardRegisterAddressState();
}

class _CardRegisterAddressState extends State<CardRegisterAddress> {
  TextEditingController _addressController = TextEditingController();
  TextEditingController _address1Controller = TextEditingController();
  TextEditingController _address2Controller = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _phoneMobileController = TextEditingController();
  TextEditingController _dniController = TextEditingController();
  LatLng _latLng = LatLng(0, 0);
  LoginServices _loginServices = LoginServices();
  bool formularioValido = false;
  @override
  void initState() {
    super.initState();
    _addressController.addListener(() {
      setState(() {
        formularioValido = validForm();
      });
    });
    _address1Controller.addListener(() {
      setState(() {
        formularioValido = validForm();
      });
    });
    _address2Controller.addListener(() {
      setState(() {
        formularioValido = validForm();
      });
    });
    _dniController.addListener(() {
      setState(() {
        formularioValido = validForm();
      });
    });
    _cityController.addListener(() {
      setState(() {
        formularioValido = validForm();
      });
    });
    _phoneMobileController.addListener(() {
      setState(() {
        formularioValido = validForm();
      });
    });
  }

  validForm() {
    if (_phoneMobileController.text.length != 10 &&
        !_phoneMobileController.text.startsWith('09')) {
      return false;
    }
    if (_dniController.text.length < 5) {
      return false;
    }
    if (_addressController.text.length < 2) {
      return false;
    }
    if (_address1Controller.text.length < 2) {
      return false;
    }
    if (_address2Controller.text.length < 2) {
      return false;
    }
    if (_cityController.text.length < 2) {
      return false;
    }
    if (_latLng.longitude == 0 && _latLng.latitude == 0) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final bloc = AddressBloc();
    return Card(
      elevation: 10,
      margin: EdgeInsets.all(10),
      child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          child: ListView(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  _inputDni(bloc),
                  SizedBox(
                    height: 10,
                  ),
                  _inputAddress(bloc),
                  SizedBox(
                    height: 10,
                  ),
                  _inputAddress1(bloc),
                  SizedBox(
                    height: 10,
                  ),
                  _inputAddress2(bloc),
                  SizedBox(
                    height: 10,
                  ),
                  _inputCity(bloc),
                  SizedBox(
                    height: 10,
                  ),
                  _inputPhoneMobile(bloc),
                  SizedBox(
                    height: 10,
                  ),
                  _getPositionGoogleMap(),
                  SizedBox(
                    height: 10,
                  ),
                  _buttonSaveAddress()
                ],
              ),
            ],
          )),
    );
  }

  Widget _getPositionGoogleMap() {
    return RaisedButton(
      onPressed: () {
        final size = MediaQuery.of(context).size;
        showDialog(
            context: context,
            builder: (BuildContext contexto) => Center(
                  child: Container(
                    height: size.height * 0.81,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          height: size.height * 0.7,
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
                        SizedBox(
                          height: 5,
                        ),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          color: Colors.white,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Text('Aceptar',
                                style: TextStyle(color: Colors.black54),
                                textScaleFactor: 1.0),
                          ),
                        )
                      ],
                    ),
                  ),
                ));
      },
      color: _latLng.longitude != 0 ? Colors.blue : Colors.red,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        height: 50,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: 144,
              child: Text("Marcar posición en el mapa", textScaleFactor: 1.0),
            ),
            Icon(Icons.map)
          ],
        ),
      ),
    );
  }

  Widget _inputAddress(AddressBloc bloc) {
    return StreamBuilder(
        stream: bloc.addressStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) => TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  hintText: 'Calle 1',
                  labelText: 'Calle 1',
                  errorText: snapshot.error,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
              onChanged: bloc.changeAddress,
              controller: _addressController,
            ));
  }

  Widget _inputAddress1(AddressBloc bloc) {
    return StreamBuilder(
        stream: bloc.address1Stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) => TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  hintText: 'Calle 2',
                  labelText: 'Calle 2',
                  errorText: snapshot.error,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
              onChanged: bloc.changeAddress1,
              controller: _address1Controller,
            ));
  }

  Widget _inputAddress2(AddressBloc bloc) {
    return StreamBuilder(
        stream: bloc.address2Stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) => TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  hintText: 'Número',
                  labelText: 'Edificio, Piso, Número',
                  errorText: snapshot.error,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
              onChanged: bloc.changeAddress2,
              controller: _address2Controller,
            ));
  }

  Widget _inputCity(AddressBloc bloc) {
    return StreamBuilder(
        stream: bloc.cityStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) => TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  hintText: 'Ciudad',
                  labelText: 'Ciudad',
                  errorText: snapshot.error,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
              controller: _cityController,
              onChanged: bloc.changeCity,
            ));
  }

  Widget _inputPhoneMobile(AddressBloc bloc) {
    return StreamBuilder(
        stream: bloc.phoneMobileStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) => TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  hintText: '09XXXXXXXX',
                  labelText: 'Teléfono celular',
                  errorText: snapshot.error,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
              controller: _phoneMobileController,
              onChanged: bloc.changePhoneMobil,
            ));
  }

  Widget _inputDni(AddressBloc bloc) {
    return StreamBuilder(
      stream: bloc.dniStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) => TextField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            hintText: '9999999999',
            labelText: 'Cédula',
            errorText: snapshot.error,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
        controller: _dniController,
        onChanged: bloc.changeDni,
      ),
    );
  }

  Widget _buttonSaveAddress() {
    return RaisedButton(
      onPressed: formularioValido
          ? _latLng.longitude != 0.0
              ? () async {
                  AddressModel addressModel = AddressModel(
                    city: _cityController.text,
                    phoneMobile: _phoneMobileController.text,
                    address1: _addressController.text +
                        ' - ' +
                        _address2Controller.text +
                        ' - ' +
                        _address1Controller.text,
                    dni: _dniController.text,
                    latitud: _latLng.latitude.toString(),
                    longitud: _latLng.longitude.toString(),
                    customerId: widget.payModel.idCustomer.toString(),
                  );
                  if (await _loginServices.postAddress(addressModel)) {
                    widget.parentAction(int.parse(addressModel.customerId));
                    Navigator.pop(context);
                  }
                }
              : null
          : null,
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Color(0xffe05c45),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: Text(
          'Guardar',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
          textScaleFactor: 1.0,
        ),
      ),
    );
  }

  setPosition(LatLng pos) {
    setState(() {
      _latLng = pos;
      formularioValido = validForm();
    });
  }
}
