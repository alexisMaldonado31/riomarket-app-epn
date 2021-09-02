
import 'dart:async';



class RegisterValidators{

  final validateName  = StreamTransformer<String,String>.fromHandlers(
      handleData: (name,sink){
        Pattern pattern = '^[a-zA-Z]{2,}';
        RegExp regExp = new RegExp(pattern);
        if(regExp.hasMatch(name)){
          sink.add(name);
        }
        else{
          sink.addError("Debe incluir nombre");
        }
      }
  );
  final validateLastName  = StreamTransformer<String,String>.fromHandlers(
      handleData: (lastName,sink){
        if(lastName.length >= 2){
          sink.add(lastName);
        }
        else{
          sink.addError("Debe incluir apellido");
        }
      }
  );
  final validateEmail  = StreamTransformer<String,String>.fromHandlers(
      handleData: (email,sink){
        Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regExp = new RegExp(pattern);
        if(regExp.hasMatch(email)){
          sink.add(email);
        }
        else{
          sink.addError("No es un correo valido");
        }
      }
  );

  final validatePassword  = StreamTransformer<String,String>.fromHandlers(
      handleData: (pass,sink){
        if(pass.length >= 6){
          sink.add(pass);
        }else{
          sink.addError("Debe ser mayor a 6 caracteres");
        }

      }
  );
  final validateConfirmPassword  = StreamTransformer<String,String>.fromHandlers(
      handleData: (pass,sink){
        if(pass.length >= 6){
          sink.add(pass);
        }else{
          sink.addError("Debe ser mayor a 6 caracteres");
        }
      }
  );

}