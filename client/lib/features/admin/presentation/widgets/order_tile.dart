import 'dart:ui';
import 'package:client/utils/qr_scan_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/order_entity.dart';

class OrderTile extends ConsumerWidget {
  final OrderEntity order;
  const OrderTile({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatter = NumberFormat.currency(symbol: "₹", decimalDigits: 0);
    final formattedAmount = formatter.format(order.totalAmount ?? 0);
    final statusColor = _statusColor(order.status);

    return GestureDetector(
      onTap: () {
        Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const QRScanScreen(),
        ),
    );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // First Item Image
              _firstItemImage(),
              const SizedBox(width: 12),
      
              // Order Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order ID
                    Text(
                      'Order ID: ${(order.id ?? '').substring(0, 8).toUpperCase()}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    
                    // Customer Name
                    Text(
                      'Customer: ${order.userName ?? 'Unknown'}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Order Items List
                    _itemsList(),
                    const SizedBox(height: 8),
      
                    // Order Date
                    Text(
                      'Order placed on ${_formatDate(order.createdAt)}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.4),
                      ),
                    ),
                    const SizedBox(height: 2),
      
                    // Status
                    Text(
                      order.status.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        color: statusColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
      
              // Price and Action Button
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formattedAmount,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.deepOrange,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // _statusButton(ref),
                  const Icon(Icons.camera_alt_outlined, color: Colors.blueAccent, size: 30),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _firstItemImage() {
    final items = order.items ?? [];
    final imageUrl = items.isNotEmpty ? items.first.imageUrl : '';

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        imageUrl.isNotEmpty ? imageUrl : 'https://via.placeholder.com/64',
        width: 64,
        height: 64,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 64,
            height: 64,
            color: Colors.white.withOpacity(0.1),
            child: const Icon(
              Icons.fastfood,
              color: Colors.white54,
              size: 28,
            ),
          );
        },
      ),
    );
  }

  Widget _itemsList() {
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
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 80, 228, 50),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '${item.quantity} x',
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
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
      // case "accepted":
      //   nextStatus = "preparing";
      //   label = "Cooking";
      //   accent = Colors.orange;
      //   break;
      // case "preparing":
      //   nextStatus = "ready";
      //   label = "Ready";
      //   accent = Colors.green;
      //   break;
      case "ready":
        nextStatus = "delivered";
        label = "Scan Or";
        accent = Colors.purple;
        break;  
      default:
        return const Text(
          "Completed",
          style: TextStyle(
            color: Colors.greenAccent,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        );
    }

    return GestureDetector(
      onTap: () {
        // TODO: add order status update call if needed
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: accent.withOpacity(0.15),
          border: Border.all(color: accent.withOpacity(0.4)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: accent,
            fontWeight: FontWeight.w700,
            fontSize: 11,
          ),
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case "received":
        return Colors.blueAccent;
      case "accepted":
        return Colors.orange;
      case "preparing":
        return Colors.amber;
      case "ready":
        return Colors.greenAccent;
      case "delivered":
        return Colors.green;
      default:
        return Colors.white70;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown';
    final formatter = DateFormat('dd MMM, hh:mm a');
    return formatter.format(date);
  }
}