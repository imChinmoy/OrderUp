import 'package:client/features/menu/data/api/menu_service.dart';
import 'package:client/features/menu/domain/entities/menu_item_entity.dart';
import 'package:client/features/menu/domain/repository/menu_repo.dart';


class MenuRepositoryImpl implements MenuRepository {
  final MenuService menuApi;

  MenuRepositoryImpl(this.menuApi);

  @override
  Future<List<MenuItemEntity>> getMenuItems() async {
    final menuModels = await menuApi.fetchMenuItems();
    return menuModels;
  }

  @override
  Future<List<MenuItemEntity>> getTrendingMenuItems() async {
    final trendingModels = await menuApi.fetchTrendingMenuItems();
    return trendingModels;
  }
  
  @override
  Future<List<MenuItemEntity>> getAvailableMenuItems() async {
    final availableItems = await menuApi.fetchAvailableMenuItems();
    return availableItems;
  }
}
