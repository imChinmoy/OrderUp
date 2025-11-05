import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../data/models/cart_item.dart';

final cartProvider =
    StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<List<CartItem>> {
  static const String _boxName = "cart_box";

  CartNotifier() : super([]) {
    _loadCart();
  }

  Future<void> _loadCart() async {
    final box = await Hive.openBox(_boxName);
    final saved = box.get("items");

    if (saved != null) {
      final decoded = jsonDecode(saved) as List;
      state = decoded.map((e) => CartItem.fromJson(e)).toList();
    }
  }

  Future<void> _saveCart() async {
    final box = await Hive.openBox(_boxName);
    final encoded = jsonEncode(state.map((e) => e.toJson()).toList());
    await box.put("items", encoded);
  }

  void addToCart(CartItem item) {
    final index = state.indexWhere((e) => e.id == item.id);

    if (index == -1) {
      state = [...state, item];
    } else {
      state = [
        for (final e in state)
          e.id == item.id ? e.copyWith(quantity: e.quantity + item.quantity) : e
      ];
    }

    _saveCart();
  }

  void increaseQuantity(String id) {
    state = [
      for (final e in state)
        e.id == id ? e.copyWith(quantity: e.quantity + 1) : e
    ];
    _saveCart();
  }

  void decreaseQuantity(String id) {
    state = [
      for (final e in state)
        e.id == id && e.quantity > 1
            ? e.copyWith(quantity: e.quantity - 1)
            : e
    ];
    _saveCart();
  }

  void remove(String id) {
    state = state.where((e) => e.id != id).toList();
    _saveCart();
  }

  void clear() {
    state = [];
    _saveCart();
  }
}
