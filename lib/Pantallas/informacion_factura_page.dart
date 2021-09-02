import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riomarket/Providers/Services/direccionServices.dart';
import 'package:riomarket/Providers/Services/loginServices.dart';
import 'package:riomarket/Providers/models/address_model.dart';
import 'package:riomarket/Providers/models/address_register_model.dart';
import 'package:riomarket/Providers/models/user_model.dart';
import 'package:riomarket/Utils/validators.dart' as utils;
import 'package:riomarket/Widgets/cargando_widget.dart';
import 'package:riomarket/Widgets/modal_escoger_direccion.dart';
import 'package:riomarket/Widgets/widgetGoogleMaps.dart';

import '../preferences.dart';

class DireccionesPage extends StatefulWidget {
  @override
  _DireccionesPageState createState() => _DireccionesPageState();
}

class _DireccionesPageState extends State<DireccionesPage> {
  final prefs = new Preferences();
  LoginServices _loginServices = LoginServices();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool cargando = true;

  LatLng _latLng = LatLng(0, 0);
  final formKey = GlobalKey<FormState>();
  final inputNombreController = new TextEditingController();
  final inputApellidoController = new TextEditingController();
  final inputCedulaController = new TextEditingController();
  final inputTelefonoController = new TextEditingController();
  final inputCiudadController = new TextEditingController();
  final inputCallePrincipalController = new TextEditingController();
  final inputCalleSecundariaController = new TextEditingController();
  final inputReferenciaController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _llenarFormulario();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Datos de tu Factura', textScaleFactor: 1.0),
      ),
      body: Form(
        key: formKey,
        child: Container(
            height: double.infinity,
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: cargando
                ? CargandoStayHome()
                : SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        _crearCardInformacion(screenSize),
                        SizedBox(
                          height: 10,
                        ),
                        _crearCardDireccion(screenSize)
                      ],
                    ),
                  )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _guardarDireccion,
        backgroundColor: Color(0xffe32659),
        child: Icon(
          Icons.save,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _crearCardInformacion(Size screenSize) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      elevation: 10.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(
                Icons.contact_phone,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                "Tú Información",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: screenSize.width * 0.05),
                textScaleFactor: 1.0,
              ),
            ),
            _crearInputNombre(),
            SizedBox(
              height: 10,
            ),
            _crearInputApellido(),
            SizedBox(
              height: 10,
            ),
            _crearInputCedula(),
            SizedBox(
              height: 10,
            ),
            _crearInputTelefono(),
          ],
        ),
      ),
    );
  }

  Widget _crearCardDireccion(Size screenSize) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      elevation: 10.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(
                Icons.location_on,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                "Dirección",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: screenSize.width * 0.05),
                textScaleFactor: 1.0,
              ),
            ),
            _crearInputCiudad(),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Expanded(child: _crearInputCalle1()),
                SizedBox(
                  width: 10,
                ),
                Expanded(child: _crearInputCalle2()),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            _crearInputReferencia(),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                _crearBotonGoogleMap(context),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _crearInputNombre() {
    return TextFormField(
      controller: inputNombreController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          labelText: 'Nombre',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
      validator: (value) {
        if (utils.comprobarSoloLetras(value)) return null;
        return 'Ingrese su Nombre';
      },
    );
  }

  Widget _crearInputApellido() {
    return TextFormField(
      controller: inputApellidoController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          labelText: 'Apellido',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
      validator: (value) {
        if (utils.comprobarSoloLetras(value)) return null;
        return 'Ingrese su Apellido';
      },
    );
  }

  Widget _crearInputCedula() {
    return TextFormField(
      controller: inputCedulaController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          labelText: 'Cédula o Ruc',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
      validator: (value) {
        if (value.length < 10 || value.length > 13) {
          return 'Debe tener entre 10 y 13 dígitos';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearInputTelefono() {
    return TextFormField(
      controller: inputTelefonoController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          labelText: 'Teléfono',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
      validator: (value) {
        if (utils.comprobarSoloNumeros(value)) return null;

        return 'Ingrese su número de teléfono';
      },
    );
  }

  Widget _crearInputCiudad() {
    return TextFormField(
      controller: inputCiudadController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          labelText: 'Ciudad',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
      validator: (value) {
        if (utils.comprobarSoloLetras(value)) return null;

        return 'Ingrese su Nombre';
      },
    );
  }

  Widget _crearInputCalle1() {
    return TextFormField(
      controller: inputCallePrincipalController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          labelText: 'Calle Principal',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
      validator: (value) {
        if (utils.comprobarSoloLetras(value)) return null;

        return 'Ingrese la calle principal';
      },
    );
  }

  Widget _crearInputCalle2() {
    return TextFormField(
      controller: inputCalleSecundariaController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          labelText: 'Calle Secundaria',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
      validator: (value) {
        if (utils.comprobarSoloLetras(value)) return null;

        return 'Ingrese la calle secundaria';
      },
    );
  }

  Widget _crearInputReferencia() {
    return TextFormField(
      controller: inputReferenciaController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          labelText: 'Edificio, Piso, Número de Casa',
          helperText:
              "Ingresa una referencia para que podamos encontrarte rápidamente",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
      validator: (value) {
        if (utils.comprobarLetrasNumeros(value)) return null;

        return 'Ingrese una referencia';
      },
    );
  }

  Widget _crearBotonGoogleMap(BuildContext context) {
    return RaisedButton.icon(
      onPressed: () {
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
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: Colors.green,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text('Aceptar',
                            style: TextStyle(color: Colors.white),
                            textScaleFactor: 1.0),
                      ),
                    )
                  ],
                ));
      },
      color: _latLng.longitude != 0 ? Colors.blue : Colors.red,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      label: Text("Tú ubicación en el mapa", textScaleFactor: 1.0),
      icon: Icon(Icons.map),
    );
  }

  void setPosition(LatLng pos) {
    setState(() {
      _latLng = pos;
    });
  }

  void _guardarDireccion() async {
    final user = userModelFromJson(prefs.user);
    FocusScope.of(context).requestFocus(new FocusNode());
    if (formKey.currentState.validate()) {
      if (_latLng.longitude != 0) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => CargandoStayHome());
        AddressModel addressModel = AddressModel(
            firstName: inputNombreController.text,
            lastName: inputApellidoController.text,
            city: inputCiudadController.text,
            phoneMobile: inputTelefonoController.text,
            address1: inputCallePrincipalController.text +
                ' - ' +
                inputCalleSecundariaController.text +
                ' - ' +
                inputReferenciaController.text,
            dni: inputCedulaController.text,
            latitud: _latLng.latitude.toString(),
            longitud: _latLng.longitude.toString(),
            customerId: user.id.toString(),
            addressId: prefs.idDireccionFactura);

        if (prefs.idDireccionFactura == '') {
          if (await _loginServices.postAddress(addressModel,
              isDireccionFactura: true)) {
            Navigator.maybePop(context);
            _mostrarSnackbar(
                mensaje: 'Su información a sido guardada', color: Colors.green);
          }
        } else {
          DireccionService direccionService = new DireccionService();
          if (await direccionService.actualizarDireccion(addressModel,
              isDireccionFactura: true)) {
            Navigator.maybePop(context);
            _mostrarSnackbar(
                mensaje: 'Su información a sido guardada', color: Colors.green);
          }
        }
      } else {
        _mostrarSnackbar(
            mensaje: 'No se ha ingresado la posición en el mapa',
            color: Colors.red);
      }
      return;
    } else {
      if (_latLng.longitude == 0) {
        _mostrarSnackbar(
            mensaje: 'No se ha ingresado la posición en el mapa',
            color: Colors.red);
      }
      return;
    }
  }

  _llenarFormulario() async {
    DireccionService direccionService = new DireccionService();
    final customerId = json.decode(prefs.user)['id'];
    final List<AddressRegisterModel> direcciones =
        await direccionService.getDireccionesCliente(customerId);
    if (direcciones.length == 0 || customerId != 0) {
      await _cargarDatosFactura(0);
    } else if (direcciones.length > 0) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => ModalEscogerDireccion(customerId,
              parentAction: _cargarDatosFactura));
    }
    setState(() {
      cargando = false;
    });
  }

  _cargarDatosFactura(int addressId) async {
    final idAddress = prefs.idDireccionFactura;
    if (idAddress != '') {
      DireccionService direccionService = new DireccionService();
      final address = await direccionService.getDireccionXId(idAddress);
      inputNombreController.text = address.firstname;
      inputApellidoController.text = address.lastname;
      inputCedulaController.text = address.dni;
      inputTelefonoController.text = address.phoneMobile;
      inputCiudadController.text = address.city;
      final direccion = address.address1.split(" - ");
      inputCallePrincipalController.text = direccion[0];
      inputCalleSecundariaController.text = direccion[1];
      inputReferenciaController.text = direccion[2];
      _latLng = new LatLng(address.latitud, address.longitud);
    }
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
