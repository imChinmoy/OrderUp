import 'package:client/features/payment/data/datasource/payment_remote_datasource.dart';

import '../../domain/entities/payment_order_entity.dart';
import '../../domain/repositories/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remote;
  PaymentRepositoryImpl(this.remote);

  @override
  Future<PaymentOrderEntity> createPaymentOrder({
    required double amountInRupees,
    required String userId,
  }) {
    return remote.createOrder(
      amountInRupees: amountInRupees,
      userId: userId,
    );
  }

  @override
  Future<bool> verifyPayment({
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
    required String userId,
    required List<Map<String, dynamic>> items,
    required double totalAmount,
  }) {
    return remote.verifyPayment(
      razorpayOrderId: razorpayOrderId,
      razorpayPaymentId: razorpayPaymentId,
      razorpaySignature: razorpaySignature,
      userId: userId,
      items: items,
      totalAmount: totalAmount,
    );
  }
}
