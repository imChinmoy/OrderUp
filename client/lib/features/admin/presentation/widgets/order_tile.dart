import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/order_entity.dart';

class OrderTile extends ConsumerWidget {
  final OrderEntity order;
  const OrderTile({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.35),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(),
                const SizedBox(height: 12),
                _itemList(),
                const SizedBox(height: 12),
                _footer(ref),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            "#${(order.id ?? '').substring(0, 6).toUpperCase()}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            "Customer: ${order.userName ?? 'Unknown'}",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _itemList() {
    final items = order.items ?? [];
    if (items.isEmpty) {
      return const Text(
        "No items in this order",
        style: TextStyle(color: Colors.white54, fontSize: 13),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.imageUrl.isNotEmpty
                      ? item.imageUrl
                      : "https://via.placeholder.com/36",
                  width: 36,
                  height: 36,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 36,
                    height: 36,
                    color: Colors.grey.shade800,
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.white38,
                      size: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "${item.name}  x${item.quantity}",
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _footer(WidgetRef ref) {
    final formatter = NumberFormat.currency(symbol: "₹", decimalDigits: 0);
    final formattedAmount = formatter.format(order.totalAmount ?? 0);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          formattedAmount,
          style: const TextStyle(
            color: Colors.deepOrange,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        _statusButton(ref),
      ],
    );
  }

  Widget _statusButton(WidgetRef ref) {
    String nextStatus;
    String label;
    Color accent;

    switch (order.status) {
      case "received":
        nextStatus = "accepted";
        label = "Accept";
        accent = Colors.blue;
        break;
      case "accepted":
        nextStatus = "preparing";
        label = "Cooking";
        accent = Colors.orange;
        break;
      case "preparing":
        nextStatus = "ready";
        label = "Ready";
        accent = Colors.green;
        break;
      case "ready":
        nextStatus = "delivered";
        label = "Deliver";
        accent = Colors.purple;
        break;
      default:
        return const Text(
          "Completed",
          style: TextStyle(
            color: Colors.greenAccent,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        );
    }

    return GestureDetector(
      onTap: () {
        // TODO: add order status update call if needed
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: accent.withOpacity(0.15),
          border: Border.all(color: accent.withOpacity(0.4)),
          boxShadow: [
            BoxShadow(
              color: accent.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: accent,
            fontWeight: FontWeight.w800,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
