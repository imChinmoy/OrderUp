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
        backgroundColor: const Color(0xFF0D0D14),
        elevation: 1,
        automaticallyImplyLeading: false, 
        title: const Text(
          'My Orders',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
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

          // Create a copy and sort by most recent first
          final sortedOrders = List<OrderEntity>.from(orders);
          sortedOrders.sort((a, b) {
            final aDate = a.createdAt ?? DateTime(1970);
            final bDate = b.createdAt ?? DateTime(1970);
            return bDate.compareTo(aDate); // Most recent first
          });

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sortedOrders.length,
            itemBuilder: (_, i) => _orderCard(context, sortedOrders[i]),
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
          Icon(
            Icons.shopping_bag_outlined,
            size: 90,
            color: Colors.white.withOpacity(0.2),
          ),
          const SizedBox(height: 14),
          const Text(
            "No orders placed yet",
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ),
          const SizedBox(height: 4),
          Text(
            "Your orders will appear here",
            style: TextStyle(color: Colors.white.withOpacity(0.4)),
          ),
        ],
      ),
    );
  }

  Widget _orderCard(BuildContext context, OrderEntity o) {
    final statusColor = _statusColor(o.status);
    final formatter = DateFormat('dd MMM, hh:mm a');

    return Container(
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
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                o.items?.isNotEmpty == true ? o.items!.first.imageUrl : '',
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
            ),
            const SizedBox(width: 12),

            // Order Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order ID: ${o.id}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Order Items List
                  if (o.items != null)
                    ...o.items!.map(
                      (item) => Padding(
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
                      ),
                    ),
                  const SizedBox(height: 8),

                  // Order Date
                  Text(
                    'Order placed on ${formatter.format(o.createdAt ?? DateTime.now())}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.4),
                    ),
                  ),
                  const SizedBox(height: 2),

                  // Status
                  Text(
                    o.status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      color: statusColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Price and Menu
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.more_vert, size: 20),
                  color: Colors.white.withOpacity(0.4),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    // Add your menu options here
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  '₹${o.totalAmount}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepOrange,
                  ),
                ),
              ],
            ),
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
