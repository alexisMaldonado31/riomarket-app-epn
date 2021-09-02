import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:riomarket/Pantallas/choose_shipping_address.dart';
import 'package:riomarket/Providers/Services/loginServices.dart';
import 'package:riomarket/Providers/models/payment_model.dart';
import 'package:riomarket/Providers/models/register_model.dart';
import 'package:riomarket/Providers/models/revision_model.dart';
import 'package:riomarket/Utils/login_utils.dart';
import 'package:riomarket/bloc/register_bloc.dart';
import 'package:riomarket/preferences.dart';

// ignore: must_be_immutable
class CardRegisterData extends StatefulWidget {
  PaymentModel paymentModel = PaymentModel();
  RevisionModel revision = RevisionModel();
  CardRegisterData({Key key, this.paymentModel, this.revision})
      : super(key: key);
  @override
  _CardRegisterDataState createState() => _CardRegisterDataState();
}

class _CardRegisterDataState extends State<CardRegisterData> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  bool passEqual = false;
  bool formularioValido = false;
  Preferences _pref = Preferences();

  final LoginServices _loginServices = LoginServices();
  final LoginUtils _loginUtils = LoginUtils();
  @override
  void initState() {
    super.initState();
    _pref.initPrefs();
    _confirmPasswordController.addListener(() {
      setState(() {
        if (_confirmPasswordController.text == _passwordController.text) {
          passEqual = true;
          formularioValido = validForm();
        } else {
          passEqual = false;
        }
      });
    });
    _passwordController.addListener(() {
      setState(() {
        if (_passwordController.text == _confirmPasswordController.text) {
          passEqual = true;
          formularioValido = validForm();
        } else {
          passEqual = false;
        }
      });
    });
    _nameController.addListener(() {
      setState(() {
        formularioValido = validForm();
      });
    });
    _lastNameController.addListener(() {
      setState(() {
        formularioValido = validForm();
      });
    });
    _emailController.addListener(() {
      setState(() {
        formularioValido = validForm();
      });
    });
  }

  validForm() {
    Pattern patternEmail =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(patternEmail);
    if (!regExp.hasMatch(_emailController.text)) {
      return false;
    }
    if (_passwordController.text.length < 6) {
      return false;
    }
    Pattern patternText = '^[a-zA-Z]{2,}';
    RegExp regExpText = new RegExp(patternText);
    if (!regExpText.hasMatch(_nameController.text)) {
      return false;
    }
    if (!regExpText.hasMatch(_lastNameController.text)) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final bloc = RegisterBloc();
    return Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        margin: EdgeInsets.all(10),
        child: Container(
          padding: EdgeInsets.all(10),
          color: Colors.transparent,
          child: Column(
            children: [
              _inputNombre(bloc),
              SizedBox(height: 10),
              _inputLastName(bloc),
              SizedBox(height: 10),
              _inputEmail(bloc),
              SizedBox(height: 10),
              _inputPassword(bloc),
              SizedBox(height: 10),
              _inputConfirmPassword(bloc),
              SizedBox(height: 5),
              _buttonRegistrar()
            ],
          ),
        ));
  }

  _inputNombre(RegisterBloc bloc) {
    return StreamBuilder(
      stream: bloc.nameStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return TextField(
          keyboardType: TextInputType.text,
          controller: _nameController,
          decoration: InputDecoration(
            hintText: 'Nombre',
            labelText: 'Nombre',
            errorText: snapshot.error,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onChanged: bloc.changeName,
        );
      },
    );
  }

  _inputLastName(RegisterBloc bloc) {
    return StreamBuilder(
        stream: bloc.lastNameStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return TextField(
            keyboardType: TextInputType.text,
            controller: _lastNameController,
            decoration: InputDecoration(
              hintText: 'Apellido',
              labelText: 'Apellido',
              errorText: snapshot.error,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onChanged: bloc.changeLastName,
          );
        });
  }

  _inputEmail(RegisterBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return TextField(
          keyboardType: TextInputType.emailAddress,
          controller: _emailController,
          decoration: InputDecoration(
            hintText: 'Correo electronico',
            labelText: 'Correo electronico',
            helperText: 'ejemplo@mail.com',
            errorText: snapshot.error,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onChanged: bloc.changeEmail,
        );
      },
    );
  }

  _inputPassword(RegisterBloc bloc) {
    return StreamBuilder(
      stream: bloc.passStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return TextField(
          keyboardType: TextInputType.text,
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Contraseña',
            labelText: 'Contraseña',
            errorText: snapshot.error,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onChanged: bloc.changePass,
        );
      },
    );
  }

  _inputConfirmPassword(RegisterBloc bloc) {
    return StreamBuilder(
      stream: bloc.confirmPassStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return TextField(
          keyboardType: TextInputType.text,
          obscureText: true,
          controller: _confirmPasswordController,
          decoration: InputDecoration(
            hintText: 'Confirmar contraseña',
            labelText: 'Confirmar contraseña',
            errorText: passEqual ? null : 'Las contraseñas no coinciden',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onChanged: bloc.changeConfirmPass,
        );
      },
    );
  }

  _buttonRegistrar() {
    return RaisedButton(
        onPressed: formularioValido
            ? passEqual
                ? () async {
                    final registro = RegisterModel(
                        firstname: _nameController.text,
                        lastname: _lastNameController.text,
                        email: _emailController.text,
                        password: await _loginUtils
                            .encryptPassword(_passwordController.text),
                        idGender: "1");

                    bool login = await _loginServices.postRegister(registro);

                    if (login && widget.paymentModel.products.length > 0) {
                      var result = json.decode(_pref.user);
                      widget.paymentModel.idCustomer = result['id'].toString();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ChooseShippingAddress(
                                    arguments: widget.paymentModel,
                                    revision: widget.revision,
                                  )));
                    } else if (login) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          'home', (Route<dynamic> route) => false);
                    } else {
                      final loginUtils = LoginUtils();
                      loginUtils.alertError(context, 'Error al crear cuenta.');
                    }
                  }
                : null
            : null,
        elevation: 10,
        color: Colors.green,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text("Crear cuenta", textScaleFactor: 1.0),
        ));
  }
}
