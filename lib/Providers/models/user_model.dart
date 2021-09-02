// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  dynamic id;
  dynamic idShop;
  String idShopGroup;
  String secureKey;
  dynamic note;
  String idGender;
  String idDefaultGroup;
  dynamic idLang;
  String lastname;
  String firstname;
  dynamic birthday;
  String email;
  dynamic newsletter;
  dynamic ipRegistrationNewsletter;
  String newsletterDateAdd;
  dynamic optin;
  dynamic website;
  dynamic company;
  dynamic siret;
  dynamic ape;
  dynamic outstandingAllowAmount;
  dynamic showPublicPrices;
  dynamic idRisk;
  dynamic maxPaymentDays;
  String passwd;
  DateTime lastPasswdGen;
  dynamic active;
  dynamic isGuest;
  dynamic deleted;
  DateTime dateAdd;
  DateTime dateUpd;
  dynamic years;
  dynamic days;
  dynamic months;
  dynamic geolocIdCountry;
  dynamic geolocIdState;
  dynamic geolocPostcode;
  int logged;
  dynamic idGuest;
  dynamic groupBox;
  dynamic resetPasswordToken;
  String resetPasswordValidity;
  List<dynamic> idShopList;
  bool forceId;

  UserModel({
    this.id,
    this.idShop,
    this.idShopGroup,
    this.secureKey,
    this.note,
    this.idGender,
    this.idDefaultGroup,
    this.idLang,
    this.lastname,
    this.firstname,
    this.birthday,
    this.email,
    this.newsletter,
    this.ipRegistrationNewsletter,
    this.newsletterDateAdd,
    this.optin,
    this.website,
    this.company,
    this.siret,
    this.ape,
    this.outstandingAllowAmount,
    this.showPublicPrices,
    this.idRisk,
    this.maxPaymentDays,
    this.passwd,
    this.lastPasswdGen,
    this.active,
    this.isGuest,
    this.deleted,
    this.dateAdd,
    this.dateUpd,
    this.years,
    this.days,
    this.months,
    this.geolocIdCountry,
    this.geolocIdState,
    this.geolocPostcode,
    this.logged,
    this.idGuest,
    this.groupBox,
    this.resetPasswordToken,
    this.resetPasswordValidity,
    this.idShopList,
    this.forceId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    idShop: json["id_shop"].toString(),
    idShopGroup: json["id_shop_group"],
    secureKey: json["secure_key"],
    note: json["note"],
    idGender: json["id_gender"],
    idDefaultGroup: json["id_default_group"].toString(),
    idLang: json["id_lang"],
    lastname: json["lastname"],
    firstname: json["firstname"],
    birthday: json["birthday"],
    email: json["email"],
    newsletter: json["newsletter"],
    ipRegistrationNewsletter: json["ip_registration_newsletter"],
    newsletterDateAdd: json["newsletter_date_add"],
    optin: json["optin"],
    website: json["website"],
    company: json["company"],
    siret: json["siret"],
    ape: json["ape"],
    outstandingAllowAmount: json["outstanding_allow_amount"],
    showPublicPrices: json["show_public_prices"],
    idRisk: json["id_risk"],
    maxPaymentDays: json["max_payment_days"],
    passwd: json["passwd"],
    lastPasswdGen: DateTime.parse(json["last_passwd_gen"]),
    active: json["active"],
    isGuest: json["is_guest"],
    deleted: json["deleted"],
    dateAdd: DateTime.parse(json["date_add"]),
    dateUpd: DateTime.parse(json["date_upd"]),
    years: json["years"],
    days: json["days"],
    months: json["months"],
    geolocIdCountry: json["geoloc_id_country"],
    geolocIdState: json["geoloc_id_state"],
    geolocPostcode: json["geoloc_postcode"],
    logged: json["logged"],
    idGuest: json["id_guest"],
    groupBox: json["groupBox"],
    resetPasswordToken: json["reset_password_token"],
    resetPasswordValidity: json["reset_password_validity"],
    idShopList: List<dynamic>.from(json["id_shop_list"].map((x) => x)),
    forceId: json["force_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "id_shop": idShop,
    "id_shop_group": idShopGroup,
    "secure_key": secureKey,
    "note": note,
    "id_gender": idGender,
    "id_default_group": idDefaultGroup,
    "id_lang": idLang,
    "lastname": lastname,
    "firstname": firstname,
    "birthday": birthday,
    "email": email,
    "newsletter": newsletter,
    "ip_registration_newsletter": ipRegistrationNewsletter,
    "newsletter_date_add": newsletterDateAdd,
    "optin": optin,
    "website": website,
    "company": company,
    "siret": siret,
    "ape": ape,
    "outstanding_allow_amount": outstandingAllowAmount,
    "show_public_prices": showPublicPrices,
    "id_risk": idRisk,
    "max_payment_days": maxPaymentDays,
    "passwd": passwd,
    "last_passwd_gen": lastPasswdGen.toIso8601String(),
    "active": active,
    "is_guest": isGuest,
    "deleted": deleted,
    "date_add": dateAdd.toIso8601String(),
    "date_upd": dateUpd.toIso8601String(),
    "years": years,
    "days": days,
    "months": months,
    "geoloc_id_country": geolocIdCountry,
    "geoloc_id_state": geolocIdState,
    "geoloc_postcode": geolocPostcode,
    "logged": logged,
    "id_guest": idGuest,
    "groupBox": groupBox,
    "reset_password_token": resetPasswordToken,
    "reset_password_validity": resetPasswordValidity,
    "id_shop_list": List<dynamic>.from(idShopList.map((x) => x)),
    "force_id": forceId,
  };
}
