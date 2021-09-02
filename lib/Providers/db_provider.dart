import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'models/itemCarrito_model.dart';
export 'models/itemCarrito_model.dart';

import 'class/total.dart';
export 'class/total.dart';

import 'models/producto_model.dart';
export 'models/producto_model.dart';

class DBProvider{
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

    Future<Database> get database async{
    if(_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  initDB() async{
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, 'StayHome.db');

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db){},
      onCreate: (Database db, int version) async{
        
        await db.execute(
          'CREATE TABLE ItemsCarrito('
          ' idItemCarrito INTEGER PRIMARY KEY AUTOINCREMENT,'
          ' idProducto INTEGER,'
          ' descripcionProducto TEXT,'
          ' cantidadProducto INTEGER,'
          ' stock INTEGER,'
          ' precioProducto NUMERIC,'
          ' precioIva NUMERIC,'
          ' precioDescuento NUMERIC,'
          ' imagenUrl TEXT'          
          ')'
        );
        await db.execute(
          'CREATE TABLE Producto('
          ' id_product INTEGER,'
          ' name TEXT,'
          ' active INT,'
          ' url_image TEXT,'
          ' stock_quantity INT,'
          ' discounts INT'
          ')'
        );
      }
    );
  }

  

  //CRUD CARRITO//

  nuevoItemCarrito(ItemCarritoModel nuevoItemCarrito) async{
    final db = await database;

    final res = await db.insert('ItemsCarrito', nuevoItemCarrito.toJson());
    return res;
  }

  Future<List<ItemCarritoModel>> getAllItemsCarrito() async{

    final db = await database;
    final res = await db.query('ItemsCarrito');

    List<ItemCarritoModel> list = res.isNotEmpty 
                              ? res.map((c)=> ItemCarritoModel.fromJson(c)).toList() 
                              : [];

    return list; 
  }

  Future<int> getCountItemsCarrito() async{
    final db = await database;
    final res = await db.rawQuery('SELECT COUNT(*) as CANTIDAD FROM ItemsCarrito');

    return res.isNotEmpty ? res.first['CANTIDAD'] : 0;

  }

  Future<int> updateItemCarrito(ItemCarritoModel nuevoItemCarrito) async{
    final db = await database;
    final res = await db.update('ItemsCarrito', 
                        nuevoItemCarrito.toJson(), 
                        where: 'idItemCarrito = ?', 
                        whereArgs: [nuevoItemCarrito.idItemCarrito]
                      );
    return res;
  }

  Future<int> deleteItemCarrito(int id) async{
    final db = await database;
    final res = await db.delete('ItemsCarrito', 
                        where: 'idItemCarrito = ?', 
                        whereArgs: [id]
                      );
    return res;
  }

  Future<int> deleteAllItemsCarrito() async{
    final db = await database;
    final res = await db.rawDelete("DELETE FROM ItemsCarrito");
    return res;
  }

  Future<Total> totalCarrito() async{
    final db = await database;
    final res = await db.rawQuery("SELECT SUM(precioProducto*cantidadProducto) AS subtotal, SUM(precioIva*cantidadProducto) as iva, SUM(precioDescuento*cantidadProducto) as descuento FROM ItemsCarrito");

    return res.isNotEmpty ? Total.fromJson(res.first) : Total(subtotal: 0, iva:0);
  }

  Future<int> existeProductoEnCarrito(int idProducto) async{
    final db = await database;
    final res = await db.rawQuery("SELECT idItemCarrito FROM ItemsCarrito WHERE idProducto = ?", [idProducto]);

    return res.isNotEmpty ? res.first['idItemCarrito'] : 0;
  }

  //CRUD PRODUCTOS
  nuevoProducto(ProductoModel nuevoProducto) async{
    final db = await database;

    final res = await db.insert('Producto', nuevoProducto.toJson());
    return res;
  }

  Future<List<ProductoModel>> getProductoXNombre(String nombre) async{
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Producto WHERE active = 1 AND name LIKE '%$nombre%'");

    List<ProductoModel> list = res.isNotEmpty 
                              ? res.map((c)=> ProductoModel.fromJson(c)).toList() 
                              : [];

    return list;
  }



  Future<int> deleteAllProductos() async{
    final db = await database;
    final res = await db.rawDelete("DELETE FROM Producto");
    return res;
  }
}