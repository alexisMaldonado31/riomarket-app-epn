import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:riomarket/Pantallas/productos_page.dart';
import 'package:riomarket/Providers/models/categoria_model_service.dart';

class CardCategoria extends StatelessWidget {
  final CategoriaModelService categoria;
  final List<CategoriaModelService> categorias;
  CardCategoria(this.categoria, this.categorias);

  @override
  Widget build(BuildContext context) {
    double maxW = MediaQuery.of(context).size.width;
    double maxH = MediaQuery.of(context).size.height;
    return InkWell(
        onTap: () {
          var route = new MaterialPageRoute(
              builder: (BuildContext context) => new ProductosPage(
                  int.parse(categoria.idCategory),
                  categoria.name,
                  categoria.urlBanner));
          Navigator.of(context).push(route);
        },
        child: Container(
            width: maxW * 0.4,
            height: maxH * 0.30,
            margin: EdgeInsets.only(bottom: maxH * 0.03),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      blurRadius: 5,
                      color: Colors.black38,
                      offset: Offset(3, 4),
                      spreadRadius: 1)
                ]),
            child: _imagenCategoria(
                categoria.name, categoria.urlMiniBanner, maxW)));
  }

  Widget _imagenCategoria(String nombre, String url, double maxW) {
    return url == ''
        ? _imageNotFound(nombre, maxW)
        : ClipRRect(
            borderRadius: BorderRadius.circular(20),
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
              errorWidget: (context, url, error) =>
                  _imageNotFound(nombre, maxW),
            ),
          );
  }

  Widget _imageNotFound(String nombre, double maxW) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/img/no-image.jpg'),
                      fit: BoxFit.fill))),
          Align(
            alignment: Alignment(0, -0.9),
            child: Text(
              nombre,
              textScaleFactor: 1.0,
              style: TextStyle(fontSize: maxW * 0.05),
            ),
          )
        ],
      ),
    );
  }
}
