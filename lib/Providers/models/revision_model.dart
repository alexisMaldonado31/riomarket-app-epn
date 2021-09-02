import 'dart:convert';

RevisionModel revisionModelFromJson(String str) => RevisionModel.fromJson(json.decode(str));

String revisionModelToJson(RevisionModel data) => json.encode(data.toJson());

class RevisionModel {
  String idCustomer;
  String idCart;
  String idCarrier;
  String idVoucher;
  String paymentName;
  String token ='';
  double amountPaid;

  RevisionModel({
    this.idCustomer,
    this.idCart,
    this.idCarrier,
    this.idVoucher,
    this.paymentName,
    this.amountPaid,
  });

  factory RevisionModel.fromJson(Map<String, dynamic> json) => RevisionModel(
    idCustomer: json["id_customer"],
    idCart: json["id_cart"],
    idCarrier: json["id_carrier"],
    idVoucher: json["id_voucher"],
    paymentName: json["payment_name"],
    amountPaid: json["amount_paid"],
  );

  Map<String, dynamic> toJson() => {
    "id_customer": idCustomer,
    "id_cart": idCart,
    "id_carrier": idCarrier,
    "id_voucher": idVoucher,
    "payment_name": paymentName,
    "amount_paid": amountPaid.toString(),
    "token": token
  };
}
