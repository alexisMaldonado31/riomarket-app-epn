class ItemCarritoModel {
    int idItemCarrito;
    int idProducto;
    String descripcionProducto;
    int cantidadProducto;
    int stock;
    double precioProducto;
    double precioIva;
    double precioDescuento;
    String imagenUrl;

    ItemCarritoModel({
        this.idItemCarrito,
        this.idProducto,
        this.descripcionProducto,
        this.cantidadProducto,
        this.stock,
        this.precioProducto,
        this.precioDescuento,
        this.precioIva,
        this.imagenUrl,
    });

    factory ItemCarritoModel.fromJson(Map<String, dynamic> json) => ItemCarritoModel(
        idItemCarrito:        json["idItemCarrito"],
        idProducto:           json["idProducto"],
        descripcionProducto:  json["descripcionProducto"],
        cantidadProducto:     json["cantidadProducto"],
        stock:                json['stock'],
        precioProducto:       json["precioProducto"].toDouble(),
        precioIva:            json["precioIva"].toDouble(),
        precioDescuento:      json["precioDescuento"].toDouble(),
        imagenUrl:            json["imagenUrl"]
    );

    Map<String, dynamic> toJson() => {
        "idItemCarrito":        idItemCarrito,
        "idProducto":           idProducto,
        "descripcionProducto":  descripcionProducto,
        "cantidadProducto":     cantidadProducto,
        "stock":                stock,
        "precioProducto":       precioProducto,
        "precioIva":            precioIva,
        "precioDescuento":      precioDescuento,
        "imagenUrl":            imagenUrl
    };
}
