// import 'package:flutter/material.dart';
// import '../../domain/entities/order_entity.dart';

// class OrderTile extends StatelessWidget {
//   final OrderEntity order;

//   const OrderTile({super.key, required this.order});

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: Text(order.itemName, style: const TextStyle(fontWeight: FontWeight.bold)),
//       subtitle: Text("Qty: ${order.quantity}, Status: ${order.status}"),
//       trailing: Text(order.status),
//       leading: CircleAvatar(child: Text(order.itemName[0].toUpperCase())),
//       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//     );
//   }
// }
