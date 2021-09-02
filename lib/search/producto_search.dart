import 'package:flutter/material.dart';
import 'package:riomarket/Pantallas/producto_descripcion_page.dart';
import 'package:riomarket/Providers/Services/productoServices.dart';
import 'package:riomarket/Providers/db_provider.dart';
import 'package:riomarket/Widgets/cargando_widget.dart';
import 'package:riomarket/bloc/producto_bloc.dart';

class ProductoSearch extends SearchDelegate {
  final productoBloc = ProductoBloc();

  @override
  void showResults(BuildContext context) {}

  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones de nuestro AppBar
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del appbar
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
      future: productoBloc.obtenerProductosXNombre(query),
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        if (snapshot.hasData) {
          final productos = snapshot.data;

          return ListView(
            children: productos.map((producto) {
              return ListTile(
                title: Text(producto.name, textScaleFactor: 1.0),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: Theme.of(context).primaryColor,
                ),
                onTap: () async {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) => Container(
                            height: double.infinity,
                            width: double.infinity,
                            color: Colors.black38,
                            child: CargandoStayHome(),
                          ));
                  final productoS = await ProductoServices()
                      .getProductoXId(producto.idProduct);
                  Navigator.pop(context);
                  close(context, null);
                  var route = new MaterialPageRoute(
                      builder: (BuildContext context) =>
                          new ProductoDescripcionPage(productoS));
                  Navigator.of(context).push(route);
                },
              );
            }).toList(),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
