class AddressModel {
  String firstName;
  String lastName;
  String address1;
  String city;
  String phone;
  String phoneMobile;
  String dni;
  String latitud;
  String longitud;
  String customerId;
  String addressId;

  AddressModel({
    this.firstName,
    this.lastName,
    this.address1,
    this.city,
    this.phone,
    this.phoneMobile,
    this.dni,
    this.latitud,
    this.longitud,
    this.customerId,
    this.addressId
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
    address1: json["address1"],
    city: json["city"],
    phone: json["phone"],
    phoneMobile: json["phone_mobile"],
    dni: json["dni"],
    latitud: json["latitud"],
    longitud: json["longitud"],
    customerId:json["customer_id"]
  );

  Map<String, dynamic> toJson() => {
    "address1": address1,
    "city": city,
    "phone_mobile": phoneMobile,
    "dni": dni,
    "latitud": latitud,
    "longitud": longitud,
    "id_customer":customerId,
    "firstname":firstName,
    "lastname":lastName
  };

  Map<String, dynamic> toJsonUpdate() => {
    "address1": address1,
    "city": city,
    "phone_mobile": phoneMobile,
    "dni": dni,
    "latitud": latitud,
    "longitud": longitud,
    "id_customer":customerId,
    "firstname":firstName,
    "lastname":lastName,
    "id_address" : addressId
  };
}