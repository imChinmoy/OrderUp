import 'package:client/features/admin/domain/entities/order_entity.dart';
import 'package:client/features/orderHistory/presentation/providers/student_order_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class StudentOrdersScreen extends ConsumerWidget {
  const StudentOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(studentOrdersStreamProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D14),
      appBar: AppBar(
        title: const Text(
          "My Orders",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ordersAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Colors.deepOrange),
        ),
        error: (err, _) => Center(
          child: Text(
            "Error: $err",
            style: const TextStyle(color: Colors.redAccent),
          ),
        ),
        data: (orders) {
          if (orders.isEmpty) {
            return _noOrdersUI();
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (_, i) => _orderCard(context, orders[i]),
          );
        },
      ),
    );
  }

  Widget _noOrdersUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined,
              size: 90, color: Colors.white.withOpacity(0.2)),
          const SizedBox(height: 14),
          const Text(
            "No orders placed yet",
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ),
          const SizedBox(height: 4),
          Text(
            "Your orders will appear here",
            style: TextStyle(color: Colors.white.withOpacity(0.4)),
          )
        ],
      ),
    );
  }

  Widget _orderCard(BuildContext context, OrderEntity o) {
    final statusColor = _statusColor(o.status);
    final formatter = DateFormat('hh:mm a, dd MMM');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "Order #${o.id!.substring(0, 6).toUpperCase()}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Spacer(),

                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    o.status.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            SizedBox(
              height: 70,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: o.items?.length ?? 0,
                itemBuilder: (_, i) {
                  final item = o.items![i];
                  return Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            item.imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 50,
                              height: 50,
                              color: Colors.white.withOpacity(0.1),
                              child: const Icon(Icons.fastfood, size: 20, color: Colors.white54),
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "x${item.quantity}",
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 11),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),
            const Divider(color: Colors.white12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "₹${o.totalAmount}",
                  style: const TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  formatter.format(o.createdAt ?? DateTime.now()),
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.4), fontSize: 12),
                )
              ],
            )

          ],
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
}
