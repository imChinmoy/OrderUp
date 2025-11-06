import 'dart:convert';
import 'package:client/core/api_endpoints.dart';
import 'package:client/features/payment/domain/entities/payment_order_entity.dart';
import 'package:http/http.dart' as http;

class PaymentRemoteDataSource {
  static const String _base = ApiConfig.baseUrl;

  Future<PaymentOrderEntity> createOrder({
    required double amountInRupees,
    required String userId,
  }) async {
    final url = Uri.parse('$_base${ApiEndpoints.createOrder}');

    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'amount': amountInRupees,
        'userId': userId,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to create Razorpay order: ${res.body}');
    }

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return PaymentOrderEntity(
      orderId: data['orderId'],
      amount: data['amount'],
      currency: data['currency'],
      keyId: data['keyId'],
    );
  }

  Future<bool> verifyPayment({
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
    required String userId,
    required List<Map<String, dynamic>> items,
    required double totalAmount,
  }) async {
    final url = Uri.parse('$_base${ApiEndpoints.verifyPayment}');

    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'orderId': razorpayOrderId,
        'paymentId': razorpayPaymentId,
        'signature': razorpaySignature,
        'userId': userId,
        'items': items,
        'totalAmount': totalAmount,
      }),
    );

    if (res.statusCode != 200) return false;

    final data = jsonDecode(res.body);
    return data['success'] == true;
  }
}
