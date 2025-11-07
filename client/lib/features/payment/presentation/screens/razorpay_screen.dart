import 'package:client/features/order/presentation/providers/cart_provider.dart';
import 'package:client/features/payment/presentation/providers/payment_provider.dart';
import 'package:client/features/profile/features/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

/// Your test or live KEY_FROM_RAZORPAY_DASHBOARD
const String kRazorpayKeyId = "rzp_test_1234567890ABCDEF";

class RazorpayScreen extends ConsumerStatefulWidget {
  final double totalAmount;
  const RazorpayScreen({required this.totalAmount, Key? key}) : super(key: key);

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
      final profile = await ref.read(profileProvider.future);
      final userId = profile?['id']?.toString();
      final email = profile?['email']?.toString() ?? "test@example.com";
      final phone = profile?['phone']?.toString() ?? "9999999999";

      if (userId == null) {
        _toast("User not logged in");
        return;
      }

      final cart = ref.read(cartProvider);
      if (cart.isEmpty) {
        _toast("Cart empty");
        return;
      }

      /// 1) Create Order on Server
      final createOrder = ref.read(createPaymentOrderProvider);
      final serverOrder = await createOrder(
        amountInRupees: widget.totalAmount,
        userId: userId,
      );

      /// Razorpay options — key coming from LOCAL CONSTANT
      final options = {
        'key': kRazorpayKeyId,
        'amount': serverOrder.amount, // paise from backend
        'order_id': serverOrder.orderId,
        'currency': serverOrder.currency,
        'name': 'OrderUp',
        'description': 'Food Order Payment',
        'prefill': {
          'email': email,
          'contact': phone,
        },
        'theme': {'color': '#FF6B35'}
      };

      _razorpay.open(options);
    } catch (e) {
      _toast("Failed to start payment: $e");
    } finally {
      if (mounted) setState(() => _opening = false);
    }
  }

  Future<void> _onPaymentSuccess(PaymentSuccessResponse res) async {
    setState(() => _success = true);

    try {
      final profile = await ref.read(profileProvider.future);
      final userId = profile?['id']?.toString();
      if (userId == null) return _toast("User missing");

      final cart = ref.read(cartProvider);

      /// 2) Verify on server
      final verify = ref.read(verifyPaymentProvider);
      final ok = await verify(
        razorpayOrderId: res.orderId!,
        razorpayPaymentId: res.paymentId!,
        razorpaySignature: res.signature!,
        userId: userId,
        totalAmount: widget.totalAmount,
        items: cart
            .map((e) => {
                  "itemId": e.id,
                  "name": e.name,
                  "price": e.price,
                  "quantity": e.quantity,
                  "imageUrl": e.imageUrl,
                })
            .toList(),
      );

      if (ok) {
        ref.read(cartProvider.notifier).clear();
        await Future.delayed(const Duration(milliseconds: 900));
        if (mounted) Navigator.pop(context, true);
      } else {
        _toast("Payment verification failed");
      }
    } catch (e) {
      _toast("Verification error: $e");
    }
  }

  void _onPaymentError(PaymentFailureResponse res) {
    _toast("Payment failed: ${res.message ?? res.code}");
  }

  void _onExternalWallet(ExternalWalletResponse res) {
    _toast("External wallet: ${res.walletName}");
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final amountText = "₹${widget.totalAmount.toStringAsFixed(2)}";

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B13),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text("Secure Payment"),
      ),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// Lock icon
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Colors.white.withOpacity(0.15), width: 2),
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.08),
                          Colors.white.withOpacity(0.01),
                        ],
                      ),
                    ),
                    child: const Icon(Icons.lock_outline,
                        color: Colors.white, size: 42),
                  ),
                  const SizedBox(height: 18),
                  const Text("You're paying",
                      style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 6),
                  Text(
                    amountText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 28),

                  GestureDetector(
                    onTap: _startPayment,
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
                              color: Colors.deepOrange.withOpacity(0.4),
                              blurRadius: 16)
                        ],
                      ),
                      child: Text(
                        _opening ? "Processing..." : "Pay Securely",
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

          /// Success animation
          if (_success)
            Center(
              child: AnimatedScale(
                duration: const Duration(milliseconds: 400),
                scale: _success ? 1 : 0.5,
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.green.withOpacity(0.4),
                          blurRadius: 25)
                    ],
                  ),
                  child: const Icon(Icons.check,
                      color: Colors.white, size: 65),
                ),
              ),
            )
        ],
      ),
    );
  }
}
