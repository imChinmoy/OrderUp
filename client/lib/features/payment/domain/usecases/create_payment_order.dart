import '../entities/payment_order_entity.dart';
import '../repositories/payment_repository.dart';

class CreatePaymentOrder {
  final PaymentRepository repo;
  CreatePaymentOrder(this.repo);

  Future<PaymentOrderEntity> call({
    required double amountInRupees,
    required String userId,
  }) {
    return repo.createPaymentOrder(
      amountInRupees: amountInRupees,
      userId: userId,
    );
  }
}
