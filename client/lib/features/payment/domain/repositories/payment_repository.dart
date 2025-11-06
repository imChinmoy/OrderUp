import '../entities/payment_order_entity.dart';

abstract class PaymentRepository {
  Future<PaymentOrderEntity> createPaymentOrder({
    required double amountInRupees,
    required String userId,
  });

  Future<bool> verifyPayment({
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
    required String userId,
    required List<Map<String, dynamic>> items, // cart items serialized
    required double totalAmount,               // rupees
  });
}
