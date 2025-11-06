import 'package:client/features/order/presentation/providers/cart_provider.dart';
import 'package:client/features/payment/presentation/providers/payment_provider.dart';
import 'package:client/features/profile/features/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

/// If your backend doesn't return the Razorpay key_id,
/// put your test/live key here (or inject via .env).
const String kRazorpayKeyId = 'rzp_test_1234567890abcdef';

class RazorpayScreen extends ConsumerStatefulWidget {
  final double totalAmount; // in INR (rupees)
  const RazorpayScreen({Key? key, required this.totalAmount}) : super(key: key);

  @override
  ConsumerState<RazorpayScreen> createState() => _RazorpayScreenState();
}

class _RazorpayScreenState extends ConsumerState<RazorpayScreen> {
  late Razorpay _razorpay;
  bool _opening = false;
  bool _success = false;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onPaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _onPaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _onExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  Future<void> _startPayment() async {
    if (_opening) return;
    setState(() => _opening = true);

    try {
      // 1) User & cart
      final profile = await ref.read(profileProvider.future);
      final userId = profile?['id'] as String?;
      final email = profile?['email'] as String? ?? '';
      final phone = profile?['phone'] as String? ?? '';

      if (userId == null || userId.isEmpty) {
        _toast('User not logged in');
        return;
      }

      final cart = ref.read(cartProvider);
      if (cart.isEmpty) {
        _toast('Cart is empty');
        return;
      }

      // 2) Create order on your server (returns orderId, amount in paise, currency)
      final createOrder = ref.read(createPaymentOrderProvider);
      final order = await createOrder(
        amountInRupees: widget.totalAmount,
        userId: userId,
      );

      // 3) Open Razorpay Checkout
      final options = {
        'key': order.keyId,          // Use your key_id (test/live)
        'amount': order.amount,         // in paise (server already returns paise)
        'order_id': order.orderId,
        'currency': order.currency,     // e.g., "INR"
        'name': 'OrderUp',
        'description': 'Food Order Payment',
        'prefill': {
          'email': email,
          'contact': phone,
        },
        'theme': {'color': '#FF6B35'},
      };

      _razorpay.open(options);
    } catch (e) {
      _toast('Failed to start payment: $e');
    } finally {
      if (mounted) setState(() => _opening = false);
    }
  }

  Future<void> _onPaymentSuccess(PaymentSuccessResponse res) async {
    setState(() => _success = true);

    try {
      final profile = await ref.read(profileProvider.future);
      final userId = profile?['id'] as String?;
      if (userId == null) {
        _toast('User missing during verification');
        return;
      }

      final cart = ref.read(cartProvider);

      // 4) Verify payment on your server (also creates the order in DB)
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
        await Future.delayed(const Duration(milliseconds: 900));
        if (mounted) Navigator.pop(context, true);
      } else {
        _toast('Payment verification failed');
      }
    } catch (e) {
      _toast('Verification error: $e');
    }
  }

  void _onPaymentError(PaymentFailureResponse res) {
    _toast('Payment failed: ${res.message ?? res.code}');
  }

  void _onExternalWallet(ExternalWalletResponse res) {
    _toast('External wallet: ${res.walletName}');
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final amountText = '₹${widget.totalAmount.toStringAsFixed(2)}';

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B13),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('Secure Payment'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(28),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // lock emblem
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.08),
                          Colors.white.withOpacity(0.02),
                        ],
                      ),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: const Icon(Icons.lock_outline,
                        color: Colors.white70, size: 42),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'You’re paying',
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    amountText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Pay button
                  InkWell(
                    onTap: _startPayment,
                    borderRadius: BorderRadius.circular(16),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 56),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: _opening
                              ? [Colors.grey.shade600, Colors.grey.shade800]
                              : const [Color(0xFFFF6B35), Color(0xFFFF8C42)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepOrange.withOpacity(0.35),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Text(
                        _opening ? 'Please wait…' : 'Pay Securely',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // success pulse
          if (_success)
            Center(
              child: AnimatedScale(
                scale: _success ? 1 : 0.7,
                duration: const Duration(milliseconds: 380),
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.45),
                        blurRadius: 24,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 58),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
