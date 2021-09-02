import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:riomarket/Providers/Services/categoriaServices.dart';

import 'package:riomarket/Providers/Services/productoServices.dart';
import 'package:riomarket/Providers/models/categoria_model_service.dart';
import 'package:riomarket/Providers/models/producto_model_service.dart';

import 'package:riomarket/Widgets/bottomsheet_carrito_widget.dart';
import 'package:riomarket/Widgets/card_product_widget.dart';
import 'package:riomarket/Widgets/cargando_widget.dart';
import 'package:riomarket/Widgets/carrito-compra_widget.dart';

class ProductosPage extends StatefulWidget {
  final int categoriaId;
  final String categoriaNombre;
  final String bannerUrl;

  ProductosPage(this.categoriaId, this.categoriaNombre, this.bannerUrl);

  @override
  _ProductosPageState createState() => _ProductosPageState();
}

class _ProductosPageState extends State<ProductosPage> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  ProductoServices productosServices = new ProductoServices();
  CategoriaServices categoriaServices = new CategoriaServices();

  List<ProductosModelService> productos = new List();
  List<CategoriaModelService> subCategorias = new List();
  List<CategoriaModelService> categorias;
  List<Widget> rows = new List<Widget>();

  ScrollController _scrollController = new ScrollController();

  bool flag = false;
  bool isLoading = false;
  bool seguirCargando = true;
  int start = 0;
  int categoriaIdService = 0;

  @override
  void initState() {
    super.initState();
    _iniciarProductPage();
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldKey,
        drawerEdgeDragWidth: screenSize.width / 2,
        appBar: AppBar(
          title: Text(
            widget.categoriaNombre,
            overflow: TextOverflow.ellipsis,
          ),
          centerTitle: true,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.02),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              flag
                  ? Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenSize.width * 0.03),
                        child: ListView.builder(
                            controller: _scrollController,
                            itemCount: rows.length,
                            itemBuilder: (context, i) => rows[i]),
                      ),
                    )
                  : Center(child: CargandoStayHome()),
              _crearLoading()
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          mini: false,
          isExtended: true,
          backgroundColor: Color(0xffe32659),
          onPressed: () {
            _carritoDeCompras(context, screenSize.height, primaryColor);
          },
          child: Center(
              child: Carrito(
            colorCarrito: Colors.white,
            notificationColor: Color(0xff04A6A9),
          )),
        ),
        //endDrawer: DrawerCategorias(widget.categoriaId, categorias, subCategorias, parentAction: _cargarProductosDesdeDrawer,),
        drawerDragStartBehavior: DragStartBehavior.down);
  }

  _carritoDeCompras(BuildContext context, double height, Color primaryColor) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.circular(20),
        ),
        isScrollControlled: true,
        backgroundColor: Colors.white,
        builder: (BuildContext context) => Container(
              height: height * 0.65,
              child: BottomSheetCarrito(Color(0xffe32659)),
            ));
  }

  Widget _crearLoading() {
    return isLoading
        ? Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                ],
              ),
            ],
          )
        : Container();
  }

  _aumentarProductos(int categoriaId) async {
    setState(() {
      isLoading = true;
    });
    final duration = new Duration(seconds: 2);
    return new Timer(duration, () async {
      isLoading = false;
      start += 20;
      final productos = await productosServices.getProductoXCategoria(
          categoriaId: categoriaId, start: start);
      if (productos.length > 0) {
        this.rows.addAll(rowsProductos(productos));
        setState(() {});
        _scrollController.animateTo(_scrollController.position.pixels + 100,
            curve: Curves.fastOutSlowIn, duration: Duration(milliseconds: 250));
      } else {
        seguirCargando = false;
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  _cargarProductos(int categoriaId) async {
    final productos = await productosServices.getProductoXCategoria(
        categoriaId: categoriaId, start: start);
    this.productos = productos;
    this.flag = true;
    rows = rowsProductos(productos);
    setState(() {});
  }

  _cargarSubCategorias() async {
    final subCategorias =
        await categoriaServices.getSubCategoriasXPadre(categoriaIdService);
    this.subCategorias = subCategorias;
    setState(() {});
  }

  _cargarProductosDesdeDrawer(int categoriaId) {
    setState(() {
      flag = false;
      start = 0;
      this.categoriaIdService = categoriaId;
    });
    _cargarProductos(categoriaId);
  }

  void _cargarCategorias() async {
    categorias = await categoriaServices.getCategorias();
    setState(() {});
  }

  void _iniciarProductPage() async {
    categoriaIdService = widget.categoriaId;
    _cargarProductos(categoriaIdService);
    _cargarSubCategorias();
    _cargarCategorias();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          seguirCargando) {
        _aumentarProductos(categoriaIdService);
      }
    });
  }

  List<Widget> rowsProductos(List<ProductosModelService> productos) {
    final lenght = productos.length;
    final productosCard =
        productos.map((producto) => CardProduct(producto)).toList();
    List<Widget> rows = new List<Widget>();
    for (int i = 0; i < lenght; i += 2) {
      if (lenght % 2 != 0 && lenght - 1 == i) {
        rows.add(Row(
          children: <Widget>[productosCard[i], Spacer(), Container()],
        ));
      } else {
        rows.add(Row(
          children: <Widget>[
            productosCard[i],
            Spacer(),
            productosCard[i + 1],
          ],
        ));
      }
    }
    return rows;
  }
}
