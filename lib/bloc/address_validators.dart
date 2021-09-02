
import 'dart:async';
class AddressValidators{

  final validateAddress  = StreamTransformer<String,String>.fromHandlers(
      handleData: (address,sink){
        if(address.length >= 2){
          sink.add(address);
        }
        else{
          sink.addError("Debe incluir dirección");
        }
      }
  );
  final validateAddress1  = StreamTransformer<String,String>.fromHandlers(
      handleData: (address,sink){
        if(address.length >= 2){
          sink.add(address);
        }
        else{
          sink.addError("Debe incluir dirección");
        }
      }
  );
  final validateAddress2  = StreamTransformer<String,String>.fromHandlers(
      handleData: (address,sink){
        if(address.length >= 2){
          sink.add(address);
        }
        else{
          sink.addError("Debe incluir dirección");
        }
      }
  );
  final validateDni  = StreamTransformer<String,String>.fromHandlers(
      handleData: (address,sink){
        if(address.length >= 5){
          sink.add(address);
        }
        else{
          sink.addError("Debe incluir un numero de cedula");
        }
      }
  );
  final validateCity  = StreamTransformer<String,String>.fromHandlers(
      handleData: (city,sink){
        if(city.length >= 2){
          sink.add(city);
        }
        else{
          sink.addError("Debe incluir una ciudad");
        }
      }
  );
  final validatePhone  = StreamTransformer<String,String>.fromHandlers(
      handleData: (phone,sink){

        if(phone.length >= 9){
          sink.add(phone);
        }
        else{
          sink.addError("No es un numero valido");
        }
      }
  );

  final validatePhoneMov  = StreamTransformer<String,String>.fromHandlers(
      handleData: (phone,sink){

        if(phone.length == 10 && phone.startsWith('09')){
          sink.add(phone);
        }
        else{
          sink.addError("No es un numero valido");
        }
      }
  );

}