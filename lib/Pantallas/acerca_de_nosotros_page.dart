import 'package:flutter/material.dart';
import 'package:riomarket/Pantallas/web_view_page.dart';

class AcercaDeNosotrosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Acerca de Nosotros',
          textScaleFactor: 1.0,
        ),
      ),
      body: Column(
        children: <Widget>[
          ListTile(
              leading: Icon(
                Icons.question_answer,
                color: Theme.of(context).primaryColor,
              ),
              title: Text('Preguntas Frecuentes', textScaleFactor: 1.0),
              onTap: () {
                var route = new MaterialPageRoute(
                    builder: (BuildContext context) => new WebViewPage(
                        'https://stayhome.cerealesandinos.com/stayhome_app_services/static_pages/preguntas_frecuentes.html',
                        'Preguntas Frecuentes'));
                Navigator.of(context).push(route);
              }),
          ListTile(
              leading: Icon(
                Icons.people,
                color: Theme.of(context).primaryColor,
              ),
              title: Text('Acerca de Nosotros', textScaleFactor: 1.0),
              onTap: () {
                var route = new MaterialPageRoute(
                    builder: (BuildContext context) => new WebViewPage(
                        'https://stayhome.cerealesandinos.com/stayhome_app_services/static_pages/nosotros.html',
                        'Acerca de Nosotros'));
                Navigator.of(context).push(route);
              }),
          ListTile(
              leading: Icon(
                Icons.description,
                color: Theme.of(context).primaryColor,
              ),
              title: Text('Términos y Condiciones', textScaleFactor: 1.0),
              onTap: () {
                var route = new MaterialPageRoute(
                    builder: (BuildContext context) => new WebViewPage(
                        'https://stayhome.cerealesandinos.com/stayhome_app_services/static_pages/terminos.html ',
                        'Términos y Condiciones'));
                Navigator.of(context).push(route);
              }),
          ListTile(
              leading: Icon(
                Icons.lock,
                color: Theme.of(context).primaryColor,
              ),
              title: Text('Políticas de Privacidad', textScaleFactor: 1.0),
              onTap: () {
                var route = new MaterialPageRoute(
                    builder: (BuildContext context) => new WebViewPage(
                        'https://stayhome.cerealesandinos.com/stayhome_app_services/static_pages/politicas.html',
                        'Políticas de Privacidad'));
                Navigator.of(context).push(route);
              }),
        ],
      ),
    );
  }
}
