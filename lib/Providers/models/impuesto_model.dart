class ImpuestoModel {
    int idImpuestos;
    int idPrestashop;
    double rate;
    String name;

    ImpuestoModel({
        this.idImpuestos,
        this.idPrestashop,
        this.rate,
        this.name,
    });

    factory ImpuestoModel.fromJson(Map<String, dynamic> json) => ImpuestoModel(
        idImpuestos: json["idImpuestos"],
        idPrestashop: json["idPrestashop"],
        rate: json["rate"].toDouble(),
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "idImpuestos": idImpuestos,
        "idPrestashop": idPrestashop,
        "rate": rate,
        "name": name,
    };
}
