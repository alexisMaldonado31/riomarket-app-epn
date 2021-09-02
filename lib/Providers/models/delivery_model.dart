
import 'dart:convert';

DeliveryModel deliveryModelFromJson(String str) => DeliveryModel.fromJson(json.decode(str));

String deliveryModelToJson(DeliveryModel data) => json.encode(data.toJson());

class DeliveryModel {
  String id;
  String idShopGroup;
  String idShop;
  String idAddressDelivery;
  String idAddressInvoice;
  String idCurrency;
  String idCustomer;
  dynamic idGuest;
  String idLang;
  int recyclable;
  int gift;
  dynamic giftMessage;
  dynamic mobileTheme;
  DateTime dateAdd;
  String secureKey;
  dynamic idCarrier;
  DateTime dateUpd;
  bool checkedTos;
  dynamic pictures;
  dynamic textFields;
  dynamic deliveryOption;
  bool allowSeperatedPackage;
  List<dynamic> idShopList;
  bool forceId;
  String idCart;
  List<CartProduct> cartProducts;
  List<AvailableCarrier> availableCarriers;

  DeliveryModel({
    this.id,
    this.idShopGroup,
    this.idShop,
    this.idAddressDelivery,
    this.idAddressInvoice,
    this.idCurrency,
    this.idCustomer,
    this.idGuest,
    this.idLang,
    this.recyclable,
    this.gift,
    this.giftMessage,
    this.mobileTheme,
    this.dateAdd,
    this.secureKey,
    this.idCarrier,
    this.dateUpd,
    this.checkedTos,
    this.pictures,
    this.textFields,
    this.deliveryOption,
    this.allowSeperatedPackage,
    this.idShopList,
    this.forceId,
    this.idCart,
    this.cartProducts,
    this.availableCarriers,
  });

