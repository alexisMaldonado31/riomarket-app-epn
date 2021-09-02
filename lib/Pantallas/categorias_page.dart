import 'package:flutter/material.dart';
import 'package:riomarket/Providers/Services/categoriaServices.dart';
import 'package:riomarket/Providers/Services/productoServices.dart';
import 'package:riomarket/Providers/db_provider.dart';
import 'package:riomarket/Widgets/card-categoria_widget.dart';
import 'package:riomarket/Widgets/cargando_widget.dart';

import 'package:riomarket/bloc/pageCategoria_bloc.dart';
import 'package:riomarket/bloc/producto_bloc.dart';

class PageCategorias extends StatefulWidget {
  @override
  _PageCategoriasState createState() => _PageCategoriasState();
}

class _PageCategoriasState extends State<PageCategorias> {
  final pageCategoriaBloc = new PageCategoriaBloc();
  final productoBloc = new ProductoBloc();

  List<Widget> rows = new List<Widget>();
  bool flag = false;
  ScrollController _scrollController;

  _scrollListener() {
    if (_scrollController.offset >
        _scrollController.position.maxScrollExtent / 6) {
      pageCategoriaBloc.cambiarEstadoActionButton(true);
    } else {
      pageCategoriaBloc.cambiarEstadoActionButton(false);
    }
  }

  _ingresarProductos() async {
    productoBloc.eliminarProductos();
    List<ProductoModel> productos = await ProductoServices().getProductos();
    for (var producto in productos) {
      productoBloc.agregarProducto(producto);
    }
    flag = true;
    setState(() {});
  }

  _cargarCategorias() async {
    final _categoriasModel = await CategoriaServices().getCategorias();
    List<CardCategoria> categorias = new List<CardCategoria>();
    categorias = _categoriasModel
        .map((categoria) => CardCategoria(categoria, _categoriasModel))
        .toList();
    rows = rowsCategorias(categorias);
  }

  @override
  void initState() {
    _iniciarCategoriaPage();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double maxW = MediaQuery.of(context).size.width;
    double maxH = MediaQuery.of(context).size.height;

    return flag
        ? Container(
            height: maxH,
            width: maxW,
            padding: EdgeInsets.symmetric(
              horizontal: maxW * 0.05,
              vertical: maxH * 0.01,
            ),
            child: Stack(children: <Widget>[
              Center(
                child: ListView.builder(
                    controller: _scrollController,
                    itemCount: rows.length,
                    itemBuilder: (context, i) => rows[i]),
              ),
              Positioned(
                  bottom: 20,
                  right: 20,
                  left: 20,
                  child: StreamBuilder(
                      stream: pageCategoriaBloc.visibleActionButton(),
                      builder:
                          (BuildContext context, AsyncSnapshot<bool> snapshot) {
                        if (!snapshot.hasData) {
                          return SizedBox();
                        }
                        return snapshot.data
                            ? FloatingActionButton(
                                backgroundColor: Color(0xffe32659),
                                mini: true,
                                onPressed: () {
                                  _scrollController.animateTo(0.0,
                                      duration: Duration(milliseconds: 1000),
                                      curve: Curves.fastOutSlowIn);
                                },
                                child: Icon(
                                  Icons.arrow_upward,
                                  color: Colors.white,
                                ),
                                elevation: 50,
                              )
                            : SizedBox();
                      }))
            ]),
          )
        : Center(child: CargandoStayHome());
  }

  void _iniciarCategoriaPage() async {
    _ingresarProductos();
    _cargarCategorias();
    _scrollController = ScrollController(initialScrollOffset: 0.0);
    _scrollController.addListener(_scrollListener);
  }

  List<Widget> rowsCategorias(List<CardCategoria> categorias) {
    final lenght = categorias.length;
    List<Widget> rows = new List<Widget>();
    for (int i = 0; i < lenght; i += 2) {
      if (lenght % 2 != 0 && lenght - 1 == i) {
        rows.add(Row(
          children: <Widget>[categorias[i], Spacer(), Container()],
        ));
      } else {
        rows.add(Row(
          children: <Widget>[
            categorias[i],
            Spacer(),
            categorias[i + 1],
          ],
        ));
      }
    }
    return rows;
  }
}
