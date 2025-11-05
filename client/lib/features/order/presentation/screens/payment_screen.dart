import 'package:flutter/material.dart';
import 'order_success_screen.dart';

class PaymentScreen extends StatefulWidget {
  final double totalAmount;
  const PaymentScreen({Key? key, required this.totalAmount}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selected = "upi";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D14),
      appBar: AppBar(
        title: const Text("Payment"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),

          _paymentTile("UPI", Icons.account_balance_wallet, "upi"),
          _paymentTile("Credit / Debit Card", Icons.credit_card, "card"),
          _paymentTile("Cash on Delivery", Icons.money, "cod"),

          const Spacer(),

          _payButton(),
        ],
      ),
    );
  }

  Widget _paymentTile(String text, IconData icon, String value) {
    final selectedColor = selected == value;

    return GestureDetector(
      onTap: () => setState(() => selected = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: selectedColor ? Colors.deepOrange.withOpacity(0.2) : Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selectedColor ? Colors.deepOrange : Colors.white.withOpacity(0.1),
            width: selectedColor ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 26),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            Icon(
              selectedColor ? Icons.check_circle : Icons.circle_outlined,
              color: selectedColor ? Colors.deepOrange : Colors.white54,
            ),
          ],
        ),
      ),
    );
  }

  Widget _payButton() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => OrderSuccessScreen(totalAmount: widget.totalAmount),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              "Pay ₹${widget.totalAmount.toStringAsFixed(2)}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
