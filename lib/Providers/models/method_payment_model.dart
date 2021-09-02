
import 'dart:convert';

MethodPaymentModel methodPaymentModelFromJson(String str) => MethodPaymentModel.fromJson(json.decode(str));

String methodPaymentModelToJson(MethodPaymentModel data) => json.encode(data.toJson());

class MethodPaymentModel {
  String displayName;
  String moduleName;
  String idModulePayment;

  MethodPaymentModel({
    this.displayName,
    this.moduleName,
    this.idModulePayment,
  });

  factory MethodPaymentModel.fromJson(Map<String, dynamic> json) => MethodPaymentModel(
    displayName: json["display_name"],
    moduleName: json["module_name"],
    idModulePayment: json["id_module_payment"],
  );

  Map<String, dynamic> toJson() => {
    "display_name": displayName,
    "module_name": moduleName,
    "id_module_payment": idModulePayment,
  };
}
