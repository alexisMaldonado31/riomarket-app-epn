import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:riomarket/Providers/models/payment_model.dart';
import 'package:riomarket/Widgets/card_register_data.dart';
import 'package:riomarket/Widgets/modal_login.dart';
import 'package:riomarket/preferences.dart';

import 'package:url_launcher/url_launcher.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoggedIn = false;
  bool showPassword = false;
  bool versionVerificada = true;

  var perfil;
  final pref = new Preferences();

  _LoginState() {
    iniciar();
  }
  iniciar() async {
    await pref.initPrefs();
  }

  @override
  void initState() {
    super.initState();
    //_verificarVersion();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
        //resizeToAvoidBottomPadding: false,
        body: isLoggedIn ? _inicioExitoso(h) : _pantallaLogin(h));
  }

  Widget _pantallaLogin(double h) {
    return Container(
        child: Center(
      child: Column(
        children: <Widget>[
          Spacer(),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/img/logohorizontal.png"),
                      fit: BoxFit.fill)),
            ),
          ),
          Spacer(),
          versionVerificada
              ? _botonIniciarStayHome(context)
              : Text(
                  'Tenemos una nueva versión para ti!!',
                  textScaleFactor: 1.0,
                  style: TextStyle(
                      fontSize: h * 0.03, fontWeight: FontWeight.bold),
                ),
          versionVerificada
              ? _botonRegistrarseStayHome(context)
              : Text(
                  'Descárgala en la tienda',
                  textScaleFactor: 1.0,
                  style: TextStyle(
                      fontSize: h * 0.03, fontWeight: FontWeight.bold),
                ),
          versionVerificada
              ? _botonOmitir()
              : RaisedButton.icon(
                  color: Color(0xffe05c45),
                  shape: StadiumBorder(),
                  textColor: Colors.white,
                  onPressed: () async {
                    String url =
                        'https://play.google.com/store/apps/details?id=com.stayhome.market';
                    if (await canLaunch(url)) {
                      await launch(
                        url,
                        forceSafariVC: false,
                        forceWebView: false,
                      );
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  icon: FaIcon(
                    FontAwesomeIcons.googlePlay,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Ir a GooglePlay',
                    textScaleFactor: 1.0,
                    style: TextStyle(
                        fontSize: h * 0.03, fontWeight: FontWeight.bold),
                  )),
          Expanded(
            child: SizedBox(
              height: 10,
            ),
          ),
        ],
      ),
    ));
  }

  Widget _botonIniciarStayHome(BuildContext contexto) {
    return RaisedButton(
      onPressed: () {
        _loginWithStayHome(contexto);
      },
      color: Color(0xffe32659),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
          height: 30,
          width: 270,
          padding: EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.center,
          child: Text(
            "¿Ya eres cliente? Iniciar sesión",
            textScaleFactor: 1,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
          )),
    );
  }

  Widget _inicioExitoso(double h) {
    return Container(
      height: h,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0xffff8357), Color(0xffffeed4)])),
      child: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: h * 0.2,
            ),
            Container(
              height: h * 0.20,
              width: h * 0.20,
              margin: EdgeInsets.all(50),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(pref.image),
                ),
              ),
            ),
            SizedBox(
              height: h * 0.05,
            ),
            Container(
              child: Center(
                child: Text(
                  "Bienvenido " + pref.name,
                  textScaleFactor: 1,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ),
            Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }

  void onLoginStatusChanged(bool isLoggedIn) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
    });
  }

  _loginWithStayHome(BuildContext contexto) {
    showDialog(
        context: contexto, builder: (BuildContext context) => ModalLogin());
  }

  Widget _botonRegistrarseStayHome(BuildContext contexto) {
    return RaisedButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) => Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Theme(
                    data: Theme.of(context).copyWith(
                        canvasColor: Colors.white, primaryColor: Colors.black),
                    child: Container(
                        height: 520,
                        child: ListView(
                          children: [
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Image.asset(
                                      "assets/img/logohorizontal.png",
                                      height: 50,
                                    ),
                                    // Container(
                                    //   width: 180,
                                    //   child: Text(
                                    //     "CREAR CUENTA EN STAYHOME.MARKET",
                                    //     textScaleFactor: 1.0,
                                    //     style: TextStyle(
                                    //         fontWeight: FontWeight.bold
                                    //     ),
                                    //   ),
                                    // )
                                  ],
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: CardRegisterData(
                                    paymentModel: PaymentModel(products: []),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )))));
      },
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      child: Container(
          width: 270,
          alignment: Alignment.center,
          child: Text(
            "¿Nuevo en Stay Home? Crea una cuenta",
            textScaleFactor: 1,
            style: TextStyle(color: Colors.black, fontSize: 14),
          )),
    );
  }

  _botonOmitir() {
    return RaisedButton(
      onPressed: () {
        pref.user = '';
        Navigator.pushReplacementNamed(context, 'home');
      },
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      child: Container(
        child: Text(
          "Omitir inicio de sesión",
          textScaleFactor: 1,
          style: TextStyle(
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
