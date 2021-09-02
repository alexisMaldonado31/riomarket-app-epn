import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'address_validators.dart';

class AddressBloc with AddressValidators{

  final _dniController = BehaviorSubject<String>();
  final _addressController = BehaviorSubject<String>();
  final _address1Controller = BehaviorSubject<String>();
  final _address2Controller = BehaviorSubject<String>();
  final _cityController = BehaviorSubject<String>();
  final _phoneController = BehaviorSubject<String>();
  final _phoneMobilController = BehaviorSubject<String>();

  //Recuperar los datos del Stream
  Stream<String> get dniStream => _dniController.stream.transform(validateDni);
  Stream<String> get addressStream => _addressController.stream.transform(validateAddress);
  Stream<String> get address1Stream => _address1Controller.stream.transform(validateAddress1);
  Stream<String> get address2Stream => _address2Controller.stream.transform(validateAddress2);
  Stream<String> get cityStream => _cityController.stream.transform(validateCity);
  Stream<String> get phoneStream => _phoneController.stream.transform(validatePhone);
  Stream<String> get phoneMobileStream => _phoneMobilController.stream.transform(validatePhoneMov);

  Stream<bool> get formValidStream =>
      CombineLatestStream.combine6(dniStream, addressStream, address1Stream, address2Stream, cityStream, phoneMobileStream,(dni, address, address1, address2, city, phoneMobil) =>true);

  // Insertar valores al Stream
  Function(String) get changeDni => _dniController.sink.add;
  Function(String) get changeAddress => _addressController.sink.add;
  Function(String) get changeAddress1 => _address1Controller.sink.add;
  Function(String) get changeAddress2 => _address2Controller.sink.add;
  Function(String) get changeCity => _cityController.sink.add;
  Function(String) get changePhone => _phoneController.sink.add;
  Function(String) get changePhoneMobil => _phoneMobilController.sink.add;

  dispose(){
    _dniController?.close();
    _addressController.close();
    _address1Controller.close();
    _address2Controller.close();
    _cityController.close();
    _phoneController.close();
    _phoneMobilController.close();
  }

}