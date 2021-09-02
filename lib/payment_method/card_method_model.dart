import 'dart:convert';

CardMethodModel cardMethodModelFromJson(String str) => CardMethodModel.fromJson(json.decode(str));

String cardMethodModelToJson(CardMethodModel data) => json.encode(data.toJson());

class CardMethodModel {
  CardModel card;
  double totalAmount;
  String currency;

  CardMethodModel({
    this.card,
    this.totalAmount,
    this.currency,
  });

  factory CardMethodModel.fromJson(Map<String, dynamic> json) => CardMethodModel(
    card: CardModel.fromJson(json["card"]),
    totalAmount: json["totalAmount"].toDouble(),
    currency: json["currency"],
  );

  Map<String, dynamic> toJson() => {
    "card": card.toJson(),
    "totalAmount": totalAmount,
    "currency": currency,
  };
}

class CardModel {
  String name;
  String number;
  String expiryMonth;
  String expiryYear;
  String cvv;

  CardModel({
    this.name,
    this.number,
    this.expiryMonth,
    this.expiryYear,
    this.cvv,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) => CardModel(
    name: json["name"],
    number: json["number"],
    expiryMonth: json["expiryMonth"],
    expiryYear: json["expiryYear"],
    cvv: json["cvv"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "number": number,
    "expiryMonth": expiryMonth,
    "expiryYear": expiryYear,
    "cvv": cvv,
  };
}