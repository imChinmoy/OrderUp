import 'package:client/features/payment/presentation/screens/razorpay_screen.dart';
import 'package:flutter/material.dart';

class OrderSummaryScreen extends StatelessWidget {
  final double totalAmount;

  const OrderSummaryScreen({required this.totalAmount, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D14),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text("Order Summary"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _summaryRow("Subtotal", "₹$totalAmount"),
            _summaryRow("Delivery Fee", "₹0"),
            _summaryRow(
              "GST (5%)",
              "₹${(totalAmount * 0.05).toStringAsFixed(2)}",
            ),
            const Divider(color: Colors.white24, height: 32),
            _summaryRow(
              "Total Payable",
              "₹${(totalAmount * 1.05).toStringAsFixed(2)}",
              bold: true,
            ),

            const Spacer(),
            _payNowButton(context),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
              fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: bold ? Colors.deepOrange : Colors.white,
              fontSize: 18,
              fontWeight: bold ? FontWeight.w900 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _payNowButton(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepOrange, Colors.deepOrange.shade700],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RazorpayScreen(totalAmount: totalAmount),
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Redirecting to payment gateway..."),
              ),
            );
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                "Pay Now",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
