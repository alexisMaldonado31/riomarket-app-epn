import 'package:shared_preferences/shared_preferences.dart';

class Preferences{
  static final Preferences _instancia = new Preferences._internal();

  factory Preferences(){
    return _instancia;
  }

  Preferences._internal();

  SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  get id{
    return _prefs.getString('id')??'';
  }

  set id(String value){
    _prefs.setString('id', value);
  }

  get name{
    return _prefs.getString('name')??'';
  }

  set names(String value){
    _prefs.setString('name', value);
  }

  get image{
    return _prefs.getString('image')??'';
  }

  set images(String value){
    _prefs.setString('image', value);
  }

  get email{
    return _prefs.getString('email')??'';
  }

  set email(String value){
    _prefs.setString('email', value);
  }

  get user{
    return _prefs.getString('user')??'';
  }

  set user(String value){
    _prefs.setString('user', value);
  }

  get idCupon{
    return _prefs.getInt('idCupon') ?? 0;
  }

  set idCupon(int value){
    _prefs.setInt('idCupon', value);
  }

  get descuentoCupon{
    return _prefs.getDouble('descuentoCupon');
  }

  set descuentoCupon(double value){
    _prefs.setDouble('descuentoCupon', value);
  }

  get cantidadMinimaDescuento{
    return _prefs.getDouble('cantidadMinimaDescuento') ?? 0.0;
  }

  set cantidadMinimaDescuento(double value){
    _prefs.setDouble('cantidadMinimaDescuento', value);
  }

  get tipoDescuento{
    return _prefs.getString('tipoDescuento');
  }

  set tipoDescuento(String value){
    _prefs.setString('tipoDescuento', value);
  }

  get idDireccionFactura{
    return _prefs.getString('direccionFactura') ?? '';
  }

  set idDireccionFactura( String value){
    _prefs.setString('direccionFactura', value);
  }

}