class ListaAddressRegisterModel {
  List<AddressRegisterModel> address = [];
  ListaAddressRegisterModel.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;
    for (var item in jsonList) {
      try {
        final ad = AddressRegisterModel.fromJson(item);
        address.add(ad);
      } catch (ex) {
        if (ex.toString().contains('FormatException: Invalid double')) {
          final ad = AddressRegisterModel.fromJsonSinCoordenadas(item);
          address.add(ad);
        }
      }
    }
  }
}

class AddressRegisterModel {
  String idAddress;
  String idCountry;
  String idState;
  String idCustomer;
  String idManufacturer;
  String idSupplier;
  String idWarehouse;
  String alias;
  String company;
  String lastname;
  String firstname;
  String address1;
  String address2;
  String postcode;
  String city;
  String other;
  String phone;
  String phoneMobile;
  String vatNumber;
  String dni;
  DateTime dateAdd;
  DateTime dateUpd;
  String active;
  String deleted;
  String country;
  dynamic state;
  dynamic stateIso;
  double latitud = 0.0;
  double longitud = 0.0;

  AddressRegisterModel(
      {this.idAddress,
      this.idCountry,
      this.idState,
      this.idCustomer,
      this.idManufacturer,
      this.idSupplier,
      this.idWarehouse,
      this.alias,
      this.company,
      this.lastname,
      this.firstname,
      this.address1,
      this.address2,
      this.postcode,
      this.city,
      this.other,
      this.phone,
      this.phoneMobile,
      this.vatNumber,
      this.dni,
      this.dateAdd,
      this.dateUpd,
      this.active,
      this.deleted,
      this.country,
      this.state,
      this.stateIso,
      this.latitud,
      this.longitud});

  factory AddressRegisterModel.fromJson(Map<String, dynamic> json) =>
      AddressRegisterModel(
          idAddress: json["id_address"],
          idCountry: json["id_country"],
          idState: json["id_state"],
          idCustomer: json["id_customer"],
          idManufacturer: json["id_manufacturer"],
          idSupplier: json["id_supplier"],
          idWarehouse: json["id_warehouse"],
          alias: json["alias"],
          company: json["company"],
          lastname: json["lastname"],
          firstname: json["firstname"],
          address1: json["address1"],
          address2: json["address2"],
          postcode: json["postcode"],
          city: json["city"],
          other: json["other"],
          phone: json["phone"],
          phoneMobile: json["phone_mobile"],
          vatNumber: json["vat_number"],
          dni: json["dni"],
          dateAdd: DateTime.parse(json["date_add"]),
          dateUpd: DateTime.parse(json["date_upd"]),
          active: json["active"],
          deleted: json["deleted"],
          country: json["country"],
          state: json["state"],
          stateIso: json["state_iso"],
          latitud: double.parse(json["latitud"]),
          longitud: double.parse(json["longitud"]));
  factory AddressRegisterModel.fromJsonSinCoordenadas(
          Map<String, dynamic> json) =>
      AddressRegisterModel(
          idAddress: json["id_address"],
          idCountry: json["id_country"],
          idState: json["id_state"],
          idCustomer: json["id_customer"],
          idManufacturer: json["id_manufacturer"],
          idSupplier: json["id_supplier"],
          idWarehouse: json["id_warehouse"],
          alias: json["alias"],
          company: json["company"],
          lastname: json["lastname"],
          firstname: json["firstname"],
          address1: json["address1"],
          address2: json["address2"],
          postcode: json["postcode"],
          city: json["city"],
          other: json["other"],
          phone: json["phone"],
          phoneMobile: json["phone_mobile"],
          vatNumber: json["vat_number"],
          dni: json["dni"],
          dateAdd: DateTime.parse(json["date_add"]),
          dateUpd: DateTime.parse(json["date_upd"]),
          active: json["active"],
          deleted: json["deleted"],
          country: json["country"],
          state: json["state"],
          stateIso: json["state_iso"]);

  Map<String, dynamic> toJson() => {
        "id_address": idAddress,
        "id_country": idCountry,
        "id_state": idState,
        "id_customer": idCustomer,
        "id_manufacturer": idManufacturer,
        "id_supplier": idSupplier,
        "id_warehouse": idWarehouse,
        "alias": alias,
        "company": company,
        "lastname": lastname,
        "firstname": firstname,
        "address1": address1,
        "address2": address2,
        "postcode": postcode,
        "city": city,
        "other": other,
        "phone": phone,
        "phone_mobile": phoneMobile,
        "vat_number": vatNumber,
        "dni": dni,
        "date_add": dateAdd.toIso8601String(),
        "date_upd": dateUpd.toIso8601String(),
        "active": active,
        "deleted": deleted,
        "country": country,
        "state": state,
        "state_iso": stateIso,
      };
}
