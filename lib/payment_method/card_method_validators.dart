
import 'dart:async';

class CardMethodValidators{

  final validateName  = StreamTransformer<String,String>.fromHandlers(
      handleData: (name,sink){
        if(name.split(' ').length >= 2){
          sink.add(name);
        }
        else{
          sink.addError("Debe incluir nombre y apellido");
        }
      }
  );
  final validateNumber  = StreamTransformer<String,String>.fromHandlers(
      handleData: (number,sink){
        try{
          if(number.length <= 16 && int.parse(number)>=1){
            sink.add(number);
          }else{
            sink.addError('Número de tarjeta erroneo');
          }
        }catch(Exception){
          sink.addError('Número de tarjeta erroneo');
        }

      }
  );
  final validateMmyy  = StreamTransformer<String,String>.fromHandlers(
      handleData: (mmyy,sink){
        try{
          if(mmyy.length ==4){
            int month = int.parse(mmyy.substring(0,2));
            int year = int.parse('20'+mmyy.substring(2,4));
            int dif = DateTime(year,month+1,01).add(Duration(days: -1)).difference(DateTime.now()).inDays;
            print(dif.toString() );
            if(dif >=0 && month<13){
              sink.add(mmyy);
            }
            else{
              sink.addError('Fecha no valida');
            }
          }else{
            sink.addError('Fecha no valida');
          }
        }catch(Exception){
          sink.addError('Fecha no valida');
        }
      }
  );
  final validateCvc  = StreamTransformer<String,String>.fromHandlers(
      handleData: (cvc,sink){
        if(cvc.length >= 3 && cvc.length <= 4){
          sink.add(cvc);
        }else{
          sink.addError("# no valido");
        }
      }
  );


}