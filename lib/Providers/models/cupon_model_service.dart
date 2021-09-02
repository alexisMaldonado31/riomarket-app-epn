class CuponModelService {
    int idCartRule;
    String description;
    double minimumAmount;
    double reductionPercent;
    double reductionAmount;

    CuponModelService({
        this.idCartRule,
        this.description,
        this.minimumAmount,
        this.reductionPercent,
        this.reductionAmount,
    });

    factory CuponModelService.fromJson(Map<String, dynamic> json) => CuponModelService(
        idCartRule        : int.parse(json['id_cart_rule']),
        description       : json["description"],
        minimumAmount     : double.parse(json["minimum_amount"]),
        reductionPercent  : double.parse(json["reduction_percent"]),
        reductionAmount   : double.parse(json["reduction_amount"]),
    );

    Map<String, dynamic> toJson() => {
        "id_cart_rule"      : idCartRule,
        "description"       : description,
        "minimum_amount"    : minimumAmount,
        "reduction_percent" : reductionPercent,
        "reduction_amount"  : reductionAmount,
    };

    double descuento(double subtotal){      
      if(this.reductionPercent != 0.0){
        return subtotal * (this.reductionPercent/100);
      }

      return this.minimumAmount; 
    }

    factory CuponModelService.vacio()=> CuponModelService(
      idCartRule: 0,
      description: 'error',
      minimumAmount: 0.0,
      reductionPercent: 0.0,
      reductionAmount: 0.0,
    );
}
