import 'dart:convert';
import 'package:client/features/order/data/models/cart_item.dart';
import 'package:hive/hive.dart';

class HiveCartStorage {
  final String boxName = "cartBox";

  Future<void> saveCart(List<CartItem> items) async {
    final box = await Hive.openBox(boxName);
    final jsonList = items.map((e) => e.toJson()).toList();
    await box.put('cart', jsonEncode(jsonList));
  }

  Future<List<CartItem>> getCart() async {
    final box = await Hive.openBox(boxName);
    final jsonString = box.get('cart');
    if (jsonString == null) return [];
    final list = jsonDecode(jsonString) as List;
    return list.map((e) => CartItem.fromJson(e)).toList();
  }

  Future<void> clearCart() async {
    final box = await Hive.openBox(boxName);
    await box.delete('cart');
  }
}
