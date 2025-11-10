import 'package:client/features/admin/presentation/providers/order_socket_provider.dart';
import 'package:client/features/order/presentation/providers/cart_provider.dart';
import 'package:client/features/order/presentation/screens/order_success_screen.dart';
import 'package:client/features/orderHistory/presentation/providers/student_order_provider.dart';
import 'package:client/features/payment/presentation/providers/payment_provider.dart';
import 'package:client/features/profile/features/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

const String kRazorpayKeyId = 'rzp_test_RcDdOSpKhFqVpl';

class RazorpayScreen extends ConsumerStatefulWidget {
  final double totalAmount;
  const RazorpayScreen({Key? key, required this.totalAmount}) : super(key: key);

  @override
  ConsumerState<RazorpayScreen> createState() => _RazorpayScreenState();
}

class _RazorpayScreenState extends ConsumerState<RazorpayScreen> {
  late Razorpay _razorpay;
  bool _loading = false;
  bool _successAnim = false;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onPaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _onError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _onExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  Future<void> _startPayment() async {
    setState(() => _loading = true);

    try {
      final profile = await ref.read(profileProvider.future);
      final userId = profile?['id'] as String?;

      if (userId == null) {
        _toast("User not logged in");
        return;
      }

      final createOrder = ref.read(createPaymentOrderProvider);
      final order = await createOrder(
        amountInRupees: widget.totalAmount,
        userId: userId,
      );

      final options = {
        'key': kRazorpayKeyId,
        'amount': order.amount,
        'order_id': order.orderId,
        'currency': order.currency,
        'name': 'OrderUp',
        'description': 'Secure Food Payment',
        'theme': {'color': '#FF6B35'},
        'prefill': {
          'email': profile?['email'] ?? '',
          'contact': profile?['phone'] ?? '',
        },
      };

      _razorpay.open(options);
    } catch (e) {
      _toast("Failed to start payment: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _onPaymentSuccess(PaymentSuccessResponse res) async {
  bool _success;
  setState(() => _success = true);

  try {
    final profile = await ref.read(profileProvider.future);
    final userId = profile?['id'] as String?;
    if (userId == null) {
      _toast('User missing during verification');
      return;
    }

    final cart = ref.read(cartProvider);

    final verify = ref.read(verifyPaymentProvider);
    final ok = await verify(
      razorpayOrderId: res.orderId!,
      razorpayPaymentId: res.paymentId!,
      razorpaySignature: res.signature!,
      userId: userId,
      items: cart
          .map((e) => {
                'itemId': e.id,
                'name': e.name,
                'price': e.price,
                'quantity': e.quantity,
                'imageUrl': e.imageUrl,
              })
          .toList(),
      totalAmount: widget.totalAmount,
    );

    if (ok) {
      ref.read(cartProvider.notifier).clear();
      await Future.delayed(const Duration(milliseconds: 300));
      ref.invalidate(studentOrdersStreamProvider);
      ref.invalidate(adminOrdersStreamProvider);
      /* Navigator.pushReplacement(
        context,
      //  MaterialPageRoute(
          builder: (_) => OrderSuccessScreen(totalAmount: widget.totalAmount),
        ),
      ); */
      context.go('/order-success', extra: widget.totalAmount);
    } else {
      _toast('Payment verification failed');
    }
  } catch (e) {
    _toast('Verification error: $e');
  }
}


  void _onError(PaymentFailureResponse res) {
    _toast("Payment Failed: ${res.message}");
  }

  void _onExternalWallet(ExternalWalletResponse res) {
    _toast("External Wallet: ${res.walletName}");
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final amountText = "₹${widget.totalAmount.toStringAsFixed(2)}";

    return Scaffold(
      backgroundColor: const Color(0xFF0C0C14),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text("Secure Payment"),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // UI
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05),
                  ),
                  child: const Icon(
                    Icons.lock_outline,
                    size: 50,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "You're paying",
                  style: TextStyle(color: Colors.white54, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  amountText,
                  style: const TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),

                GestureDetector(
                  onTap: _loading ? null : _startPayment,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 48,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _loading
                            ? [Colors.grey, Colors.grey.shade700]
                            : [Colors.deepOrange, Colors.orange],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepOrange.withOpacity(0.3),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Text(
                      _loading ? "Processing..." : "Pay Securely",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (_successAnim)
            Center(
              child: AnimatedScale(
                duration: const Duration(milliseconds: 300),
                scale: 1,
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.4),
                        blurRadius: 24,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.check, size: 60, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
