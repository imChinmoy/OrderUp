import '../entities/menu_item_entity.dart';
import '../repository/menu_repo.dart';

class GetMenuItemsUseCase {
  final MenuRepository repository;

  GetMenuItemsUseCase(this.repository);

  Future<List<MenuItemEntity>> call() async {
    return await repository.getMenuItems();
  }
}

// class GetTrendingItemsUseCase {
//   final MenuRepository repository;

//   GetTrendingItemsUseCase(this.repository);

//   Future<List<MenuItemEntity>> call() async {
//     return await repository.getTrendingMenuItems();
//   }
// }
