import 'dart:async';

class PageCategoriaBloc{
  
  static final PageCategoriaBloc _singleton = new PageCategoriaBloc._internal();
  
  factory PageCategoriaBloc(){
    return _singleton;
  }

  PageCategoriaBloc._internal(){
    cambiarEstadoActionButton(false);
  }

  final _floatingActionButtonController = StreamController<bool>.broadcast();

  Stream<bool> visibleActionButton(){
    cambiarEstadoActionButton(false);
    return _floatingActionButtonController.stream;
  }

  dispose(){
    _floatingActionButtonController.close();
  }

  cambiarEstadoActionButton(bool visible){
    _floatingActionButtonController.sink.add(visible);
    //return _floatingActionButtonController;
  }
}