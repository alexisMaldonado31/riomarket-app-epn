import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:riomarket/preferences.dart';

import 'Pantallas/acerca_de_nosotros_page.dart';
import 'Pantallas/home_page.dart';
import 'Pantallas/informacion_factura_page.dart';
import 'login.dart';

bool logeado = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  final pref = new Preferences();
  await pref.initPrefs();
  try {
    if (json.decode(pref.user)['id'] > 0) {
      logeado = true;
    } else {
      logeado = false;
    }
  } catch (e) {
    logeado = false;
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stay Home Market',
      debugShowCheckedModeBanner: false,
      initialRoute: logeado ? 'home' : 'login',
      theme: ThemeData(
        primaryColor: Color(0xffe32659),
        primarySwatch: Colors.orange,
      ),
      routes: {
        "login": (BuildContext context) => Login(),
        "home": (BuildContext context) => HomePage(),
        "direccionFactura": (BuildContext context) => DireccionesPage(),
        "acercaDeNosotros": (BuildContext context) => AcercaDeNosotrosPage(),
//        "producto"            : (BuildContext context) => ProductosPage(),
//        "productoDescripcion" : (BuildContext context) => ProductoDescripcionPage(),
      },
    );
  }
}
