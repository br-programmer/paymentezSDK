class OrderPay {
  String devReference;
  double amount;
  String description;
  double vat;

  /// numero de cuotas si es al contado(debit)/corriente(credito) colocar 0
  int? installments;

  /// colocar el tipo segundo el listado, obtenga el listado con PaymentezValidate.getInstallmentsType()
  int? installmentsType;

  double? taxableAmount;
  int taxPercentage;
  OrderPay({
    required this.devReference,
    required this.amount,
    required this.description,
    required this.vat,
    this.installments,
    this.installmentsType,
    this.taxableAmount,
    required this.taxPercentage,
  });
}
