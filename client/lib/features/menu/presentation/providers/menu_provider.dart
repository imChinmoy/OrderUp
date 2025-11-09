import 'package:client/features/menu/data/api/menu_service.dart';
import 'package:client/features/menu/domain/usecases/get_available_item_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../data/repositories/menu_repo_impl.dart';
import '../../domain/entities/menu_item_entity.dart';
import '../../domain/usecases/get_menu_item_usecase.dart';
import '../../domain/usecases/get_treanding_item_usecase.dart';



final menuProvider = FutureProvider<List<MenuItemEntity>>((ref) async {
  final client = http.Client();
  final service = MenuServiceImpl(client);
  final repo = MenuRepositoryImpl(service);
  final usecase = GetMenuItemsUseCase(repo);

  final menuItems = await usecase();

  client.close();
  return menuItems;
});


final trendingMenuProvider = FutureProvider<List<MenuItemEntity>>((ref) async {
  final client = http.Client();
  final service = MenuServiceImpl(client);
  final repo = MenuRepositoryImpl(service);
  final usecase = GetTrendingItemsUseCase(repo);

  final trendingItems = await usecase();

  client.close();
  return trendingItems;
});

final availableMenuProvider = FutureProvider<List<MenuItemEntity>>((ref) async {
  final client = http.Client();
  final service = MenuServiceImpl(client);
  final repo = MenuRepositoryImpl(service);
  final usecase = GetAvailableItemsUseCase(repo);

  final availableItems = await usecase();

  client.close();
  return availableItems;
});

