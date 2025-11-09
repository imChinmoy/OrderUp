import 'package:client/features/admin/data/datasource/menu_remote_datasource.dart';
import 'package:client/features/admin/data/models/menu_model.dart';
// import 'package:client/features/admin_menu/data/datasource/menu_remote_datasource.dart';
// import 'package:client/features/admin_menu/data/models/menu_model.dart';

class MenuRepositoryImpl {
  final MenuRemoteDataSource remote;

  MenuRepositoryImpl(this.remote);

  Future<List<MenuModel>> getAllItems() async {
    return await remote.getAllItems();
  }

  Future<MenuModel> addItem(Map<String, dynamic> body) async {
    return await remote.addItem(body);
  }

  Future<MenuModel> updateItemStock(String id, bool newStatus) async {
    return await remote.updateStock(id, newStatus);
  }

  Future<bool> deleteItem(String id) async {
    return await remote.deleteItem(id);
  }
}