  factory DeliveryModel.fromJson(Map<String, dynamic> json) => DeliveryModel(
    id: json["id"],
    idShopGroup: json["id_shop_group"],
    idShop: json["id_shop"],
    idAddressDelivery: json["id_address_delivery"],
    idAddressInvoice: json["id_address_invoice"],
    idCurrency: json["id_currency"],
    idCustomer: json["id_customer"],
    idGuest: json["id_guest"],
    idLang: json["id_lang"],
    recyclable: json["recyclable"],
    gift: json["gift"],
    giftMessage: json["gift_message"],
    mobileTheme: json["mobile_theme"],
    dateAdd: DateTime.parse(json["date_add"]),
    secureKey: json["secure_key"],
    idCarrier: json["id_carrier"],
    dateUpd: DateTime.parse(json["date_upd"]),
    checkedTos: json["checkedTos"],
    pictures: json["pictures"],
    textFields: json["textFields"],
    deliveryOption: json["delivery_option"],
    allowSeperatedPackage: json["allow_seperated_package"],
    idShopList: List<dynamic>.from(json["id_shop_list"].map((x) => x)),
    forceId: json["force_id"],
    idCart: json["id_cart"],
    cartProducts: List<CartProduct>.from(json["cart_products"].map((x) => CartProduct.fromJson(x))),
    availableCarriers: List<AvailableCarrier>.from(json["available_carriers"].map((x) => AvailableCarrier.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "id_shop_group": idShopGroup,
    "id_shop": idShop,
    "id_address_delivery": idAddressDelivery,
    "id_address_invoice": idAddressInvoice,
    "id_currency": idCurrency,
    "id_customer": idCustomer,
    "id_guest": idGuest,
    "id_lang": idLang,
    "recyclable": recyclable,
    "gift": gift,
    "gift_message": giftMessage,
    "mobile_theme": mobileTheme,
    "date_add": dateAdd.toIso8601String(),
    "secure_key": secureKey,
    "id_carrier": idCarrier,
    "date_upd": dateUpd.toIso8601String(),
    "checkedTos": checkedTos,
    "pictures": pictures,
    "textFields": textFields,
    "delivery_option": deliveryOption,
    "allow_seperated_package": allowSeperatedPackage,
    "id_shop_list": List<dynamic>.from(idShopList.map((x) => x)),
    "force_id": forceId,
    "id_cart": idCart,
    "cart_products": List<dynamic>.from(cartProducts.map((x) => x.toJson())),
    "available_carriers": List<dynamic>.from(availableCarriers.map((x) => x.toJson())),
  };
}

class AvailableCarrier {
  String idCarrier;
  String idReference;
  String idTaxRulesGroup;
  String name;
  String url;
  String active;
  String deleted;
  String shippingHandling;
  String rangeBehavior;
  String isModule;
  String isFree;
  String shippingExternal;
  String needRange;
  String externalModuleName;
  String shippingMethod;
  String position;
  String maxWidth;
  String maxHeight;
  String maxDepth;
  String maxWeight;
  String grade;
  String delay;
  double price;
  double priceTaxExc;
  String img;

  AvailableCarrier({
    this.idCarrier,
    this.idReference,
    this.idTaxRulesGroup,
    this.name,
    this.url,
    this.active,
    this.deleted,
    this.shippingHandling,
    this.rangeBehavior,
    this.isModule,
    this.isFree,
    this.shippingExternal,
    this.needRange,
    this.externalModuleName,
    this.shippingMethod,
    this.position,
    this.maxWidth,
    this.maxHeight,
    this.maxDepth,
    this.maxWeight,
    this.grade,
    this.delay,
    this.price,
    this.priceTaxExc,
    this.img,
  });

  factory AvailableCarrier.fromJson(Map<String, dynamic> json) => AvailableCarrier(
    idCarrier: json["id_carrier"],
    idReference: json["id_reference"],
    idTaxRulesGroup: json["id_tax_rules_group"],
    name: json["name"],
    url: json["url"],
    active: json["active"],
    deleted: json["deleted"],
    shippingHandling: json["shipping_handling"],
    rangeBehavior: json["range_behavior"],
    isModule: json["is_module"],
    isFree: json["is_free"],
    shippingExternal: json["shipping_external"],
    needRange: json["need_range"],
    externalModuleName: json["external_module_name"],
    shippingMethod: json["shipping_method"],
    position: json["position"],
    maxWidth: json["max_width"],
    maxHeight: json["max_height"],
    maxDepth: json["max_depth"],
    maxWeight: json["max_weight"],
    grade: json["grade"],
    delay: json["delay"],
    price: json["price"].toDouble(),
    priceTaxExc: json["price_tax_exc"].toDouble(),
    img: json["img"],
  );

  Map<String, dynamic> toJson() => {
    "id_carrier": idCarrier,
    "id_reference": idReference,
    "id_tax_rules_group": idTaxRulesGroup,
    "name": name,
    "url": url,
    "active": active,
    "deleted": deleted,
    "shipping_handling": shippingHandling,
    "range_behavior": rangeBehavior,
    "is_module": isModule,
    "is_free": isFree,
    "shipping_external": shippingExternal,
    "need_range": needRange,
    "external_module_name": externalModuleName,
    "shipping_method": shippingMethod,
    "position": position,
    "max_width": maxWidth,
    "max_height": maxHeight,
    "max_depth": maxDepth,
    "max_weight": maxWeight,
    "grade": grade,
    "delay": delay,
    "price": price,
    "price_tax_exc": priceTaxExc,
    "img": img,
  };
}

class CartProduct {
  String idProduct;
  String cartQuantity;

  CartProduct({
    this.idProduct,
    this.cartQuantity,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json) => CartProduct(
    idProduct: json["id_product"],
    cartQuantity: json["cart_quantity"],
  );

  Map<String, dynamic> toJson() => {
    "id_product": idProduct,
    "cart_quantity": cartQuantity,
  };
}