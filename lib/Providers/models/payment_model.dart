class PaymentModel {
  String idAddressDelivery;
  String idAddressInvoice;
  String idCustomer;
  List<Product> products;

  PaymentModel({
    this.idAddressDelivery,
    this.idAddressInvoice,
    this.idCustomer,
    this.products
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
    idAddressDelivery: json["id_address_delivery"],
    idAddressInvoice: json["id_address_invoice"],
    idCustomer: json["id_customer"],
    products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
  );

  Map<String, dynamic> toJson() {
    List<Map<String,dynamic>> listaProductos = List<Map<String,dynamic>>();
    products.forEach((element) {
      listaProductos.add(element.toJson());
    });

    return {
      "id_address_delivery": idAddressDelivery,
    "id_address_invoice": idAddressInvoice,
    "id_customer": idCustomer,
    "products": listaProductos
    };
  }
}

class Product {
  String idProduct;
  String productQuantity;

  Product({
    this.idProduct,
    this.productQuantity,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    idProduct: json["id_product"],
    productQuantity: json["product_quantity"],
  );

  Map<String, dynamic> toJson() => {
    "id_product": idProduct,
    "product_quantity": productQuantity,
  };
}