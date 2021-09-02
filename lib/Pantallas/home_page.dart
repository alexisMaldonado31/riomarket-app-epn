import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:riomarket/Pantallas/productos_page.dart';
import 'package:riomarket/Providers/Services/categoriaServices.dart';
import 'package:riomarket/Pantallas/choose_shipping_address.dart';
import 'package:riomarket/Providers/models/payment_model.dart';
import 'package:riomarket/Providers/models/revision_model.dart';
import 'package:riomarket/Widgets/bottomsheet_carrito_widget.dart';
import 'package:riomarket/Widgets/carrito-compra_widget.dart';
import 'package:riomarket/Widgets/modal_login.dart';
import 'package:riomarket/bloc/itemsCarrito_bloc.dart';
import 'package:riomarket/search/producto_search.dart';
import '../preferences.dart';
import 'categorias_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final pref = new Preferences();
  final itemsCarritoBloc = new ItemsCarritoBloc();
  int user;

  @override
  void initState() {
    _iniciarPreferencias();
    try {
      user = json.decode(pref.user)['id'];
    } catch (e) {
      user = 0;
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final screenSize = MediaQuery.of(context).size;
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('RioMarket App'), //_logoHorizontal(),
          actions: <Widget>[
            _bottomSheetCarrito(context, primaryColor, screenSize.height),
            user == 0 ? _login(context) : Container()
          ],
        ),
        body: PageCategorias(),
        drawer: _drawer(context),
        drawerEdgeDragWidth: screenSize.width / 2,
        floatingActionButton: FloatingActionButton(
          heroTag: 'homeButton',
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            showSearch(context: context, delegate: ProductoSearch());
          },
          child: Icon(
            Icons.search,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }

  _iniciarPreferencias() async {
    await pref.initPrefs();
  }

  Widget _bottomSheetCarrito(
      BuildContext context, Color primaryColor, double height) {
    return InkWell(
        borderRadius: BorderRadius.circular(500),
        onTap: () {
          showModalBottomSheet(
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(20),
              ),
              backgroundColor: Colors.white,
              isScrollControlled: true,
              builder: (BuildContext context) => Container(
                    height: height * 0.65,
                    child: BottomSheetCarrito(primaryColor),
                  ));
        },
        child: Carrito(
          colorCarrito: Colors.white,
        ));
  }

  Widget _drawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          _drawerHeader(context),
          Expanded(
              child: ListView(
            children: <Widget>[
              user > 0 ? _informacionFactura(context) : Container(),
              user > 0 ? _direccionesEntrega(context) : Container(),
              //user > 0 ? _monitorearMiPedido(context) : Container(),
              Divider(),
              _novedades(context),
              _ofertas(context),
              user > 0 ? _cerrarSesion(context) : _iniciarSesion(context),
            ],
          )),
          _acercaDeNosotros()
        ],
      ),
    );
  }

  Widget _drawerHeader(BuildContext context) {
    return DrawerHeader(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Container(
          width: double.infinity,
          child: Center(child: Image.asset('assets/img/logohorizontal.png')),
        ));
  }

  Widget _iniciarSesion(BuildContext context) {
    return ListTile(
        leading: Icon(
          FontAwesomeIcons.signInAlt,
          color: Theme.of(context).primaryColor,
        ),
        title: Text('Iniciar Sesión', textScaleFactor: 1.0),
        onTap: _modalLogin);
  }

  Widget _informacionFactura(BuildContext context) {
    return ListTile(
      leading: Icon(
        FontAwesomeIcons.addressCard,
        color: Theme.of(context).primaryColor,
      ),
      title: Text('Datos de Facturación', textScaleFactor: 1.0),
      trailing: Icon(
        Icons.keyboard_arrow_right,
        color: Theme.of(context).primaryColor,
      ),
      onTap: () {
        Navigator.pushNamed(context, 'direccionFactura');
      },
    );
  }

  Widget _novedades(BuildContext context) {
    return ListTile(
      leading: Icon(
        FontAwesomeIcons.bullhorn,
        color: Theme.of(context).primaryColor,
      ),
      title: Text('Novedades', textScaleFactor: 1.0),
      trailing: Icon(
        Icons.keyboard_arrow_right,
        color: Theme.of(context).primaryColor,
      ),
      onTap: () async {
        final categoria = await CategoriaServices().getCategoriaXId(55);
        var route = new MaterialPageRoute(
            builder: (BuildContext context) => new ProductosPage(
                int.parse(categoria.idCategory),
                categoria.name,
                categoria.urlBanner));
        Navigator.of(context).push(route);
      },
    );
  }

  Widget _ofertas(BuildContext context) {
    return ListTile(
      leading: Icon(
        FontAwesomeIcons.percent,
        color: Theme.of(context).primaryColor,
      ),
      title: Text('Ofertas', textScaleFactor: 1.0),
      trailing: Icon(
        Icons.keyboard_arrow_right,
        color: Theme.of(context).primaryColor,
      ),
      onTap: () async {
        final categoria = await CategoriaServices().getCategoriaXId(46);
        var route = new MaterialPageRoute(
            builder: (BuildContext context) => new ProductosPage(
                int.parse(categoria.idCategory),
                categoria.name,
                categoria.urlBanner));
        Navigator.of(context).push(route);
      },
    );
  }

  Widget _direccionesEntrega(BuildContext context) {
    return ListTile(
      leading: Icon(
        FontAwesomeIcons.addressBook,
        color: Theme.of(context).primaryColor,
      ),
      title: Text('Mis Direcciones de Entrega', textScaleFactor: 1.0),
      trailing: Icon(
        Icons.keyboard_arrow_right,
        color: Theme.of(context).primaryColor,
      ),
      onTap: () {
        PaymentModel model = PaymentModel();
        model.idCustomer = user.toString();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => ChooseShippingAddress(
                      arguments: model,
                      revision: RevisionModel(amountPaid: 0),
                    )));
      },
    );
  }

  Widget _cerrarSesion(BuildContext context) {
    return ListTile(
      leading: Icon(
        FontAwesomeIcons.signOutAlt,
        color: Theme.of(context).primaryColor,
      ),
      title: Text('Cerrar Sesión', textScaleFactor: 1.0),
      onTap: () {
        pref.user = '';
        pref.idDireccionFactura = '';
        itemsCarritoBloc.borrarAllItemsCarrito();
        Navigator.pushReplacementNamed(context, 'login');
      },
    );
  }

  Widget _acercaDeNosotros() {
    return FutureBuilder(
      future: PackageInfo.fromPlatform(),
      builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          final snap = snapshot.data;
          return ListTile(
              title: Text('Acerca de Nosotros', textScaleFactor: 1.0),
              trailing: Text(snap.version,
                  style: TextStyle(color: Colors.black54),
                  textScaleFactor: 1.0),
              onTap: () {
                Navigator.pushNamed(context, 'acercaDeNosotros');
              });
        }
      },
    );
  }

  Widget _login(BuildContext context) {
    int user;
    try {
      user = int.parse(json.decode(pref.user)['id']);
    } catch (e) {
      user = 0;
    }
    return user == 0
        ? IconButton(
            icon: Icon(FontAwesomeIcons.signInAlt), onPressed: _modalLogin)
        : Container();
  }

  Widget _logoHorizontal() {
    return AspectRatio(
      aspectRatio: 4 / 1,
      child: Image.asset('assets/img/logohorizontal.png'),
    );
  }

  void _modalLogin() {
    showDialog(
        context: context, builder: (BuildContext context) => ModalLogin());
  }
}
