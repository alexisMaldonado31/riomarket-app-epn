class ProductoModel {
    int idProduct;
    String name;
    int active;
    String urlImage;
    int stockQuantity;
    int discounts;

    ProductoModel({
        this.idProduct,
        this.name,
        this.active,
        this.urlImage,
        this.stockQuantity,
        this.discounts
    });

    factory ProductoModel.fromJson(Map<String, dynamic> json) => ProductoModel(
        idProduct     : json["id_product"],
        name          : json["name"],
        active        : json["active"],
        urlImage      : json["url_image"],
        stockQuantity : json["stock_quantity"],
        discounts     : json["discounts"]
    );

    factory ProductoModel.fromJsonHttp(Map<String, dynamic> json) => ProductoModel(
        idProduct     : int.parse(json["id_product"]),
        name          : json["name"],
        active        : int.parse(json["active"]),
        urlImage      : json["url_image"],
        stockQuantity : json["stock_quantity"],
        discounts     : json['discounts'] == '[]' ? 0 : 1
    );

    Map<String, dynamic> toJson() => {
        "id_product"      : idProduct,
        "name"            : name,
        "active"          : active,
        "url_image"       : urlImage,
        "stock_quantity"  : stockQuantity,
        "discounts"       : discounts
    };
}
