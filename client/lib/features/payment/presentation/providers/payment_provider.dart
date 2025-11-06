import 'package:client/features/payment/data/datasource/payment_remote_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/payment_repository_impl.dart';
import '../../domain/usecases/create_payment_order.dart';
import '../../domain/usecases/verify_payment.dart';

final _paymentRemoteDSProvider = Provider((ref) => PaymentRemoteDataSource());
final _paymentRepoProvider =
    Provider((ref) => PaymentRepositoryImpl(ref.read(_paymentRemoteDSProvider)));

final createPaymentOrderProvider =
    Provider((ref) => CreatePaymentOrder(ref.read(_paymentRepoProvider)));

final verifyPaymentProvider =
    Provider((ref) => VerifyPayment(ref.read(_paymentRepoProvider)));
