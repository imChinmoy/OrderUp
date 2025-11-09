import 'package:hive/hive.dart';
import '../models/menu_model.dart';

class MenuLocalStorage {
  static const String boxName = "menu_cache";

  Future<void> saveItems(List<MenuModel> items) async {
    final box = await Hive.openBox(boxName);
    final jsonList = items.map((i) => i.toJson()).toList();
    await box.put("items", jsonList);
  }

  Future<List<MenuModel>> loadItems() async {
    final box = await Hive.openBox(boxName);
    final data = box.get("items");

    if (data == null) return [];

    return (data as List)
        .map((e) => MenuModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> clear() async {
    final box = await Hive.openBox(boxName);
    await box.clear();
  }
}
