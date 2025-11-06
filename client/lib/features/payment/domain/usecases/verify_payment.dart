import '../repositories/payment_repository.dart';

class VerifyPayment {
  final PaymentRepository repo;
  VerifyPayment(this.repo);

  Future<bool> call({
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
    required String userId,
    required List<Map<String, dynamic>> items,
    required double totalAmount,
  }) {
    return repo.verifyPayment(
      razorpayOrderId: razorpayOrderId,
      razorpayPaymentId: razorpayPaymentId,
      razorpaySignature: razorpaySignature,
      userId: userId,
      items: items,
      totalAmount: totalAmount,
    );
  }
}
