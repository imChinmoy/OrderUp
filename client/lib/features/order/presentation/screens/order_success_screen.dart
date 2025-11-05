import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OrderSuccessScreen extends StatefulWidget {
  final double totalAmount;
  const OrderSuccessScreen({Key? key, required this.totalAmount}) : super(key: key);

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(milliseconds: 3500), () {
      if (mounted) {
        Navigator.popUntil(context, (route) => route.settings.name == 'home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D14),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 180,
              child: Lottie.network(
                "https://assets8.lottiefiles.com/packages/lf20_jbrw3hcz.json",
              ),
            ),

            const SizedBox(height: 14),
            const Text(
              "Order Placed!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),

            Text(
              "₹${widget.totalAmount.toStringAsFixed(2)} paid successfully",
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 40),

            AnimatedContainer(
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
              height: 56,
              width: 200,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepOrange.withOpacity(0.6),
                    blurRadius: 20,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.settings.name == 'home');
                },
                child: const Text(
                  "Continue",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
