import 'dart:async';
import 'package:riomarket/bloc/register_validators.dart';
import 'package:rxdart/rxdart.dart';

class RegisterBloc with RegisterValidators {
  final _nameController = BehaviorSubject<String>();
  final _lastNameController = BehaviorSubject<String>();
  final _emailController = BehaviorSubject<String>();
  final _passController = BehaviorSubject<String>();
  final _confirmPassController = BehaviorSubject<String>();

  //Recuperar los datos del Stream
  Stream<String> get nameStream =>
      _nameController.stream.transform(validateName);
  Stream<String> get lastNameStream =>
      _lastNameController.stream.transform(validateLastName);
  Stream<String> get emailStream =>
      _emailController.stream.transform(validateEmail);
  Stream<String> get passStream =>
      _passController.stream.transform(validatePassword);
  Stream<String> get confirmPassStream =>
      _confirmPassController.stream.transform(validateConfirmPassword);

  Stream<bool> get formValidStream => CombineLatestStream.combine4(
      nameStream,
      lastNameStream,
      emailStream,
      passStream,
      (name, lastName, email, pass) => true);

  // Insertar valores al Stream
  Function(String) get changeName => _nameController.sink.add;
  Function(String) get changeLastName => _lastNameController.sink.add;
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePass => _passController.sink.add;
  Function(String) get changeConfirmPass => _confirmPassController.sink.add;

  dispose() {
    _nameController?.close();
    _lastNameController.close();
    _emailController.close();
    _passController.close();
    _confirmPassController.close();
  }
}
