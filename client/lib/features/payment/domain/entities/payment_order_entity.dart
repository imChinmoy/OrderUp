class PaymentOrderEntity {
  final String orderId;
  final int amount;        // paise
  final String currency;   // "INR"

  const PaymentOrderEntity({
    required this.orderId,
    required this.amount,
    required this.currency,
  });
}
