class PaymentOrderEntity {
  final String orderId;
  final int amount;        // paise
  final String currency;   // "INR"
  final String keyId;

  const PaymentOrderEntity({
    required this.orderId,
    required this.amount,
    required this.currency,
    required this.keyId,
  });
}
