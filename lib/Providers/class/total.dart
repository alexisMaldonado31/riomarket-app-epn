class Total{
  double subtotal;
  double iva;
  double descuento;

  Total({
      this.subtotal,
      this.iva,
      this.descuento
  });

  factory Total.fromJson(Map<String, dynamic> json) => Total(
      subtotal: json["subtotal"].toDouble(),
      iva: json["iva"].toDouble(),
      descuento: json["descuento"].toDouble()
  );

  Map<String, dynamic> toJson() => {
      "subtotal"  : subtotal,
      "iva"       : iva,
      "descuento" : descuento
  };

  totalCarrito() {
    return this.subtotal + this.iva - this.descuento;
  }
}
