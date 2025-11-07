import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/order_entity.dart';

final adminOrdersProvider = StateProvider<List<OrderEntity>>((ref) => []);
