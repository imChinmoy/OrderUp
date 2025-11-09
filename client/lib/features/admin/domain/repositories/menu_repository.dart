import '../entities/menu_entity.dart';

abstract class MenuRepository {
  Future<List<MenuEntity>> getAllItems();
  Future<MenuEntity> updateItemStock(String id, bool newStock);
  Future<bool> deleteItem(String id);
  Future<MenuEntity> addItem(Map<String, dynamic> data);
}
