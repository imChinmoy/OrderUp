// import 'package:client/features/admin/data/datasource/socket_service.dart';
// import 'package:client/features/admin/domain/entities/order_entity.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../domain/usecases/get_orders_usecase.dart';
// import '../../data/repositories/order_repository_impl.dart';
// import '../../domain/repositories/order_repository.dart';

// final socketServiceProvider = Provider<SocketService>((ref) {
//   return SocketService();
// });

// final orderRepositoryProvider = Provider<OrderRepository>((ref) {
//   final socket = ref.watch(socketServiceProvider);
//   return OrderRepositoryImpl(socket);
// });

// final getOrdersUseCaseProvider = Provider<GetOrdersUseCase>((ref) {
//   final repository = ref.watch(orderRepositoryProvider);
//   return GetOrdersUseCase(repository);
// });

// final ordersStreamProvider = StreamProvider.autoDispose<List<OrderEntity>>((ref) {
//   final usecase = ref.watch(getOrdersUseCaseProvider);
//   return usecase();
// });
