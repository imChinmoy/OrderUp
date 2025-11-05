import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/features/order/presentation/providers/cart_provider.dart';
import 'package:client/features/order/presentation/screens/order_summary_screen.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  bool isScrolling = false;

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);

    final totalPrice = cartItems.fold(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D14),
      body: SafeArea(
        child: cartItems.isEmpty
            ? _buildEmptyCart(context)
            : _buildCartContent(context, cartItems, totalPrice),
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [Colors.deepOrange, Colors.deepOrange.shade700],
            ).createShader(bounds),
            child: const Icon(
              Icons.shopping_cart_outlined,
              size: 120,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Your cart is empty",
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Add some delicious food!",
            style: TextStyle(color: Colors.white54, fontSize: 16),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
              backgroundColor: Colors.deepOrange,
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Browse Foods",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(
    BuildContext context,
    List cartItems,
    double totalPrice,
  ) {
    return Stack(
      children: [
        Column(
          children: [
            _buildHeader(),

            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (scroll) {
                  if (scroll is ScrollStartNotification) {
                    setState(() => isScrolling = true);
                  } else if (scroll is ScrollEndNotification) {
                    Future.delayed(const Duration(milliseconds: 200), () {
                      if (mounted) setState(() => isScrolling = false);
                    });
                  }
                  return true;
                },
                child: Stack(
                  children: [
                    ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        0,
                        20,
                        140,
                      ),
                      itemCount: cartItems.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        return _buildDismissibleItem(item);
                      },
                    ),
                    if (isScrolling)
                      IgnorePointer(
                        child: AnimatedOpacity(
                          opacity: 1,
                          duration: const Duration(milliseconds: 150),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                            child: Container(color: Colors.transparent),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            _checkoutBar(context, totalPrice),
          ],
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
          const Text(
            "My Cart",
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildDismissibleItem(cartItem) {
    return Dismissible(
      key: Key(cartItem.id),
      direction: DismissDirection.endToStart,
      background: _deleteBackground(),
      onDismissed: (_) {
        ref.read(cartProvider.notifier).remove(cartItem.id);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${cartItem.name} removed"),
            backgroundColor: Colors.redAccent,
          ),
        );
      },
      child: _buildCartItemTile(cartItem),
    );
  }

  Widget _deleteBackground() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.15),
        borderRadius: BorderRadius.circular(18),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 30),
      child: const Icon(Icons.delete, color: Colors.redAccent, size: 28),
    );
  }

  Widget _buildCartItemTile(cartItem) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.07),
            Colors.white.withOpacity(0.02),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.45),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                cartItem.imageUrl,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "₹${cartItem.price}",
                    style: const TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),

            Row(
              children: [
                _qtyButton(Icons.remove, () {
                  ref.read(cartProvider.notifier).decreaseQuantity(cartItem.id);
                }),
                const SizedBox(width: 10),
                Text(
                  cartItem.quantity.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 10),
                _qtyButton(Icons.add, () {
                  ref.read(cartProvider.notifier).increaseQuantity(cartItem.id);
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
  Widget _checkoutBar(BuildContext context, double totalPrice) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 18,
                  ),
                ),
                Text(
                  "₹${totalPrice.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OrderSummaryScreen(totalAmount: totalPrice),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepOrange, Colors.deepOrange.shade700],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text(
                    "Proceed to Checkout",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
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
