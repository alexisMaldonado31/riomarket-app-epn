import 'package:flutter/material.dart';

class SinInternetAlert extends StatelessWidget {
  final bool isLogin;

  SinInternetAlert({this.isLogin = false});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Parece que te quedaste sin internet", textScaleFactor: 1.0,),
      content: Text("Comprueba tu conexión e intentalo de nuevo", textScaleFactor: 1.0,),
      actions: <Widget>[
        FlatButton(
          onPressed: (){
            if(this.isLogin){
              Navigator.of(context).pushNamedAndRemoveUntil('login', (Route<dynamic> route) => false);
            }else{
              Navigator.of(context).pushNamedAndRemoveUntil('home', (Route<dynamic> route) => false);
            }
          },
          child: Text('Intentar Nuevamente', textScaleFactor: 1.0,)
        )
      ],
    );
  }
}