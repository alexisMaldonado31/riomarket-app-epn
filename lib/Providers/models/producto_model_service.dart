class ProductosModelService {
    int idProduct;
    int idCategoryDefault;
    String onSale;
    double ecotax;
    String quantity;
    int minimalQuantity;
    String lowStockAlert;
    String outOfStock;
    int active;
    String condition;
    String showPrice;
    String descriptionShort;
    String name;
    double rate;
    String taxName;
    int stockQuantity;
    String urlImage;
    double priceWithouthTax;
    double priceWithTax;
    double discount;
    double priceWithDiscount;

    ProductosModelService({
        this.idProduct,
        this.idCategoryDefault,
        this.onSale,
        this.ecotax,
        this.quantity,
        this.minimalQuantity,
        this.lowStockAlert,
        this.outOfStock,
        this.active,
        this.condition,
        this.showPrice,
        this.descriptionShort,
        this.name,
        this.rate,
        this.taxName,
        this.stockQuantity,
        this.urlImage,
        this.priceWithouthTax,
        this.priceWithTax,
        this.discount,
        this.priceWithDiscount,
    });

    factory ProductosModelService.fromJson(Map<String, dynamic> json) => ProductosModelService(
        idProduct: int.parse(json["id_product"]),
        idCategoryDefault: int.parse(json["id_category_default"]),
        onSale: json["on_sale"],
        ecotax: double.parse(json["ecotax"]),
        quantity: json["quantity"],
        minimalQuantity: int.parse(json["minimal_quantity"]),
        lowStockAlert: json["low_stock_alert"],
        outOfStock: json["out_of_stock"],
        active: int.parse(json["active"]),
        condition: json["condition"],
        showPrice: json["show_price"],
        descriptionShort: json["description_short"],
        name: json["name"],
        rate: json["rate"]/1,
        taxName: json["tax_name"],
        stockQuantity: json["stock_quantity"],
        urlImage: json["url_image"],
        priceWithouthTax: double.parse(json["price_withouth_tax"]),
        priceWithTax: json["price_with_tax"].toDouble(),
        discount: json["discount"]/1,
        priceWithDiscount: json["price_with_discount"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "id_product": idProduct,
        "id_category_default": idCategoryDefault,
        "on_sale": onSale,
        "ecotax": ecotax,
        "quantity": quantity,
        "minimal_quantity": minimalQuantity,
        "low_stock_alert": lowStockAlert,
        "out_of_stock": outOfStock,
        "active": active,
        "condition": condition,
        "show_price": showPrice,
        "description_short": descriptionShort,
        "name": name,
        "rate": rate,
        "tax_name": taxName,
        "stock_quantity": stockQuantity,
        "url_image": urlImage,
        "price_withouth_tax": priceWithouthTax,
        "price_with_tax": priceWithTax,
        "discount": discount,
        "price_with_discount": priceWithDiscount,
    };
}
