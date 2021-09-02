import 'dart:async';
import 'package:riomarket/payment_method/card_method_validators.dart';
import 'package:rxdart/rxdart.dart';

class CardMethodBloc with CardMethodValidators {
  final _nameController = BehaviorSubject<String>();
  final _numberController = BehaviorSubject<String>();
  final _mmyyController = BehaviorSubject<String>();
  final _cvcController = BehaviorSubject<String>();

  //Recuperar los datos del Stream
  Stream<String> get nameStream =>
      _nameController.stream.transform(validateName);
  Stream<String> get numberStream =>
      _numberController.stream.transform(validateNumber);
  Stream<String> get mmyyStream =>
      _mmyyController.stream.transform(validateMmyy);
  Stream<String> get cvcStream => _cvcController.stream.transform(validateCvc);

  Stream<bool> get formValidStream => CombineLatestStream.combine4(nameStream,
      numberStream, cvcStream, mmyyStream, (name, number, cvc, mmyy) => true);

  // Insertar valores al Stream
  Function(String) get changeName => _nameController.sink.add;
  Function(String) get changeNumber => _numberController.sink.add;
  Function(String) get changeCvc => _cvcController.sink.add;
  Function(String) get changeMmyy => _mmyyController.sink.add;

  dispose() {
    _nameController?.close();
    _numberController.close();
    _cvcController.close();
    _mmyyController.close();
  }
}
