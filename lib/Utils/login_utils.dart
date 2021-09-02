import 'package:flutter/material.dart';
import 'package:flutter_des/flutter_des.dart';

class LoginUtils{
  final _key = "CydGKRBzcNCprLkwXJFIbTqPpawclVlp";
  final _iv = "42451915";
  Future<String> encryptPassword(String password) async {
    var encrypt = await FlutterDes.encryptToBase64(password, _key, iv: _iv);
    return encrypt;
  }

  alertError(BuildContext context,String mensaje){
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        backgroundColor: Colors.red,
        child: Container(
          height: 104,
          child: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              Container(
                width: 230,
                child: Text(
                  mensaje,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white
                  ),
                  textScaleFactor: 1,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              RaisedButton(
                elevation: 10,
                color: Colors.white,
                child: Text(
                  'Aceptar',
                  style: TextStyle(
                    color: Colors.red
                  ),
                  textScaleFactor: 1,
                ),
                onPressed: (){
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        elevation: 10,
      )
    );
  }
  alertInfo(BuildContext context,String mensaje,String assets){
    showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
          backgroundColor: Colors.white,
          child: Container(
            height: 300,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  mensaje,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.deepPurple
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Image.asset(assets,height: 150,),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                  elevation: 10,
                  color: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Text(
                    'Aceptar',
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
          ),
          elevation: 10,
        )
    );
  }
}