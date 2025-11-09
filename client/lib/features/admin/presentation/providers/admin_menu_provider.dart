import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../data/models/menu_model.dart';
import '../../data/datasource/menu_remote_datasource.dart';
import '../../data/repositories/menu_repository_impl.dart';

final adminMenuProvider =
    StateNotifierProvider<AdminMenuNotifier, List<MenuModel>>(
  (ref) => AdminMenuNotifier(MenuRepositoryImpl(MenuRemoteDataSource())),
);

class AdminMenuNotifier extends StateNotifier<List<MenuModel>> {
  final MenuRepositoryImpl repo;
  
  final _cacheBox = Hive.box("menu_cache");

  AdminMenuNotifier(this.repo) : super([]) {
    _loadItems();
  }

  Future<void> _loadItems() async {
    final cached = _cacheBox.get("menu_items");
    if (cached != null) {
      state = (cached as List)
          .map((e) => MenuModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    final items = await repo.getAllItems();
    state = items;

    _cacheBox.put("menu_items", items.map((e) => e.toJson()).toList());
  }

  Future<void> addItem(Map<String, dynamic> body) async {
    final newItem = await repo.addItem(body);
    state = [...state, newItem];
    _cacheBox.put("menu_items", state.map((e) => e.toJson()).toList());
  }

  Future<void> toggleStock(MenuModel item) async {
    final updated = await repo.updateItemStock(item.id, !item.isAvailable);
    state = [
      for (final i in state)
        if (i.id == updated.id) updated else i
    ];

    _cacheBox.put("menu_items", state.map((e) => e.toJson()).toList());
  }

  Future<void> deleteItem(MenuModel item) async {
    final ok = await repo.deleteItem(item.id);
    if (!ok) return;

    state = state.where((i) => i.id != item.id).toList();
    _cacheBox.put("menu_items", state.map((e) => e.toJson()).toList());
  }
}
