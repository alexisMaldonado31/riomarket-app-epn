import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:riomarket/Pantallas/productos_page.dart';
import 'package:riomarket/Providers/models/categoria_model_service.dart';

class DrawerCategorias extends StatelessWidget {
  final int categoriaActual;
  final List<CategoriaModelService> categorias;
  final List<CategoriaModelService> subCategorias;
  final ValueChanged<int> parentAction;

  DrawerCategorias(this.categoriaActual, this.categorias, this.subCategorias,
      {this.parentAction});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: categorias == null
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: categorias.length,
                itemBuilder: (context, i) =>
                    _iconoCategoria(context, categorias[i])));
  }

  Widget _iconoCategoria(
      BuildContext context, CategoriaModelService categoria) {
    return int.parse(categoria.idCategory) != categoriaActual
        ? ListTile(
            leading: _cargarImagen(categoria.urlIcon),
            title: Text(categoria.name, textScaleFactor: 1.0),
            onTap: () {
              var route = new MaterialPageRoute(
                  builder: (BuildContext context) => new ProductosPage(
                      int.parse(categoria.idCategory),
                      categoria.name,
                      categoria.urlBanner));
              Navigator.of(context).pushReplacement(route);
            },
          )
        : Card(
            child: ExpansionTile(
              key: Key(categoriaActual.toString()),
              leading: _cargarImagen(categoria.urlIcon),
              title: Text(categoria.name, textScaleFactor: 1.0),
              children: subCategorias
                  .map((subCategoria) => _subCategoria(context, subCategoria))
                  .toList()
                  .cast<Widget>(),
            ),
          );
  }

  Widget _cargarImagen(String url) {
    return CircleAvatar(
      child: CachedNetworkImage(
        fit: BoxFit.fill,
        imageUrl: url,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.fill,
            ),
          ),
        ),
        placeholder: (context, url) => Center(
            child: CircularProgressIndicator(
          backgroundColor: Theme.of(context).primaryColor,
        )),
        errorWidget: (context, url, error) => Icon(Icons.error_outline),
      ),
    );
  }

  Widget _subCategoria(BuildContext context, CategoriaModelService categoria) {
    return ListTile(
        title: Text(categoria.name, textScaleFactor: 1.0),
        onTap: () {
          parentAction(int.parse(categoria.idCategory));
          Navigator.maybePop(context);
        });
  }
}
