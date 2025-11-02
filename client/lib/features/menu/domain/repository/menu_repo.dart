import '../entities/menu_item_entity.dart';

abstract class MenuRepository {
  Future<List<MenuItemEntity>> getMenuItems();
  Future<List<MenuItemEntity>> getTrendingMenuItems();
}
