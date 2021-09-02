import 'package:flutter/material.dart';
import 'package:riomarket/Pantallas/web_view_page.dart';
import 'package:riomarket/Providers/Services/loginServices.dart';
import 'package:riomarket/Providers/models/payment_model.dart';
import 'package:riomarket/Providers/models/user_model.dart';
import 'package:riomarket/Utils/login_utils.dart';

import 'card_register_data.dart';

class ModalLogin extends StatefulWidget {
  final String urlPassword =
      'https://stayhome.market/recuperar-contrase%C3%B1a';
  @override
  _ModalLoginState createState() => _ModalLoginState();
}

class _ModalLoginState extends State<ModalLogin> {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  bool showPassword = false;

  final _loginUtils = LoginUtils();
  final LoginServices _loginServices = LoginServices();

  final styleLinks =
      TextStyle(color: Colors.deepPurple, decoration: TextDecoration.underline);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Theme(
        data: Theme.of(context)
            .copyWith(canvasColor: Colors.white, primaryColor: Colors.black),
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: 370,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListView(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 10),
                  height: 350,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Image.asset(
                            "assets/img/logohorizontal.png",
                            height: 60,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: 'Correo electrónico',
                            hintText: 'ejemplo@mail.com',
                            prefixIcon: Icon(Icons.account_circle),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextField(
                        obscureText: !showPassword,
                        controller: _passwordController,
                        decoration: InputDecoration(
                            labelText: 'Contraseña',
                            hintText: '**********',
                            prefixIcon: Icon(Icons.security),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 5,
                        ),
                      ),
                      RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          color: Color(0xffe32659),
                          elevation: 5,
                          textColor: Colors.white,
                          onPressed: () async {
                            UserModel resp = await _loginServices.postLogin(
                                _emailController.text,
                                _passwordController.text);
                            if (resp.id > 0) {
                              Navigator.pop(context);
                              Navigator.pushReplacementNamed(context, 'home');
                            } else {
                              _loginUtils.alertError(context,
                                  'Contraseña incorrecta, intentelo de nuevo');
                            }
                          },
                          child: Container(
                            width: 150,
                            alignment: Alignment.center,
                            child: Text(
                              "Iniciar sesión",
                              textScaleFactor: 1,
                              style: TextStyle(fontSize: 15),
                            ),
                          )),
                      RaisedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
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
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Image.asset(
                                                "assets/img/logo.png",
                                                height: 50,
                                              ),
                                              Container(
                                                width: 180,
                                                child: Text(
                                                  "CREAR CUENTA EN STAYHOME.MARKET",
                                                  textScaleFactor: 1.0,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )
                                            ],
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: CardRegisterData(
                                              paymentModel:
                                                  PaymentModel(products: []),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 5,
                        color: Colors.white,
                        textColor: Colors.black,
                        child: Container(
                          width: 150,
                          alignment: Alignment.center,
                          child: Text(
                            "Crear cuenta",
                            textScaleFactor: 1,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
