import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:riomarket/Pantallas/choose_shipping_address.dart';
import 'package:riomarket/Providers/Services/loginServices.dart';
import 'package:riomarket/Providers/db_provider.dart';
import 'package:riomarket/Providers/models/payment_model.dart';
import 'package:riomarket/Providers/models/revision_model.dart';
import 'package:riomarket/Providers/models/user_model.dart';
import 'package:riomarket/Utils/login_utils.dart';
import 'package:riomarket/Widgets/card_register_data.dart';
import 'package:riomarket/bloc/itemsCarrito_bloc.dart';
import 'package:riomarket/preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomSheetCarrito extends StatefulWidget {
  final Color primaryColor;
  BottomSheetCarrito(this.primaryColor);

  @override
  State<StatefulWidget> createState() {
    return _BottomSheetCarrito();
  }
}

class _BottomSheetCarrito extends State<BottomSheetCarrito> {
  double subTotal = 0.0;
  final itemsCarritoBloc = new ItemsCarritoBloc();
  Preferences _pref = Preferences();
  final _loginUtils = LoginUtils();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String urlPassword = 'https://stayhome.market/recuperar-contrase%C3%B1a';

  final LoginServices _loginServices = LoginServices();
  bool isLoggedIn = false;
  bool showPassword = false;
  @override
  void initState() {
    _pref.initPrefs();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double maxW = MediaQuery.of(context).size.width;
    double maxH = MediaQuery.of(context).size.height;
    return StreamBuilder(
        stream: itemsCarritoBloc.itemsCarritoStream(),
        builder: (BuildContext context,
            AsyncSnapshot<List<ItemCarritoModel>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final itemsCarrito = snapshot.data;
          if (itemsCarrito.length == 0) {
            return SinProductos();
          }

          return Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              CloseButton(),
              _textoAyuda(),
              Divider(
                color: Colors.grey,
                height: 3,
              ),
              Container(
                width: maxW,
                height: maxH * 0.3,
                child: ListView.builder(
                    itemCount: itemsCarrito.length,
                    itemBuilder: (context, i) => _itemCarrito(itemsCarrito[i])),
              ),
              Divider(
                color: Colors.grey,
                height: 0.5,
              ),
              Spacer(),
              totalCarrito(maxW, maxH),
              Spacer()
            ],
          );
        });
  }

  Widget _itemCarrito(ItemCarritoModel itemCarritoModel) {
    return Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
        ),
        onDismissed: (direction) {
          itemsCarritoBloc.borrarItemCarrito(itemCarritoModel.idItemCarrito);
        },
        child: ListTile(
            leading: _imagenItem(itemCarritoModel.imagenUrl),
            title: Text(
              itemCarritoModel.descripcionProducto,
              textScaleFactor: 1,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: _subtitle(itemCarritoModel),
            trailing: _actionsItemCarrito(itemCarritoModel)));
  }

  Widget _subtitle(ItemCarritoModel carrito) {
    final double pvp =
        carrito.precioProducto + carrito.precioIva - carrito.precioDescuento;
    final int cantidad = carrito.cantidadProducto;
    subTotal = pvp;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
//          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _textSpan(titulo: 'Cantidad', descripcion: '$cantidad'),
            SizedBox(width: 20),
            _textSpan(titulo: 'PVP', descripcion: '${(pvp).toStringAsFixed(2)}')
          ],
        ),
        _textSpan(
            titulo: 'Total',
            descripcion: '${(pvp * cantidad).toStringAsFixed(2)}'),
      ],
    );
  }

  Widget _imagenItem(String url) {
    return CircleAvatar(
        radius: 30,
        child: CachedNetworkImage(
          imageUrl: url,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          placeholder: (context, url) =>
              Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ));
  }

  Widget _actionsItemCarrito(ItemCarritoModel carritoModel) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () {
            if (carritoModel.cantidadProducto + 1 <= carritoModel.stock) {
              itemsCarritoBloc.actualizarCantidadItemCarrito(carritoModel, 1);
            }
          },
          splashColor: Colors.red,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            child: Icon(Icons.add_circle, color: Color(0xffe32659)),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
          ),
        ),
        Spacer(),
        InkWell(
          onTap: () {
            if (carritoModel.cantidadProducto - 1 >= 0) {
              itemsCarritoBloc.actualizarCantidadItemCarrito(carritoModel, -1);
            }
          },
          splashColor: Colors.red,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            child: Icon(Icons.remove_circle, color: Color(0xffe32659)),
          ),
        ),
      ],
    );
  }

  Widget _textSpan({String titulo, String descripcion}) {
    return RichText(
        textScaleFactor: 1,
        text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                  text: '$titulo: ',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(
                text: '$descripcion',
              ),
            ]));
  }

  Widget totalCarrito(double maxW, double maxH) {
    return StreamBuilder<Total>(
        stream: itemsCarritoBloc.totalCarritoStream(),
        builder: (BuildContext context, AsyncSnapshot<Total> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final _totalClass = snapshot.data;

          return Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: maxH * 0.03, left: maxH * 0.05),
                child: InfoTotal(
                  context: context,
                  pref: _pref,
                  total: _totalClass.totalCarrito(),
                  bloc: itemsCarritoBloc,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: maxH * 0.03, left: maxH * 0.1),
              ),
              SizedBox(
                height: maxH * 0.02,
              ),
              _botonComprar(context, _totalClass.totalCarrito(), maxW, maxH),
            ],
          );
        });
  }

  Widget _botonComprar(
      BuildContext context, double valor, double maxW, double maxH) {
    return InkWell(
      onTap: () async {
        final db = DBProvider.db;
        final total = await DBProvider.db.totalCarrito();
        double desc = 0;
        String _tipoDescuento = _pref.tipoDescuento ?? '';
        if (total.totalCarrito() < _pref.cantidadMinimaDescuento) {
          desc = 0;
        } else if (_tipoDescuento == 'percent') {
          desc = total.totalCarrito() * (_pref.descuentoCupon ?? 0);
        } else {
          desc = (_pref.descuentoCupon ?? 0);
        }

        RevisionModel revModel =
            RevisionModel(amountPaid: total.totalCarrito() - desc);
        PaymentModel pagoModel = PaymentModel();
        List<ItemCarritoModel> lista = await db.getAllItemsCarrito();
        List<Product> productos = List<Product>();

        revModel.idVoucher = _pref.idCupon.toString();
        lista.forEach((element) {
          productos.add(Product(
              idProduct: element.idProducto.toString(),
              productQuantity: element.cantidadProducto.toString()));
        });
        pagoModel.products = productos;
        if (_pref.idDireccionFactura.toString().isNotEmpty) {
          pagoModel.idAddressInvoice = _pref.idDireccionFactura;
        } else {
          pagoModel.idAddressInvoice = '0';
        }

        try {
          var result = json.decode(_pref.user);
          if (int.parse(result['id'].toString()) > 0) {
            pagoModel.idCustomer = result['id'].toString();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => ChooseShippingAddress(
                        arguments: pagoModel, revision: revModel)));
          } else {
            _loginWithStayHome(context, pagoModel, revModel);
          }
        } catch (ex) {
          _loginWithStayHome(context, pagoModel, revModel);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(left: maxH * 0.05),
        child: Container(
          height: maxH * 0.06,
          width: maxW,
          child: Center(
            child: Text(
              "Pagar",
              textScaleFactor: 1.0,
              style: TextStyle(
                  fontSize: maxW * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              color: Color(0xffe32659)),
        ),
      ),
    );
  }

  Widget _textoAyuda() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Center(
        child: Text(
          'Elimina un producto deslizando',
          textScaleFactor: 1.0,
          maxLines: 1,
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  _loginWithStayHome(
      BuildContext contexto, PaymentModel model, RevisionModel revModel) {
    final styleLinks = TextStyle(
        color: Colors.deepPurple, decoration: TextDecoration.underline);
    showDialog(
        context: contexto,
        builder: (BuildContext context) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Theme(
                data: Theme.of(context).copyWith(
                    canvasColor: Colors.white, primaryColor: Colors.black),
                child: Container(
                    padding: EdgeInsets.all(20),
                    height: 370,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListView(
                      children: [
                        Container(
                          height: 300,
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Image.asset(
                                    "assets/img/logohorizontal.png",
                                    height: 60,
                                  ),
                                  // Container(
                                  //   width: 180,
                                  //   child: Text(
                                  //     "INICIAR CON STAYHOME.MARKET",
                                  //     textScaleFactor: 1.0,
                                  //     style: TextStyle(
                                  //         fontWeight: FontWeight.bold
                                  //     ),
                                  //   ),
                                  // )
                                ],
                              ),
                              TextField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                    labelText: 'Correo electronico',
                                    hintText: 'ejemplo@mail.com',
                                    prefixIcon: Icon(Icons.account_circle),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20))),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextField(
                                obscureText: !showPassword,
                                controller: _passwordController,
                                decoration: InputDecoration(
                                    labelText: 'Contraseña',
                                    hintText: '**********',
                                    prefixIcon: Icon(Icons.security),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20))),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              InkWell(
                                onTap: () async {
                                  if (await canLaunch(urlPassword)) {
                                    await launch(urlPassword);
                                  }
                                },
                                child: Text(
                                  "Olvidó su contraseña?",
                                  style: styleLinks,
                                  textScaleFactor: 1.0,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                color: Colors.black,
                                textColor: Colors.white,
                                onPressed: () async {
                                  UserModel resp =
                                      await _loginServices.postLogin(
                                          _emailController.text,
                                          _passwordController.text);
                                  if (resp.id > 0) {
                                    Navigator.pop(context);
                                    var result = json.decode(_pref.user);
                                    model.idCustomer = result['id'].toString();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                ChooseShippingAddress(
                                                  arguments: model,
                                                  revision: revModel,
                                                )));
                                  } else {
                                    _loginUtils.alertError(
                                        context, 'Credenciales incorrectas');
                                  }
                                },
                                child: Text(
                                  "INGRESAR",
                                  textScaleFactor: 1.0,
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: 10,
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  Navigator.pop(context);
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) => Dialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Theme(
                                              data: Theme.of(context).copyWith(
                                                  canvasColor: Colors.white,
                                                  primaryColor: Colors.black),
                                              child: Container(
                                                  height: 520,
                                                  child: ListView(
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: <Widget>[
                                                              Image.asset(
                                                                "assets/img/logo.png",
                                                                height: 50,
                                                              ),
                                                              Container(
                                                                width: 180,
                                                                child: Text(
                                                                  "CREAR CUENTA EN STAYHOME.MARKET",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                  textScaleFactor:
                                                                      1.0,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                            ),
                                                            child:
                                                                CardRegisterData(
                                                              paymentModel:
                                                                  model,
                                                              revision:
                                                                  revModel,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )))));
                                },
                                child: Text(
                                  "No tiene cuenta? Crear una aquí",
                                  style: styleLinks,
                                  textScaleFactor: 1.0,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
            ));
  }
}

class InfoTotal extends StatelessWidget {
  final BuildContext context;
  final double total;
  final Preferences pref;
  final ItemsCarritoBloc bloc;

  InfoTotal(
      {@required this.context,
      @required this.total,
      @required this.pref,
      @required this.bloc});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,

      title: RichText(
          textScaleFactor: 1,
          text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                    text: 'Sub Total: ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xffe32659))),
                TextSpan(
                    text: '${(total).toStringAsFixed(2)} \$',
                    style: TextStyle(fontSize: 15)),
              ])),
      subtitle: StreamBuilder(
        stream: bloc.obtenerDescuentoCarritoStream(),
        initialData: 0.0,
        builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
          final descuento = snapshot.data;
          return RichText(
              textScaleFactor: 1,
              text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    // TextSpan(
                    //   text: 'Descuento: ',
                    //   style: TextStyle(
                    //     fontWeight: FontWeight.bold,
                    //     fontSize: 15,
                    //     color: Theme.of(context).primaryColor
                    //   )
                    // ),
                    // TextSpan(
                    //   text: '${(descuento).toStringAsFixed(2)} \$',
                    //   style: TextStyle(
                    //     fontSize: 15
                    //   )
                    // ),
                  ]));
        },
      ),
      // trailing: InkWell(
      //   onTap: (){
      //     showDialog(
      //       context: context,
      //       builder: (BuildContext context) => ModalAgregarCupon(total)
      //     );
      //   },
      //   splashColor: Theme.of(context).primaryColor,

      //   child: Column(
      //     children: <Widget>[
      //       Container(
      //         child: Icon(Icons.local_activity, color: Theme.of(context).primaryColor),
      //         decoration: BoxDecoration(
      //           shape: BoxShape.circle,
      //         ),
      //       ),
      //       Text(
      //         pref.idCupon == 0 ? 'Agrega un Cupón' : 'Usa otro Cupón',
      //         textScaleFactor: 1,
      //         style: TextStyle(
      //           color: Theme.of(context).primaryColor,
      //           fontWeight: FontWeight.bold
      //         ),
      //       )
      //     ],
      //   ),
      // )
    );
  }
}

class SinProductos extends StatelessWidget {
  const SinProductos({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CloseButton(),
        Expanded(
          child: Container(
              child: Center(child: Image.asset('assets/img/still-there.png'))),
        ),
        FlatButton(
            onPressed: () {
              Navigator.maybePop(context);
            },
            child: Text('Regresar',
                style: TextStyle(color: Color(0xffe32659), fontSize: 20.0),
                textScaleFactor: 1.0))
      ],
    );
  }
}
